import React, { useCallback, useState } from 'react';
import { graphql, useLazyLoadQuery } from 'react-relay';
import confetti from 'canvas-confetti';
import type { VenmoStepQuery } from '../../__generated__/VenmoStepQuery.graphql';

const VenmoQuery = graphql`
  query VenmoStepQuery {
    myCart { id cost { totalCents } orderNumber venmoLink venmoUser }
    me { id email firstName lastName }
  }
`;

const VenmoStep: React.FC = () => {
  const [hasPaid, setHasPaid] = useState(false);
  const data = useLazyLoadQuery<VenmoStepQuery>(VenmoQuery, {}, { fetchPolicy: 'network-only' });
  const total = ((data?.myCart?.cost?.totalCents ?? 0) / 100).toFixed(2);
  const venmoUser = data?.myCart?.venmoUser;
  const venmoLink = data?.myCart?.venmoLink;
  const email = data?.me?.email || 'your email';
  const fullName = [data?.me?.firstName, data?.me?.lastName].filter(Boolean).join(' ');

  const fireConfetti = useCallback(() => {
    const duration = 1600;
    const end = Date.now() + duration;
    const defaults = { startVelocity: 25, spread: 360, ticks: 60, zIndex: 1000 } as const;

    const interval: any = setInterval(function() {
      const timeLeft = end - Date.now();
      if (timeLeft <= 0) {
        return clearInterval(interval);
      }
      const particleCount = 60 * (timeLeft / duration);
      confetti({ ...defaults, particleCount, origin: { x: Math.random() * 0.3 + 0.1, y: Math.random() * 0.3 + 0.2 } });
      confetti({ ...defaults, particleCount, origin: { x: Math.random() * 0.3 + 0.6, y: Math.random() * 0.3 + 0.2 } });
    }, 200);
  }, []);

  const onIPaid = () => {
    fireConfetti();
    setHasPaid(true);
  };

  return (
    <div className="min-h-screen bg-noahbrave-50 font-body">
      <div className="checker-top h-3" style={{ backgroundColor: 'var(--brand)' }} />
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="bg-white rounded-2xl shadow-xl border border-noahbrave-200 p-8 text-center">
          <h1 className="font-heading text-4xl md:text-5xl text-gray-900 mb-4">Thank you{fullName ? `, ${fullName}` : ''}!</h1>
          
          {!hasPaid ? (
            <>
              <p className="text-gray-700 mb-6">Total due: <span className="font-semibold">${total}</span></p>
              <a href={venmoLink} target="_blank" rel="noreferrer" className="cta inline-block px-6 py-3 rounded-lg font-semibold">
                Pay with Venmo
              </a>
              <p className="text-sm text-gray-500 mt-6">Venmo:{venmoUser}</p>
              <div className="mt-6">
                <button type="button" onClick={onIPaid} className="px-5 py-3 rounded-lg border text-gray-700 hover:bg-gray-50">
                  I paid
                </button>
              </div>
            </>
          ) : (
            <>
              <p className="text-sm text-gray-600 mb-6">
                We'll email your tickets to <span className="font-medium">{email}</span> as soon as we verify your payment.
              </p>
              <a href="/" className="text-noahbrave-600 hover:text-noahbrave-700 hover:underline">
                Homepage →
              </a>
            </>
          )}
        </div>
      </div>
    </div>
  );
};

export default VenmoStep;
