import React from 'react';
import type { User } from '../../types/ticket';

interface ConfirmationStepProps {
  user: User;
  onBack: () => void;
}

const ConfirmationStep: React.FC<ConfirmationStepProps> = ({ user, onBack }) => {
  return (
    <div className="min-h-screen bg-noahbrave-50 font-body pb-32">
      <div className="checker-top h-3" style={{ backgroundColor: 'var(--brand)' }} />
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="mb-8 text-center">
          <h1 className="font-heading text-4xl md:text-5xl text-gray-900">Confirm Order</h1>
          <p className="text-gray-600 mt-2">Step 4 of 4 — Review and confirm</p>
        </div>

        <div className="bg-white rounded-2xl shadow-xl border border-noahbrave-200 p-8">
          <div className="text-center mb-8">
            <p className="text-gray-600">Thank you, {user.firstName}!</p>
            <p className="text-gray-600">Order confirmation coming soon...</p>
          </div>

          <div className="flex items-center justify-center mt-8">
            <button 
              type="button" 
              onClick={onBack}
              className="px-5 py-3 rounded-lg border text-gray-700 hover:bg-gray-50"
            >
              Back
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default ConfirmationStep;
