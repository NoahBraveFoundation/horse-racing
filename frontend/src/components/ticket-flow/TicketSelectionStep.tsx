import React, { useState } from 'react';
import type { User } from '../../types/ticket';
import { useTicketFlowStore } from '../../store/ticketFlow';
import StickySummary from './StickySummary';

interface TicketSelectionStepProps {
  user: User;
  onNext: () => void;
  onBack: () => void;
}

type Attendee = { firstName: string; lastName: string };

type Touched = { firstName: boolean; lastName: boolean };

const TicketSelectionStep: React.FC<TicketSelectionStepProps> = ({ user, onNext, onBack: _onBack }) => {
  const attendees = useTicketFlowStore((s) => s.attendees);
  const addAttendee = useTicketFlowStore((s) => s.addAttendee);
  const removeAttendee = useTicketFlowStore((s) => s.removeAttendee);
  const updateAttendee = useTicketFlowStore((s) => s.updateAttendee);

  const [touched, setTouched] = useState<Touched[]>(attendees.map(() => ({ firstName: false, lastName: false })));
  const [submitted, setSubmitted] = useState(false);

  const totalTickets = 1 + attendees.length; // includes the owner

  const handleAdd = () => {
    addAttendee();
    setTouched((prev) => [...prev, { firstName: false, lastName: false }]);
  };

  const handleRemove = (index: number) => {
    removeAttendee(index);
    setTouched((prev) => prev.filter((_, i) => i !== index));
  };

  const handleChange = (index: number, field: keyof Attendee, value: string) => {
    updateAttendee(index, { [field]: value } as Partial<Attendee>);
  };

  const handleBlur = (index: number, field: keyof Touched) => {
    setTouched(prev => prev.map((t, i) => (i === index ? { ...t, [field]: true } : t)));
  };

  const isRowValid = (a: Attendee) => a.firstName.trim().length > 0 && a.lastName.trim().length > 0;
  const allValid = attendees.every(isRowValid);

  const showError = (i: number, field: keyof Attendee) => {
    const t = touched[i]?.[field as keyof Touched] || submitted;
    const v = attendees[i]?.[field]?.trim().length > 0;
    return t && !v;
  };

  const handleContinue = () => {
    setSubmitted(true);
    if (!allValid) return;
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
          <div className="mb-8">
            <h2 className="font-semibold text-gray-900 mb-3">Your ticket</h2>
            <div className="grid md:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1" hidden>First name</label>
                <input value={user.firstName} disabled className="w-full rounded-lg border px-4 py-3 bg-gray-100 text-gray-500 border-gray-200" />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1" hidden>Last name</label>
                <input value={user.lastName} disabled className="w-full rounded-lg border px-4 py-3 bg-gray-100 text-gray-500 border-gray-200" />
              </div>
            </div>
          </div>

          <div>
            <div className="flex items-center justify-between mb-4">
              <h2 className="font-semibold text-gray-900">Additional tickets</h2>
              <button type="button" onClick={handleAdd} className="px-4 py-2 rounded-lg border text-gray-700 hover:bg-gray-50">
                Add another
              </button>
            </div>

            {attendees.length === 0 && (
              <p className="text-gray-500 mb-4">No additional tickets added yet.</p>
            )}

            <div className="space-y-4">
              {attendees.map((a, i) => (
                <div key={i} className="rounded-xl border border-noahbrave-200 p-4">
                  <div className="grid md:grid-cols-2 gap-4">
                    <div>
                      <label className="block text-sm font-medium text-gray-700 mb-1">First name</label>
                      <input
                        value={a.firstName}
                        onChange={(e) => handleChange(i, 'firstName', e.target.value)}
                        onBlur={() => handleBlur(i, 'firstName')}
                        className={`w-full rounded-lg border px-4 py-3 focus:outline-none focus:ring-2 focus:ring-noahbrave-600 ${
                          showError(i, 'firstName') ? 'border-red-500' : 'border-gray-300'
                        }`}
                        placeholder="Jane"
                      />
                      {showError(i, 'firstName') && (
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
                          showError(i, 'lastName') ? 'border-red-500' : 'border-gray-300'
                        }`}
                        placeholder="Doe"
                      />
                      {showError(i, 'lastName') && (
                        <p className="text-sm text-red-600 mt-1">Please enter a last name</p>
                      )}
                    </div>
                  </div>
                  <div className="flex justify-end mt-3">
                    <button
                      type="button"
                      onClick={() => handleRemove(i)}
                      className="text-sm text-gray-600 hover:text-gray-800"
                    >
                      Remove
                    </button>
                  </div>
                </div>
              ))}
            </div>

            <div className="mt-6 text-sm text-gray-600">
              Tickets: <span className="font-medium text-gray-900">{totalTickets}</span>
            </div>
          </div>
        </div>
      </div>

      <StickySummary onContinue={handleContinue} />
    </div>
  );
};

export default TicketSelectionStep;
