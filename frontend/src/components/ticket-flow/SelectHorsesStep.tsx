import React from 'react';
import StepHeader from './StepHeader';
import Board from '../horse-board/Board';
import StickySummary from './StickySummary';

interface SelectHorsesStepProps {
  onBack: () => void;
  onNext: () => void;
}

const SelectHorsesStep: React.FC<SelectHorsesStepProps> = ({ onBack, onNext }) => {
  return ( 
    <>
      <div className="min-h-screen bg-noahbrave-50 font-body pb-32">
        <div className="checker-top h-3" style={{ backgroundColor: 'var(--brand)' }} />
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
          <StepHeader title="Select Your Horses" subtitle="Step 3 of 8 — Place your horses" />
          <Board />
        </div>
      </div>
      <StickySummary onBack={onBack} onContinue={onNext} />
    </>
  );
};

export default SelectHorsesStep;
