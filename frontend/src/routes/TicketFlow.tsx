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
import ErrorBoundary from '../components/common/ErrorBoundary';
import { logoutAndRedirect } from '../utils/auth';

const TicketFlowFallback: React.FC = () => (
  <div className="min-h-screen bg-noahbrave-50 font-body pb-32">
    <div className="checker-top h-3" style={{ backgroundColor: 'var(--brand)' }} />
    <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
      <div className="bg-white rounded-2xl shadow-xl border border-noahbrave-200 p-8 text-center">
        <div className="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-6">
          <svg className="w-8 h-8 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01M21 12A9 9 0 113 12a9 9 0 0118 0z" />
          </svg>
        </div>
        <h2 className="font-heading text-2xl text-gray-900 mb-2">We hit a snag</h2>
        <p className="text-gray-700 mb-6">Something went wrong while loading your ticket flow. Please try again, or sign out and sign back in.</p>
        <div className="flex flex-col sm:flex-row items-center justify-center gap-3">
          <button
            type="button"
            onClick={() => logoutAndRedirect('/login?redirectTo=/tickets')}
            className="cta px-6 py-3 rounded-lg font-semibold w-full sm:w-auto text-center"
          >
            Logout
          </button>
          <button type="button" onClick={() => window.location.reload()} className="px-6 py-3 rounded-lg border text-gray-700 hover:bg-gray-50 w-full sm:w-auto">Retry</button>
          <a href="/" className="px-6 py-3 rounded-lg border text-gray-700 hover:bg-gray-50 w-full sm:w-auto text-center">Home</a>
        </div>
      </div>
    </div>
  </div>
);

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
    const userData = localStorage.getItem('user');
    
    if (userData && currentStep === 1) {
      try {
        const userObj = JSON.parse(userData);
        setUser(userObj);
        goToStep(2);
      } catch (error) {
        // If user data is invalid, clear it and stay on step 1
        localStorage.removeItem('user');
      }
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
    <ErrorBoundary fallback={<TicketFlowFallback />}>{renderStep()}</ErrorBoundary>
  );
};

export default TicketFlow;


