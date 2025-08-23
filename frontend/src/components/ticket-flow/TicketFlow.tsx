import React, { useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import UserDetailsStep from './UserDetailsStep';
import TicketSelectionStep from './TicketSelectionStep';
import { useTicketFlowStore } from '../../store/ticketFlow';
import StickySummary from './StickySummary';
import HorsesReviewStep from './HorsesReviewStep';
import GiftBasketStep from './GiftBasketStep';
import SponsorStep from './SponsorStep';
import SummaryStep from './SummaryStep';
import VenmoStep from './VenmoStep';
import SelectHorsesStep from './SelectHorsesStep';
import { getCurrentUser } from '../../utils/auth';

const TicketFlow: React.FC = () => {
  const { step } = useParams();
  const navigate = useNavigate();
  const currentStep = useTicketFlowStore((s) => s.currentStep);
  const user = useTicketFlowStore((s) => s.user);
  const setUser = useTicketFlowStore((s) => s.setUser);
  const nextStep = useTicketFlowStore((s) => s.nextStep);
  const prevStep = useTicketFlowStore((s) => s.prevStep);
  const goToStep = useTicketFlowStore((s) => s.goToStep);

  // Check if user is logged in and skip to step 2 if they are
  useEffect(() => {
    const userData = getCurrentUser();
    
    if (userData && currentStep === 1) {
      setUser(userData);
      goToStep(2);
    }
  }, [currentStep, setUser, goToStep]);

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

  return (
    renderStep()
  );
};

export default TicketFlow;


