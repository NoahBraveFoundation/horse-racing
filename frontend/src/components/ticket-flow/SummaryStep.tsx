import React, { useState } from 'react';
import { graphql, useLazyLoadQuery, commitMutation } from 'react-relay';
import { useTicketFlowStore } from '../../store/ticketFlow';
import StepHeader from './StepHeader';
import environment from '../../relay/environment';
import { setTicketSeatingPreferenceMutation } from '../../graphql/mutations/setTicketSeatingPreference';
import type { SummaryStepQuery } from '../../__generated__/SummaryStepQuery.graphql';
import type { setTicketSeatingPreferenceMutation as SetTicketSeatingPreferenceMutation } from '../../__generated__/setTicketSeatingPreferenceMutation.graphql';

const SummaryQuery = graphql`
  query SummaryStepQuery {
    myCart {
      id
      cost { ticketsCents horseCents sponsorCents totalCents }
      tickets { id attendeeFirst attendeeLast costCents }
      horses { id horseName ownershipLabel costCents }
      sponsorInterests { id companyName costCents }
      giftBasketInterests { id description }
    }
  }
`;

interface Props { onBack: () => void; onNext: () => void }

const SummaryStep: React.FC<Props> = ({ onBack, onNext }) => {
  const cartRefreshKey = useTicketFlowStore((s) => s.cartRefreshKey);
  const checkout = useTicketFlowStore((s) => s.checkoutCart);
  const [inFlight, setInFlight] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [seatingPreference, setSeatingPreference] = useState('');
  const data = useLazyLoadQuery<SummaryStepQuery>(SummaryQuery, {}, { fetchKey: cartRefreshKey, fetchPolicy: 'network-only' });
  const cart = data?.myCart;

  const formatCents = (c?: number) => `$${((c ?? 0) / 100).toLocaleString()}`;

  const handleCheckout = async () => {
    setError(null);
    setInFlight(true);
    try {
      const pref = seatingPreference.trim();
      if (pref && cart?.tickets?.length) {
        const commitPref = (ticketId: string) =>
          new Promise<void>((resolve, reject) => {
            commitMutation<SetTicketSeatingPreferenceMutation>(environment, {
              mutation: setTicketSeatingPreferenceMutation,
              variables: { ticketId, seatingPreference: pref },
              onCompleted: () => resolve(),
              onError: reject,
            });
          });

        await Promise.all((cart?.tickets ?? []).map(t => commitPref(t.id)));
      }
      await checkout();
      onNext();
    } catch (e) {
      const err = e as Error;
      setError(err.message || 'Unable to checkout');
      setInFlight(false);
    }
  };

  return (
    <div className="min-h-screen bg-noahbrave-50 font-body pb-12">
      <div className="checker-top h-3" style={{ backgroundColor: 'var(--brand)' }} />
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <StepHeader title="Review & Checkout" subtitle="Step 7 of 8 — Final summary" />

        <div className="bg-white rounded-2xl shadow-xl border border-noahbrave-200 p-8 space-y-6">
          {error && <div className="mb-4 rounded-lg border border-red-200 bg-red-50 p-3 text-red-800">{error}</div>}

          <div>
            <h2 className="font-semibold text-gray-900 mb-2">Tickets</h2>
            {cart?.tickets?.length ? (
              <ul className="divide-y divide-gray-200 rounded-xl border border-noahbrave-200 overflow-hidden">
                {cart.tickets.map(t => (
                  <li key={t.id} className="flex items-center justify-between p-3 text-gray-800">
                    <span>{t.attendeeFirst} {t.attendeeLast}</span>
                    <span className="text-gray-900 font-medium">{formatCents(t.costCents)}</span>
                  </li>
                ))}
              </ul>
            ) : (
              <p className="text-gray-500">No tickets</p>
            )}
          </div>

          <div>
            <h2 className="font-semibold text-gray-900 mb-2">Horses</h2>
            {cart?.horses?.length ? (
              <ul className="divide-y divide-gray-200 rounded-xl border border-noahbrave-200 overflow-hidden">
                {cart.horses.map(h => (
                  <li key={h.id} className="flex items-center justify-between p-3 text-gray-800">
                    <span>{h.horseName} — {h.ownershipLabel}</span>
                    <span className="text-gray-900 font-medium">{formatCents(h.costCents)}</span>
                  </li>
                ))}
              </ul>
            ) : (
              <p className="text-gray-500">No horses</p>
            )}
          </div>

          <div>
            <h2 className="font-semibold text-gray-900 mb-2">Sponsors</h2>
            {cart?.sponsorInterests?.length ? (
              <ul className="divide-y divide-gray-200 rounded-xl border border-noahbrave-200 overflow-hidden">
                {cart.sponsorInterests.map(s => (
                  <li key={s.id} className="flex items-center justify-between p-3 text-gray-800">
                    <span>{s.companyName}</span>
                    <span className="text-gray-900 font-medium">{formatCents(s.costCents)}</span>
                  </li>
                ))}
              </ul>
            ) : (
              <p className="text-gray-500">No sponsors</p>
            )}
          </div>

          <div>
            <h2 className="font-semibold text-gray-900 mb-2">Gift Basket</h2>
            {cart?.giftBasketInterests?.length ? (
              <ul className="divide-y divide-gray-200 rounded-xl border border-noahbrave-200 overflow-hidden">
                {cart.giftBasketInterests.map(g => (
                  <li key={g.id} className="flex items-center justify-between p-3 text-gray-800">
                    <span>{g.description}</span>
                    {/* If backend later adds costCents here, this will be easy to extend */}
                  </li>
                ))}
              </ul>
            ) : (
              <p className="text-gray-500">No gift basket donation</p>
            )}
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Seating preference (optional)</label>
            <textarea
              value={seatingPreference}
              onChange={(e) => setSeatingPreference(e.target.value)}
              className="w-full rounded-lg border px-3 py-2 border-gray-300 focus:outline-none focus:ring-2 focus:ring-noahbrave-600"
              rows={3}
            />
          </div>

          <div className="border-t pt-4 text-right">
            <div className="text-sm text-gray-600">Total</div>
            <div className="text-2xl font-semibold text-gray-900">{formatCents(cart?.cost?.totalCents)}</div>
          </div>

          <div className="flex items-center justify-between">
            <button type="button" onClick={onBack} className="px-5 py-3 rounded-lg border text-gray-700 hover:bg-gray-50">Back</button>
            <button type="button" onClick={handleCheckout} disabled={inFlight} className="cta px-6 py-3 rounded-lg font-semibold disabled:opacity-50">Confirm & Checkout</button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default SummaryStep;
