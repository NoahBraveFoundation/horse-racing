import React, { useMemo, useState } from 'react';
import { useTicketFlowStore } from '../../store/ticketFlow';
import StickySummary from './StickySummary';
import { graphql, useLazyLoadQuery } from 'react-relay';
import StepHeader from './StepHeader';
import ErrorBoundary from '../common/ErrorBoundary';
import ErrorFallback from '../common/ErrorFallback';
import type { TicketSelectionStepCartTicketsQuery } from '../../__generated__/TicketSelectionStepCartTicketsQuery.graphql';

interface TicketSelectionStepProps {
  onNext: () => void;
  onBack: () => void;
}

type Attendee = { firstName: string; lastName: string };

type Touched = { firstName: boolean; lastName: boolean };

type GraphQLTicket = TicketSelectionStepCartTicketsQuery['response']['me']['tickets'][number];

type DisplayTicket = Omit<GraphQLTicket, 'id'> & { id: string; isPaid: boolean };

const CartTicketsQuery = graphql`
  query TicketSelectionStepCartTicketsQuery {
    me { id firstName lastName tickets { id attendeeFirst attendeeLast canRemove state } }
    myCart {
      id
      tickets { id attendeeFirst attendeeLast canRemove state }
    }
  }
`;

const TicketSelectionStep: React.FC<TicketSelectionStepProps> = ({ onNext }) => {
  const [rows, setRows] = useState<Attendee[]>([]);
  const [touched, setTouched] = useState<Touched[]>([]);
  const [submitted, setSubmitted] = useState(false);

  const addTicketToCart = useTicketFlowStore((s) => s.addTicketToCart);
  const removeTicketFromCart = useTicketFlowStore((s) => s.removeTicketFromCart);
  const cartRefreshKey = useTicketFlowStore((s) => s.cartRefreshKey);

  const cartData = useLazyLoadQuery<TicketSelectionStepCartTicketsQuery>(CartTicketsQuery, {}, { fetchKey: cartRefreshKey, fetchPolicy: 'network-only' });

  const visibleTickets: DisplayTicket[] = useMemo(() => {
    const accountTickets = cartData?.me?.tickets ?? [];
    const cartTickets = cartData?.myCart?.tickets ?? [];
    const ordered: DisplayTicket[] = [];
    const indexById = new Map<string, number>();

    accountTickets.forEach((ticket) => {
      if (!ticket.id || ticket.state !== 'confirmed') return;
      const { id: rawId, ...rest } = ticket;
      const id = rawId as string;
      ordered.push({ ...rest, id, isPaid: true });
      indexById.set(id, ordered.length - 1);
    });

    cartTickets.forEach((ticket) => {
      if (!ticket.id) return;
      const { id: rawId, ...rest } = ticket;
      const id = rawId as string;
      const existingIndex = indexById.get(id);
      if (existingIndex !== undefined) {
        const existing = ordered[existingIndex];
        ordered[existingIndex] = {
          ...existing,
          ...rest,
          id,
          isPaid: existing.isPaid || ticket.state === 'confirmed',
        };
      } else {
        ordered.push({ ...rest, id, isPaid: ticket.state === 'confirmed' });
        indexById.set(id, ordered.length - 1);
      }
    });

    return ordered;
  }, [cartData]);

  const handleAddRow = () => {
    setRows((prev) => [...prev, { firstName: '', lastName: '' }]);
    setTouched((prev) => [...prev, { firstName: false, lastName: false }]);
  };

  const handleRemoveRow = (index: number) => {
    setRows((prev) => prev.filter((_, i) => i !== index));
    setTouched((prev) => prev.filter((_, i) => i !== index));
  };

  const handleChange = (index: number, field: keyof Attendee, value: string) => {
    setRows(prev => prev.map((a, i) => (i === index ? { ...a, [field]: value } : a)));
  };

  const handleBlur = (index: number, field: keyof Touched) => {
    setTouched(prev => prev.map((t, i) => (i === index ? { ...t, [field]: true } : t)));
  };

  const isRowValid = (a: Attendee) => a.firstName.trim().length > 0 && a.lastName.trim().length > 0;

  const handleAddTicket = async (i: number) => {
    setSubmitted(true);
    const a = rows[i];
    if (!a || !isRowValid(a)) return;
    await addTicketToCart({ attendeeFirst: a.firstName.trim(), attendeeLast: a.lastName.trim() });
    handleRemoveRow(i);
  };

  const handleRemoveTicket = async (ticketId: string) => {
    await removeTicketFromCart(ticketId);
  };

  const handleContinue = () => {
    onNext();
  };

  return (
    <div className="min-h-screen bg-noahbrave-50 font-body pb-32">
      <div className="checker-top h-3" style={{ backgroundColor: 'var(--brand)' }} />
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <StepHeader title="Select Tickets" subtitle="Step 2 of 4 — Choose your tickets" />

        <div className="bg-white rounded-2xl shadow-xl border border-noahbrave-200 p-8">
          <div className="mb-6">
            <h2 className="font-semibold text-gray-900 mb-3">Tickets in your cart</h2>
            {visibleTickets.length === 0 ? (
              <p className="text-gray-500">No tickets in your cart yet.</p>
            ) : (
              <ul className="divide-y divide-gray-200 rounded-xl border border-noahbrave-200 overflow-hidden">
                {visibleTickets.map((t) => (
                  <li key={t.id} className="flex items-center justify-between p-3">
                    <div className="text-gray-800 flex items-center gap-2">
                      <span>
                        {t.attendeeFirst} {t.attendeeLast}
                      </span>
                      {t.isPaid && (
                        <span className="text-xs font-semibold uppercase tracking-wide text-green-700 bg-green-100 rounded-full px-2 py-0.5">
                          Paid
                        </span>
                      )}
                    </div>
                    {t.canRemove && !t.isPaid && (
                      <button
                        type="button"
                        onClick={() => handleRemoveTicket(t.id)}
                        className="text-sm text-gray-600 hover:text-gray-800"
                      >
                        Remove
                      </button>
                    )}
                  </li>
                ))}
              </ul>
            )}
          </div>

          <div>
            <div className="flex items-center justify-between mb-4">
              <h2 className="font-semibold text-gray-900">Add more tickets</h2>
              <button type="button" onClick={handleAddRow} className="px-4 py-2 rounded-lg border text-gray-700 hover:bg-gray-50">
                Add another
              </button>
            </div>

            {rows.length === 0 && (
              <p className="text-gray-500 mb-4">No additional tickets pending add.</p>
            )}

            <div className="space-y-4">
              {rows.map((a, i) => {
                const showFirst = (touched[i]?.firstName || submitted) && !a.firstName.trim();
                const showLast = (touched[i]?.lastName || submitted) && !a.lastName.trim();
                return (
                  <div key={i} className="rounded-xl border border-noahbrave-200 p-4">
                    <div className="grid md:grid-cols-2 gap-4">
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">First name</label>
                        <input
                          value={a.firstName}
                          onChange={(e) => handleChange(i, 'firstName', e.target.value)}
                          onBlur={() => handleBlur(i, 'firstName')}
                          className={`w-full rounded-lg border px-4 py-3 focus:outline-none focus:ring-2 focus:ring-noahbrave-600 ${
                            showFirst ? 'border-red-500' : 'border-gray-300'
                          }`}
                          placeholder="Jane"
                        />
                        {showFirst && (
                          <p className="text-sm text-red-600 mt-1">Please enter a first name</p>
                        )}
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-gray-700 mb-1">Last name</label>
                        <input
                          value={a.lastName}
                          onChange={(e) => handleChange(i, 'lastName', e.target.value)}
                          onBlur={() => handleBlur(i, 'lastName')}
                          className={`w-full rounded-lg border px-4 py-3 focus:outline-none focus:ring-2 focus:ring-noahbrave-600 ${
                            showLast ? 'border-red-500' : 'border-gray-300'
                          }`}
                          placeholder="Doe"
                        />
                        {showLast && (
                          <p className="text-sm text-red-600 mt-1">Please enter a last name</p>
                        )}
                      </div>
                    </div>
                    <div className="flex justify-end mt-3 gap-3">
                      <button
                        type="button"
                        onClick={() => handleRemoveRow(i)}
                        className="text-sm text-gray-600 hover:text-gray-800"
                      >
                        Remove row
                      </button>
                      <button
                        type="button"
                        onClick={() => handleAddTicket(i)}
                        className="cta px-4 py-2 rounded-lg font-semibold"
                      >
                        Add ticket
                      </button>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>
      </div>

      <StickySummary onContinue={handleContinue} />
    </div>
  );
};

const TicketSelectionStepWithErrorBoundary: React.FC<TicketSelectionStepProps> = (props) => (
  <ErrorBoundary fallback={
    <ErrorFallback 
      title="Ticket Selection Error"
      message="Unable to load ticket information. Please try again or sign back in."
      logoutRedirectTo="/login?redirectTo=/tickets"
    />
  }>
    <TicketSelectionStep {...props} />
  </ErrorBoundary>
);

export default TicketSelectionStepWithErrorBoundary;
