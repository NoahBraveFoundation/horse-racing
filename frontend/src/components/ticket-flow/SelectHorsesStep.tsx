import React, { useState } from 'react';
import StepHeader from './StepHeader';
import Board from '../horse-board/Board';
import StickySummary from './StickySummary';

interface SelectHorsesStepProps {
  onBack: () => void;
  onNext: () => void;
}

const SelectHorsesStep: React.FC<SelectHorsesStepProps> = ({ onBack, onNext }) => {
  const [showInfo, setShowInfo] = useState(false);

  return (
    <>
      <div className="min-h-screen bg-noahbrave-50 font-body pb-32">
        <div className="checker-top h-3" style={{ backgroundColor: 'var(--brand)' }} />
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
          <StepHeader title="Select Your Horses" subtitle="Step 3 of 8 — Place your horses" />
          <div className="text-center mb-6">
            <button
              type="button"
              onClick={() => setShowInfo(true)}
              className="text-sm text-noahbrave-600 hover:underline"
            >
              How do the races work?
            </button>
          </div>
          <Board />
        </div>
      </div>
      {showInfo && (
        <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center">
          <div className="absolute inset-0 bg-black/40" onClick={() => setShowInfo(false)} />
          <div className="relative w-full sm:w-[500px] bg-white rounded-t-2xl sm:rounded-2xl shadow-xl p-6">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-semibold text-gray-900">About the Horses & Races</h3>
              <button className="text-gray-500 hover:text-gray-700" onClick={() => setShowInfo(false)}>
                ✕
              </button>
            </div>
            <div className="space-y-4 text-sm text-gray-700">
              <p>
                The first ten races each feature a 10‑horse field. Horses are purchased and named in advance,
                and the owner of every winning horse earns a $60 prize.
              </p>
              <p>
                Race 11 is a special auction race where the horses are sold to the highest bidders. The
                owner of the winning horse takes home half of the auction proceeds.
              </p>
              <p>
                You don’t need to buy a horse to participate — you can also place win-only wagers at the event
                starting at $2.
              </p>
            </div>
          </div>
        </div>
      )}
      <StickySummary onBack={onBack} onContinue={onNext} />
    </>
  );
};

export default SelectHorsesStep;
