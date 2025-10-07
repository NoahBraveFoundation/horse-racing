import React, { useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import UserDetailsStep from '../ticket-flow/UserDetailsStep';
import SponsorStep from '../ticket-flow/SponsorStep';
import SummaryStep from '../ticket-flow/SummaryStep';
import VenmoStep from '../ticket-flow/VenmoStep';
import { useSponsorFlowStore } from '../../store/sponsorFlow';

const SponsorFlow: React.FC = () => {
  const { step } = useParams();
  const navigate = useNavigate();
  const currentStep = useSponsorFlowStore((s) => s.currentStep);
  const user = useSponsorFlowStore((s) => s.user);
  const setUser = useSponsorFlowStore((s) => s.setUser);
  const nextStep = useSponsorFlowStore((s) => s.nextStep);
  const prevStep = useSponsorFlowStore((s) => s.prevStep);
  const goToStep = useSponsorFlowStore((s) => s.goToStep);
  const createUser = useSponsorFlowStore((s) => s.createUser);
  const addSponsor = useSponsorFlowStore((s) => s.addSponsorToCart);
  const removeSponsor = useSponsorFlowStore((s) => s.removeSponsorFromCart);
  const cartRefreshKey = useSponsorFlowStore((s) => s.cartRefreshKey);
  const checkout = useSponsorFlowStore((s) => s.checkoutCart);

  useEffect(() => {
    const n = Number(step);
    if (!Number.isNaN(n) && n >= 1 && n <= 4 && n !== currentStep) {
      goToStep(n);
    }
  }, [step, currentStep, goToStep]);

  useEffect(() => {
    const path = `/sponsor/${currentStep}`;
    if (window.location.pathname !== path) {
      navigate(path, { replace: true });
    }
  }, [currentStep, navigate]);

  const renderStep = () => {
    switch (currentStep) {
      case 1:
        return (
          <UserDetailsStep
            user={user}
            onUserUpdate={setUser}
            onNext={nextStep}
            createUser={createUser}
            title="Sponsor"
            subtitle="Step 1 of 4 — Your details"
          />
        );
      case 2:
        return (
          <SponsorStep
            onBack={prevStep}
            onContinue={nextStep}
            subtitle="Step 2 of 4 — Sponsor the event"
            addSponsor={addSponsor}
            removeSponsor={removeSponsor}
            cartRefreshKey={cartRefreshKey}
          />
        );
      case 3:
        return (
          <SummaryStep
            onBack={prevStep}
            onNext={nextStep}
            subtitle="Step 3 of 4 — Final summary"
            cartRefreshKey={cartRefreshKey}
            checkout={checkout}
          />
        );
      case 4:
        return <VenmoStep />;
      default:
        return null;
    }
  };

  return renderStep();
};

export default SponsorFlow;

