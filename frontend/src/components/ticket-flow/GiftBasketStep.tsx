import React, { useState } from 'react';
import { useTicketFlowStore } from '../../store/ticketFlow';
import { graphql, useLazyLoadQuery } from 'react-relay';
import StepHeader from './StepHeader';
import StickySummary from './StickySummary';

const GiftBasketQuery = graphql`
  query GiftBasketStepQuery {
    myCart { id giftBasketInterests { id description } }
  }
`;

interface Props { onBack: () => void; onContinue: () => void }

const GiftBasketStep: React.FC<Props> = ({ onBack, onContinue }) => {
  const addGift = useTicketFlowStore((s) => s.addGiftBasketToCart);
  const removeGift = useTicketFlowStore((s) => s.removeGiftBasketFromCart);
  const cartRefreshKey = useTicketFlowStore((s) => s.cartRefreshKey);
  const data: any = useLazyLoadQuery(GiftBasketQuery, {}, { fetchKey: cartRefreshKey, fetchPolicy: 'network-only' });
  const existing = data?.myCart?.giftBasketInterests ?? [];

  const [wantGift, setWantGift] = useState(existing.length > 0);
  const [desc, setDesc] = useState(existing[0]?.description || '');
  const [fieldError, setFieldError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleContinue = async () => {
    const trimmed = desc.trim();
    if (wantGift && !trimmed) {
      setFieldError('Please describe your basket.');
      return;
    }

    setLoading(true);
    try {
      if (wantGift && trimmed && (existing.length === 0 || existing[0]?.description !== trimmed)) {
        await addGift(trimmed);
      }
      if (!wantGift && existing.length > 0) {
        await removeGift(existing[0].id);
      }
      onContinue();
    } finally {
      setLoading(false);
    }
  };

  const onDescChange: React.ChangeEventHandler<HTMLTextAreaElement> = (e) => {
    setDesc(e.target.value);
    if (fieldError && e.target.value.trim()) setFieldError(null);
  };

  return (
    <div className="min-h-screen bg-noahbrave-50 font-body pb-32">
      <div className="checker-top h-3" style={{ backgroundColor: 'var(--brand)' }} />
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <StepHeader title="Raffle Basket (Optional)" subtitle="Step 5 of 8 — Donate a raffle basket" />

        <div className="bg-white rounded-2xl shadow-xl border border-noahbrave-200 p-8">
          <label className="flex items-start gap-3">
            <input type="checkbox" checked={wantGift} onChange={(e) => { setWantGift(e.target.checked); if (!e.target.checked) setFieldError(null); }} className="mt-1" />
            <span className="text-gray-800">I want to donate a raffle basket.</span>
          </label>

          {wantGift && (
            <div className="mt-4">
              <label className="block text-sm font-medium text-gray-700 mb-1">Describe your basket</label>
              <textarea
                value={desc}
                onChange={onDescChange}
                className={`w-full rounded-lg border px-3 py-2 focus:outline-none focus:ring-2 focus:ring-noahbrave-600 ${fieldError ? 'border-red-400' : 'border-gray-300'}`}
                rows={4}
                placeholder="A cozy collection featuring a bottle of wine, gourmet chocolates, a scented candle, and a plush throw blanket. Perfect for a quiet night in or as a thoughtful gift for someone special."
                aria-invalid={!!fieldError}
              />
              {fieldError && <p className="mt-2 text-sm text-red-600">{fieldError}</p>}
              <p className="text-xs text-gray-600 mt-2">Questions or ideas? Reach out to <a href="mailto:christylukasik@comcast.net" className="text-noahbrave-600 hover:underline">Christy Lukasik</a>.</p>
            </div>
          )}
        </div>
      </div>
      <StickySummary onBack={onBack} onContinue={handleContinue} continueLoading={loading} />
    </div>
  );
};

export default GiftBasketStep;
