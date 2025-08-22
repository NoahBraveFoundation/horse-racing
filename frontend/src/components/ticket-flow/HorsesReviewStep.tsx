import React from 'react';
import { graphql, useLazyLoadQuery } from 'react-relay';
import { useTicketFlowStore } from '../../store/ticketFlow';
import { formatTimeRange } from '../../utils/time';
import StepHeader from './StepHeader';
import type { HorsesReviewStepQuery } from '../../__generated__/HorsesReviewStepQuery.graphql';

const HorsesQuery = graphql`
  query HorsesReviewStepQuery {
    myCart {
      id
      horses {
        id
        horseName
        ownershipLabel
        lane { id number round { id name startAt endAt } }
      }
    }
  }
`;

const HorsesReviewStep: React.FC = () => {
  const cartRefreshKey = useTicketFlowStore((s) => s.cartRefreshKey);
  const removeHorseFromCart = useTicketFlowStore((s) => s.removeHorseFromCart);
  const data = useLazyLoadQuery<HorsesReviewStepQuery>(HorsesQuery, {}, { fetchKey: cartRefreshKey, fetchPolicy: 'network-only' });
  const horses = data?.myCart?.horses ?? [];

  const handleRemove = async (id: string) => {
    await removeHorseFromCart(id);
  };

  return (
    <div className="min-h-screen bg-noahbrave-50 font-body pb-32">
      <div className="checker-top h-3" style={{ backgroundColor: 'var(--brand)' }} />
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <StepHeader title="Review Horses" subtitle="Step 4 of 8 — Confirm your horses" />

        <div className="bg-white rounded-2xl shadow-xl border border-noahbrave-200 p-8">
          {horses.length === 0 ? (
            <p className="text-gray-500">No horses in your cart yet.</p>
          ) : (
            <ul className="divide-y divide-gray-200 rounded-xl border border-noahbrave-200 overflow-hidden">
              {horses.map((h) => (
                <li key={h.id} className="flex items-start justify-between p-4">
                  <div className="text-gray-800">
                    <div className="text-lg font-semibold text-gray-900">{h.horseName}</div>
                    <div className="text-sm text-gray-700">{h.ownershipLabel}</div>
                    {h.lane?.round && (
                      <div className="mt-1 text-sm text-gray-600">
                        <span className="font-medium">{h.lane.round.name}</span>
                        <span className="mx-2 text-gray-400">•</span>
                        <span>Lane {h.lane.number}</span>
                        <span className="mx-2 text-gray-400">•</span>
                        <span>{formatTimeRange(h.lane.round.startAt, h.lane.round.endAt)}</span>
                      </div>
                    )}
                  </div>
                  <button type="button" onClick={() => handleRemove(h.id)} className="text-sm text-gray-600 hover:text-gray-800">Remove</button>
                </li>
              ))}
            </ul>
          )}
        </div>
      </div>
    </div>
  );
};

export default HorsesReviewStep;
