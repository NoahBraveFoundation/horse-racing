import React, { useState } from 'react';
import { useTicketFlowStore } from '../../store/ticketFlow';
import StickySummary from './StickySummary';
import { graphql, useLazyLoadQuery } from 'react-relay';

interface TicketSelectionStepProps {
  onNext: () => void;
  onBack: () => void;
}

type Attendee = { firstName: string; lastName: string };

type Touched = { firstName: boolean; lastName: boolean };

const CartTicketsQuery = graphql`
  query TicketSelectionStepCartTicketsQuery {
    me { id firstName lastName }
    myCart {
      id
      tickets { id attendeeFirst attendeeLast canRemove }
    }
  }
`;

const TicketSelectionStep: React.FC<TicketSelectionStepProps> = ({ onNext, onBack: _onBack }) => {
  const [rows, setRows] = useState<Attendee[]>([]);
  const [touched, setTouched] = useState<Touched[]>([]);
  const [submitted, setSubmitted] = useState(false);

  const addTicketToCart = useTicketFlowStore((s) => s.addTicketToCart);
  const removeTicketFromCart = useTicketFlowStore((s) => s.removeTicketFromCart);
  const cartRefreshKey = useTicketFlowStore((s) => s.cartRefreshKey);

  const cartData: any = useLazyLoadQuery(CartTicketsQuery, {}, { fetchKey: cartRefreshKey, fetchPolicy: 'network-only' });
  const existingTickets: Array<{ id: string; attendeeFirst: string; attendeeLast: string; canRemove: boolean }> = cartData?.myCart?.tickets ?? [];

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
        <div className="mb-8 text-center">
          <h1 className="font-heading text-4xl md:text-5xl text-gray-900">Select Tickets</h1>
          <p className="text-gray-600 mt-2">Step 2 of 4 — Choose your tickets</p>
        </div>

        <div className="bg-white rounded-2xl shadow-xl border border-noahbrave-200 p-8">
          <div className="mb-6">
            <h2 className="font-semibold text-gray-900 mb-3">Tickets in your cart</h2>
            {existingTickets.length === 0 ? (
              <p className="text-gray-500">No tickets in your cart yet.</p>
            ) : (
              <ul className="divide-y divide-gray-200 rounded-xl border border-noahbrave-200 overflow-hidden">
                {existingTickets.map((t) => (
                  <li key={t.id} className="flex items-center justify-between p-3">
                    <div className="text-gray-800">
                      {t.attendeeFirst} {t.attendeeLast}
                    </div>
                    {t.canRemove && (
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

export default TicketSelectionStep;
