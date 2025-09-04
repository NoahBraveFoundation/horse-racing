import React from 'react';
import { useLazyLoadQuery, graphql } from 'react-relay';
import ErrorBoundary from '../common/ErrorBoundary';
import { useTicketFlowStore } from '../../store/ticketFlow';
import type { StickySummaryCartQuery } from '../../__generated__/StickySummaryCartQuery.graphql';

const CartSummaryQuery = graphql`
  query StickySummaryCartQuery {
    myCart {
      id
      cost {
        ticketsCents
        horseCents
        sponsorCents
        totalCents
      }
      tickets { id }
      horses { id }
    }
  }
`;

interface StickySummaryProps {
  hidePrices?: boolean;
  onContinue?: () => void;
  onBack?: () => void;
  continueLoading?: boolean;
}

const SummaryInner: React.FC<StickySummaryProps> = ({ hidePrices = false, onContinue, onBack, continueLoading = false }) => {
  const cartRefreshKey = useTicketFlowStore((s) => s.cartRefreshKey);
  const data = hidePrices ? null : useLazyLoadQuery<StickySummaryCartQuery>(CartSummaryQuery, {}, { fetchKey: cartRefreshKey, fetchPolicy: 'network-only' });
  const cart = data?.myCart;

  const ticketCount = cart?.tickets?.length ?? 0;
  const horseCount = cart?.horses?.length ?? 0;

  const ticketsTotal = (cart?.cost?.ticketsCents ?? 0) / 100;
  const horsesTotal = (cart?.cost?.horseCents ?? 0) / 100;
  const sponsorTotal = (cart?.cost?.sponsorCents ?? 0) / 100;
  const grandTotal = (cart?.cost?.totalCents ?? 0) / 100;

  const pluralize = (word: string, count: number) => (count === 1 ? word : `${word}s`);

  return (
    <div className="fixed bottom-0 inset-x-0 z-50 border-t border-gray-200 bg-white shadow-[0_-4px_12px_rgba(0,0,0,0.05)]">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="py-4 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
          <div className="w-full">
            {hidePrices ? (
              <div className="text-center text-gray-700 text-sm">Tickets: {ticketCount}</div>
            ) : (
              <div className="w-full">
                {sponsorTotal > 0 ? (
                  <>
                    <div className="grid grid-cols-7 items-baseline gap-2 justify-items-center text-xl sm:text-2xl font-semibold text-gray-900">
                      <span>${ticketsTotal.toLocaleString()}</span>
                      <span className="text-gray-400">+</span>
                      <span>${horsesTotal.toLocaleString()}</span>
                      <span className="text-gray-400">+</span>
                      <span>${sponsorTotal.toLocaleString()}</span>
                      <span className="text-gray-400">=</span>
                      <span>${grandTotal.toLocaleString()}</span>
                    </div>
                    <div className="mt-1 grid grid-cols-7 gap-2 justify-items-center text-[11px] sm:text-xs uppercase tracking-wide text-gray-500">
                      <span>{pluralize('ticket', ticketCount)}</span>
                      <span></span>
                      <span>{pluralize('horse', horseCount)}</span>
                      <span></span>
                      <span>sponsor</span>
                      <span></span>
                      <span>total</span>
                    </div>
                  </>
                ) : (
                  <>
                    <div className="grid grid-cols-5 items-baseline gap-2 justify-items-center text-xl sm:text-2xl font-semibold text-gray-900">
                      <span>${ticketsTotal.toLocaleString()}</span>
                      <span className="text-gray-400">+</span>
                      <span>${horsesTotal.toLocaleString()}</span>
                      <span className="text-gray-400">=</span>
                      <span>${grandTotal.toLocaleString()}</span>
                    </div>
                    <div className="mt-1 grid grid-cols-5 gap-2 justify-items-center text-[11px] sm:text-xs uppercase tracking-wide text-gray-500">
                      <span>{pluralize('ticket', ticketCount)}</span>
                      <span></span>
                      <span>{pluralize('horse', horseCount)}</span>
                      <span></span>
                      <span>total</span>
                    </div>
                  </>
                )}
              </div>
            )}
          </div>
          <div className="w-full sm:w-auto flex items-center justify-between sm:justify-end gap-3">
            {onBack && (
              <button
                type="button"
                onClick={onBack}
                className="px-5 py-3 rounded-lg border text-gray-700 hover:bg-gray-50"
              >
                Back
              </button>
            )}
            {onContinue && (
              <button
                type="button"
                onClick={continueLoading ? undefined : onContinue}
                disabled={continueLoading}
                className="cta px-6 py-3 rounded-lg font-semibold disabled:opacity-60 relative"
              >
                {continueLoading && (
                  <span className="absolute inset-0 flex items-center justify-center">
                    <span className="h-5 w-5 border-2 border-white/70 border-t-transparent rounded-full animate-spin"></span>
                  </span>
                )}
                <span className={continueLoading ? 'invisible' : ''}>Continue</span>
              </button>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

const StickySummary: React.FC<StickySummaryProps> = (props) => (
  <ErrorBoundary fallback={props.hidePrices ? null : (
    <div className="fixed bottom-0 inset-x-0 z-50 border-t border-gray-200 bg-white">
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="py-4 flex items-center justify-between">
          <div className="text-sm text-gray-600">Unable to load cart. Please sign in.</div>
          <div className="flex items-center gap-3">
            {props.onBack && (
              <button type="button" onClick={props.onBack} className="px-5 py-3 rounded-lg border text-gray-700 hover:bg-gray-50">Back</button>
            )}
            {props.onContinue && (
              <button type="button" onClick={props.onContinue} className="cta px-6 py-3 rounded-lg font-semibold">Continue</button>
            )}
          </div>
        </div>
      </div>
    </div>
  )}>
    <SummaryInner {...props} />
  </ErrorBoundary>
);

export default StickySummary;
