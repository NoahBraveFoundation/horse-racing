import React, { useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import UserDetailsStep from '../components/ticket-flow/UserDetailsStep';
import TicketSelectionStep from '../components/ticket-flow/TicketSelectionStep';
import { useTicketFlowStore } from '../store/ticketFlow';
import StickySummary from '../components/ticket-flow/StickySummary';
import HorsesReviewStep from '../components/ticket-flow/HorsesReviewStep';
import GiftBasketStep from '../components/ticket-flow/GiftBasketStep';
import SponsorStep from '../components/ticket-flow/SponsorStep';
import SummaryStep from '../components/ticket-flow/SummaryStep';
import VenmoStep from '../components/ticket-flow/VenmoStep';
import SelectHorsesStep from '../components/ticket-flow/SelectHorsesStep';

const TicketFlow: React.FC = () => {
  const { step } = useParams();
  const navigate = useNavigate();
  const currentStep = useTicketFlowStore((s) => s.currentStep);
  const user = useTicketFlowStore((s) => s.user);
  const setUser = useTicketFlowStore((s) => s.setUser);
  const nextStep = useTicketFlowStore((s) => s.nextStep);
  const prevStep = useTicketFlowStore((s) => s.prevStep);
  const goToStep = useTicketFlowStore((s) => s.goToStep);

  useEffect(() => {
    const n = Number(step);
    if (!Number.isNaN(n) && n >= 1 && n <= 8 && n !== currentStep) {
      goToStep(n);
    }
  }, [step]);

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
              onNext={nextStep}
              onBack={prevStep}
            />
          </>
        );
      case 3:
        return (
          <>
            <SelectHorsesStep onBack={prevStep} onNext={nextStep} />
          </>
        );
      case 4:
        return (
          <>
            <HorsesReviewStep />
            <StickySummary onBack={prevStep} onContinue={nextStep} />
          </>
        );
      case 5:
        return (
          <>
            <GiftBasketStep onBack={prevStep} onContinue={nextStep} />
          </>
        );
      case 6:
        return (
          <>
            <SponsorStep onBack={prevStep} onContinue={nextStep} />
          </>
        );
      case 7:
        return (
          <>
            <SummaryStep onBack={prevStep} onNext={nextStep} />
          </>
        );
      case 8:
        return (
          <>
            <VenmoStep />
          </>
        );
      default:
        return null;
    }
  };

  return renderStep();
};

export default TicketFlow;


