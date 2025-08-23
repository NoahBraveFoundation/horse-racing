import React, { useState } from 'react';
import type { User } from '../../types/ticket';
import { useTicketFlowStore } from '../../store/ticketFlow';
import StepHeader from './StepHeader';

interface UserDetailsStepProps {
  user: User;
  onUserUpdate: (user: User) => void;
  onNext: () => void;
}

const UserDetailsStep: React.FC<UserDetailsStepProps> = ({ user, onUserUpdate, onNext }) => {
  const [touched, setTouched] = useState<Record<'firstName' | 'lastName' | 'email', boolean>>({ 
    firstName: false, 
    lastName: false, 
    email: false 
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const createUser = useTicketFlowStore((s) => s.createUser);

  const onChange: React.ChangeEventHandler<HTMLInputElement> = (e) => {
    const { name, value } = e.target;
    onUserUpdate({ ...user, [name]: value });
    if (errorMessage) setErrorMessage(null);
  };

  const onBlur: React.FocusEventHandler<HTMLInputElement> = (e) => {
    const { name } = e.target;
    setTouched((t) => ({ ...t, [name]: true }));
  };

  const emailValid = /.+@.+\..+/.test(user.email);
  const firstValid = user.firstName.trim().length > 1;
  const lastValid = user.lastName.trim().length > 1;
  const formValid = emailValid && firstValid && lastValid;

  const handleSubmit: React.FormEventHandler<HTMLFormElement> = async (e) => {
    e.preventDefault();
    setTouched({ firstName: true, lastName: true, email: true });
    if (!formValid) return;

    setErrorMessage(null);
    setIsSubmitting(true);

    try {
      const created = await createUser({
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
      });
      onUserUpdate({ ...user, id: created.id });
      setIsSubmitting(false);
      onNext();
    } catch (err: any) {
      setIsSubmitting(false);
      setErrorMessage(err?.message || 'Something went wrong. Please try again.');
    }
  };

  return (
    <div className="min-h-screen bg-noahbrave-50 font-body pb-32">
      <div className="checker-top h-3" style={{ backgroundColor: 'var(--brand)' }} />
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <StepHeader title="Buy Tickets" subtitle="Step 1 of 8 — Your details" />

        <form onSubmit={handleSubmit} className="bg-white rounded-2xl shadow-xl border border-noahbrave-200 p-8">
          {errorMessage && (
            <div role="alert" aria-live="polite" className="mb-6 rounded-lg border border-red-200 bg-red-50 p-4 text-red-800">
              {errorMessage}
            </div>
          )}

          <div className="grid md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1" htmlFor="firstName">
                First name
              </label>
              <input 
                id="firstName" 
                name="firstName" 
                value={user.firstName} 
                onChange={onChange} 
                onBlur={onBlur}
                className={`w-full rounded-lg border px-4 py-3 focus:outline-none focus:ring-2 focus:ring-noahbrave-600 ${
                  touched.firstName && !firstValid ? 'border-red-500' : 'border-gray-300'
                }`} 
              />
              {touched.firstName && !firstValid && (
                <p className="text-sm text-red-600 mt-1">Please enter your first name</p>
              )}
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1" htmlFor="lastName">
                Last name
              </label>
              <input 
                id="lastName" 
                name="lastName" 
                value={user.lastName} 
                onChange={onChange} 
                onBlur={onBlur}
                className={`w-full rounded-lg border px-4 py-3 focus:outline-none focus:ring-2 focus:ring-noahbrave-600 ${
                  touched.lastName && !lastValid ? 'border-red-500' : 'border-gray-300'
                }`} 
              />
              {touched.lastName && !lastValid && (
                <p className="text-sm text-red-600 mt-1">Please enter your last name</p>
              )}
            </div>
          </div>

          <div className="mt-6">
            <label className="block text-sm font-medium text-gray-700 mb-1" htmlFor="email">
              Email
            </label>
            <input 
              id="email" 
              name="email" 
              type="email" 
              value={user.email} 
              onChange={onChange} 
              onBlur={onBlur}
              className={`w-full rounded-lg border px-4 py-3 focus:outline-none focus:ring-2 focus:ring-noahbrave-600 ${
                touched.email && !emailValid ? 'border-red-500' : 'border-gray-300'
              }`} 
            />
            {touched.email && !emailValid && (
              <p className="text-sm text-red-600 mt-1">Please enter a valid email</p>
            )}
          </div>

          <div className="flex items-center justify-between mt-8">
            <button 
              type="button" 
              onClick={() => window.history.back()} 
              className="px-5 py-3 rounded-lg border text-gray-700 hover:bg-gray-50"
            >
              Back
            </button>
            <button 
              type="submit" 
              disabled={!formValid || isSubmitting} 
              className="cta px-6 py-3 rounded-lg font-semibold disabled:opacity-50"
            >
              {isSubmitting ? 'Creating...' : 'Continue'}
            </button>
          </div>

          <div className="mt-6 pt-6 border-t border-gray-200 text-center">
            <p className="text-sm text-gray-600 mb-3">Already have an account?</p>
            <button
              type="button"
              onClick={() => window.location.href = '/login?redirectTo=/tickets'}
              className="text-noahbrave-600 hover:text-noahbrave-700 font-medium text-sm hover:underline"
            >
              Log in
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default UserDetailsStep;
