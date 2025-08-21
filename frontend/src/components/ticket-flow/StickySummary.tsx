import React from 'react';
import { useTicketFlowStore } from '../../store/ticketFlow';

interface StickySummaryProps {
  hidePrices?: boolean;
  onContinue?: () => void;
}

const StickySummary: React.FC<StickySummaryProps> = ({ hidePrices = false, onContinue }) => {
  const ticketsTotal = useTicketFlowStore((s) => s.ticketsTotal());
  const horsesTotal = useTicketFlowStore((s) => s.horsesTotal());
  const grandTotal = useTicketFlowStore((s) => s.grandTotal());
  const ticketCount = useTicketFlowStore((s) => s.totalTickets());
  const horseCount = useTicketFlowStore((s) => s.totalHorseCount());

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
              </div>
            )}
          </div>
          {onContinue && (
            <div className="w-full sm:w-auto flex sm:block justify-center">
              <button
                type="button"
                onClick={onContinue}
                className="cta px-6 py-3 rounded-lg font-semibold"
              >
                Continue
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default StickySummary;
