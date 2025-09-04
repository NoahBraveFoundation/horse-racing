import React, { useState, useRef } from 'react';
import { useTicketFlowStore } from '../../store/ticketFlow';
import { graphql, useLazyLoadQuery } from 'react-relay';
import StepHeader from './StepHeader';
import StickySummary from './StickySummary';
import type { SponsorStepQuery } from '../../__generated__/SponsorStepQuery.graphql';

const SponsorQuery = graphql`
  query SponsorStepQuery {
    myCart { id sponsorInterests { id companyName companyLogoBase64 costCents } }
  }
`;

const fileToBase64 = (file: File): Promise<string> => new Promise((resolve, reject) => {
  const reader = new FileReader();
  reader.onload = () => resolve(reader.result as string);
  reader.onerror = reject;
  reader.readAsDataURL(file);
});

interface Props { onBack: () => void; onContinue: () => void }

const SponsorStep: React.FC<Props> = ({ onBack, onContinue }) => {
  const addSponsor = useTicketFlowStore((s) => s.addSponsorToCart);
  const removeSponsor = useTicketFlowStore((s) => s.removeSponsorFromCart);
  const cartRefreshKey = useTicketFlowStore((s) => s.cartRefreshKey);
  const data = useLazyLoadQuery<SponsorStepQuery>(SponsorQuery, {}, { fetchKey: cartRefreshKey, fetchPolicy: 'network-only' });
  const existing = data?.myCart?.sponsorInterests ?? [];

  const [wantSponsor, setWantSponsor] = useState(existing.length > 0);
  const [company, setCompany] = useState(existing[0]?.companyName || '');
  const [amount, setAmount] = useState((existing[0]?.costCents ?? 10000) / 100);
  const [logoBase64, setLogoBase64] = useState<string | undefined>(existing[0]?.companyLogoBase64 || undefined);
  const [loading, setLoading] = useState(false);
  const [dragActive, setDragActive] = useState(false);
  const [uploadError, setUploadError] = useState<string | null>(null);
  const [companyError, setCompanyError] = useState<string | null>(null);
  const [amountError, setAmountError] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const validateAndSetFile = async (file: File) => {
    setUploadError(null);
    if (!file.type.startsWith('image/')) {
      setUploadError('Please upload an image file (PNG, JPG, SVG, etc).');
      return;
    }
    if (file.size > 5 * 1024 * 1024) {
      setUploadError('File is too large. Max size is 5MB.');
      return;
    }
    const b64 = await fileToBase64(file);
    setLogoBase64(b64);
  };

  const onFileChange: React.ChangeEventHandler<HTMLInputElement> = async (e) => {
    const file = e.target.files?.[0];
    if (!file) return;
    await validateAndSetFile(file);
  };

  const onDrop: React.DragEventHandler<HTMLDivElement> = async (e) => {
    e.preventDefault();
    e.stopPropagation();
    setDragActive(false);
    if (e.dataTransfer.files && e.dataTransfer.files.length > 0) {
      const file = e.dataTransfer.files[0];
      await validateAndSetFile(file);
      e.dataTransfer.clearData();
    }
  };

  const handleContinue = async () => {
    const trimmed = company.trim();
    if (wantSponsor) {
      if (!trimmed) {
        setCompanyError('Please enter your company name.');
        return;
      }
      if (amount < 100) {
        setAmountError('Minimum sponsorship is $100.');
        return;
      }
    }

    setLoading(true);
    try {
      if (wantSponsor && trimmed && (existing.length === 0 || existing[0]?.companyName !== trimmed || existing[0]?.companyLogoBase64 !== logoBase64 || existing[0]?.costCents !== Math.round(amount * 100))) {
        await addSponsor(trimmed, amount, logoBase64);
      }
      if (!wantSponsor && existing.length > 0) {
        await removeSponsor(existing[0].id);
      }
      onContinue();
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-noahbrave-50 font-body pb-32">
      <div className="checker-top h-3" style={{ backgroundColor: 'var(--brand)' }} />
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <StepHeader title="Sponsor" subtitle="Step 6 of 8 — Sponsor the event" />

        <div className="bg-white rounded-2xl shadow-xl border border-noahbrave-200 p-8">
          <label className="flex items-start gap-3">
            <input type="checkbox" checked={wantSponsor} onChange={(e) => { setWantSponsor(e.target.checked); if (!e.target.checked) { setCompanyError(null); setAmountError(null); } }} className="mt-1" />
            <span className="text-gray-800">My company wants to sponsor.</span>
          </label>

          {wantSponsor && (
            <div className="mt-4 space-y-6">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Company name</label>
                <input
                  value={company}
                  onChange={(e) => { setCompany(e.target.value); if (companyError && e.target.value.trim()) setCompanyError(null); }}
                  className={`w-full rounded-lg border px-3 py-2 focus:outline-none focus:ring-2 focus:ring-noahbrave-600 ${companyError ? 'border-red-400' : 'border-gray-300'}`}
                  placeholder="Company, Inc."
                  aria-invalid={!!companyError}
                />
                {companyError && <p className="mt-2 text-sm text-red-600">{companyError}</p>}
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Amount (USD)</label>
                <input
                  type="number"
                  min={100}
                  step="1"
                  value={amount}
                  onChange={(e) => { const val = parseFloat(e.target.value); setAmount(isNaN(val) ? 0 : val); if (amountError && val >= 100) setAmountError(null); }}
                  className={`w-full rounded-lg border px-3 py-2 focus:outline-none focus:ring-2 focus:ring-noahbrave-600 ${amountError ? 'border-red-400' : 'border-gray-300'}`}
                  aria-invalid={!!amountError}
                />
                {amountError && <p className="mt-2 text-sm text-red-600">{amountError}</p>}
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Company logo</label>
                <div
                  onDragOver={(e) => { e.preventDefault(); e.stopPropagation(); setDragActive(true); }}
                  onDragEnter={(e) => { e.preventDefault(); e.stopPropagation(); setDragActive(true); }}
                  onDragLeave={(e) => { e.preventDefault(); e.stopPropagation(); setDragActive(false); }}
                  onDrop={onDrop}
                  onClick={() => fileInputRef.current?.click()}
                  className={`relative flex flex-col items-center justify-center rounded-xl border-2 border-dashed p-6 text-center cursor-pointer transition ${dragActive ? 'border-noahbrave-600 bg-noahbrave-50' : 'border-gray-300 hover:border-noahbrave-400'}`}
                  aria-label="Upload company logo by clicking or dragging a file"
                >
                  {!logoBase64 ? (
                    <>
                      <div className="text-gray-700">
                        <div className="text-sm font-medium">Drag & drop your logo here</div>
                        <div className="text-xs text-gray-500 mt-1">or click to browse (PNG, JPG, SVG • up to 5MB)</div>
                      </div>
                    </>
                  ) : (
                    <div className="w-full max-w-xs">
                      <img src={logoBase64} alt="Company logo preview" className="h-24 w-auto mx-auto object-contain rounded-md border border-gray-200 bg-white p-2" />
                      <div className="mt-3 flex items-center justify-center gap-3">
                        <button
                          type="button"
                          onClick={(e) => { e.stopPropagation(); fileInputRef.current?.click(); }}
                          className="px-3 py-1.5 text-sm rounded-md border text-gray-700 hover:bg-gray-50"
                        >
                          Replace logo
                        </button>
                        <button
                          type="button"
                          onClick={(e) => { e.stopPropagation(); setLogoBase64(undefined); }}
                          className="px-3 py-1.5 text-sm rounded-md border text-red-600 hover:bg-red-50"
                        >
                          Remove
                        </button>
                      </div>
                    </div>
                  )}

                  <input
                    ref={fileInputRef}
                    type="file"
                    accept="image/*"
                    className="hidden"
                    onChange={onFileChange}
                  />
                </div>
                {uploadError && <p className="mt-2 text-sm text-red-600">{uploadError}</p>}
              </div>
            </div>
          )}
        </div>
      </div>
      <StickySummary onBack={onBack} onContinue={handleContinue} continueLoading={loading} />
    </div>
  );
};

export default SponsorStep;
