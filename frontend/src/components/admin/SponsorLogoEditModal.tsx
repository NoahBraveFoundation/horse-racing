import React, { useRef, useState } from 'react';

type SponsorLogoEditModalProps = {
  sponsor: {
    id: string;
    companyName: string;
    companyLogoBase64: string | null;
  };
  onClose: () => void;
  onUpdate: (sponsorId: string, logoBase64: string | null) => void;
};

const SponsorLogoEditModal: React.FC<SponsorLogoEditModalProps> = ({ sponsor, onClose, onUpdate }) => {
  const [logoBase64, setLogoBase64] = useState<string | null>(sponsor.companyLogoBase64);
  const [uploadError, setUploadError] = useState<string | null>(null);
  const [dragActive, setDragActive] = useState(false);
  const [saving, setSaving] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const fileToBase64 = (file: File) =>
    new Promise<string>((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = () => resolve(reader.result as string);
      reader.onerror = reject;
      reader.readAsDataURL(file);
    });

  const handleFile = async (file: File) => {
    setUploadError(null);
    if (!file.type.startsWith('image/')) {
      setUploadError('Please upload an image file (PNG, JPG, SVG, etc).');
      return;
    }
    if (file.size > 5 * 1024 * 1024) {
      setUploadError('File is too large. Max size is 5MB.');
      return;
    }

    try {
      const base64 = await fileToBase64(file);
      setLogoBase64(base64);
    } catch (error) {
      console.error(error);
      setUploadError('Something went wrong while reading that file.');
    }
  };

  const onFileChange: React.ChangeEventHandler<HTMLInputElement> = async (event) => {
    const file = event.target.files?.[0];
    if (!file) return;
    await handleFile(file);
  };

  const onDrop: React.DragEventHandler<HTMLDivElement> = async (event) => {
    event.preventDefault();
    event.stopPropagation();
    setDragActive(false);
    if (event.dataTransfer.files && event.dataTransfer.files.length > 0) {
      const file = event.dataTransfer.files[0];
      await handleFile(file);
      event.dataTransfer.clearData();
    }
  };

  const handleSave = async () => {
    setSaving(true);
    try {
      await onUpdate(sponsor.id, logoBase64);
      onClose();
    } catch (error) {
      console.error('Failed to update sponsor logo:', error);
      setUploadError('Failed to update sponsor logo. Please try again.');
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="fixed inset-0 z-[60] flex items-end sm:items-center justify-center">
      <div className="absolute inset-0 bg-black/40" onClick={onClose} />
      <div className="relative w-full sm:w-[600px] bg-white rounded-t-2xl sm:rounded-2xl shadow-xl p-6">
        <div className="flex items-center justify-between mb-4">
          <h3 className="text-lg font-semibold text-gray-900">Edit Sponsor Logo - {sponsor.companyName}</h3>
          <button className="text-gray-500 hover:text-gray-700" onClick={onClose}>
            ✕
          </button>
        </div>

        {uploadError && (
          <div className="mb-3 rounded-lg border border-red-200 bg-red-50 p-3 text-red-800 text-sm">{uploadError}</div>
        )}

        <div className="mb-4">
          <label className="block text-sm font-medium text-gray-700 mb-2">Company logo</label>
          <div
            onDragOver={(event) => {
              event.preventDefault();
              event.stopPropagation();
              setDragActive(true);
            }}
            onDragEnter={(event) => {
              event.preventDefault();
              event.stopPropagation();
              setDragActive(true);
            }}
            onDragLeave={(event) => {
              event.preventDefault();
              event.stopPropagation();
              setDragActive(false);
            }}
            onDrop={onDrop}
            onClick={() => fileInputRef.current?.click()}
            className={`relative flex flex-col items-center justify-center rounded-xl border-2 border-dashed p-6 text-center cursor-pointer transition ${dragActive ? 'border-noahbrave-500 bg-noahbrave-50' : 'border-noahbrave-200 hover:border-noahbrave-400'}`}
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
                <img
                  src={logoBase64}
                  alt="Company logo preview"
                  className="h-32 w-auto mx-auto object-contain rounded-md border border-gray-200 bg-white p-2"
                />
                <div className="mt-3 flex items-center justify-center gap-3">
                  <button
                    type="button"
                    onClick={(event) => {
                      event.stopPropagation();
                      fileInputRef.current?.click();
                    }}
                    className="px-3 py-1.5 text-sm rounded-md border text-gray-700 hover:bg-gray-50"
                  >
                    Replace logo
                  </button>
                  <button
                    type="button"
                    onClick={(event) => {
                      event.stopPropagation();
                      setLogoBase64(null);
                    }}
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
        </div>

        <div className="flex justify-end gap-3 mt-5">
          <button onClick={onClose} className="px-4 py-2 rounded-lg border" disabled={saving}>
            Cancel
          </button>
          <button 
            onClick={handleSave} 
            disabled={saving} 
            className="cta px-5 py-2 rounded-lg font-semibold disabled:opacity-50"
          >
            {saving ? 'Saving…' : 'Save'}
          </button>
        </div>
      </div>
    </div>
  );
};

export default SponsorLogoEditModal;
