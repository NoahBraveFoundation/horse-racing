import React, { useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import UserDetailsStep from '../components/ticket-flow/UserDetailsStep';
import TicketSelectionStep from '../components/ticket-flow/TicketSelectionStep';
import ConfirmationStep from '../components/ticket-flow/ConfirmationStep';
import { useTicketFlowStore } from '../store/ticketFlow';
import StickySummary from '../components/ticket-flow/StickySummary';
import Board from '../components/horse-board/Board';

const TicketFlow: React.FC = () => {
  const { step } = useParams();
  const navigate = useNavigate();
  const currentStep = useTicketFlowStore((s) => s.currentStep);
  const user = useTicketFlowStore((s) => s.user);
  const setUser = useTicketFlowStore((s) => s.setUser);
  const nextStep = useTicketFlowStore((s) => s.nextStep);
  const prevStep = useTicketFlowStore((s) => s.prevStep);
  const goToStep = useTicketFlowStore((s) => s.goToStep);

  // When the route changes, update store step
  useEffect(() => {
    const n = Number(step);
    if (!Number.isNaN(n) && n >= 1 && n <= 4 && n !== currentStep) {
      goToStep(n);
    }
  }, [step]);

  // When store step changes, update the route
  useEffect(() => {
    const path = `/tickets/${currentStep}`;
    if (window.location.pathname !== path) {
      navigate(path, { replace: true });
    }
  }, [currentStep, navigate]);

  const renderStep = () => {
    switch (currentStep) {
      case 1:
        return (
          <>
            <UserDetailsStep
              user={user}
              onUserUpdate={(u) => setUser(u)}
              onNext={nextStep}
            />
          </>
        );
      case 2:
        return (
          <>
            <TicketSelectionStep
              user={user}
              onNext={nextStep}
              onBack={prevStep}
            />
            {/* StickySummary rendered inside TicketSelectionStep with onContinue */}
          </>
        );
      case 3:
        return (
          <>
            <div className="min-h-screen bg-noahbrave-50 font-body pb-32">
              <div className="checker-top h-3" style={{ backgroundColor: 'var(--brand)' }} />
              <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
                <div className="mb-8 text-center">
                  <h1 className="font-heading text-4xl md:text-5xl text-gray-900">Select Your Horses</h1>
                  <p className="text-gray-600 mt-2">Step 3 of 4 — Place your horses</p>
                </div>
                <Board />
              </div>
            </div>
            <StickySummary />
          </>
        );
      case 4:
        return (
          <>
            <ConfirmationStep
              user={user}
              onBack={prevStep}
            />
            <StickySummary />
          </>
        );
      default:
        return null;
    }
  };

  return renderStep();
};

export default TicketFlow;


