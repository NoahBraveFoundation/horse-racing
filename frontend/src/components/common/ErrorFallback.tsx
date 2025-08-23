import React from 'react';
import { logoutAndRedirect } from '../../utils/auth';

interface ErrorFallbackProps {
  title?: string;
  message?: string;
  showLogout?: boolean;
  showRetry?: boolean;
  showHome?: boolean;
  onRetry?: () => void;
  logoutRedirectTo?: string;
}

export const ErrorFallback: React.FC<ErrorFallbackProps> = ({
  title = "We hit a snag",
  message = "Something went wrong. Please try again, or sign out and sign back in.",
  showLogout = true,
  showRetry = true,
  showHome = true,
  onRetry,
  logoutRedirectTo = '/login'
}) => {
  const handleRetry = () => {
    if (onRetry) {
      onRetry();
    } else {
      window.location.reload();
    }
  };

  const handleLogout = () => {
    logoutAndRedirect(logoutRedirectTo);
  };

  return (
    <div className="min-h-screen bg-noahbrave-50 font-body pb-32">
      <div className="checker-top h-3" style={{ backgroundColor: 'var(--brand)' }} />
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        <div className="bg-white rounded-2xl shadow-xl border border-noahbrave-200 p-8 text-center">
          <div className="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-6">
            <svg className="w-8 h-8 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v2m0 4h.01M21 12A9 9 0 113 12a9 9 0 0118 0z" />
            </svg>
          </div>
          <h2 className="font-heading text-2xl text-gray-900 mb-2">{title}</h2>
          <p className="text-gray-700 mb-6">{message}</p>
          <div className="flex flex-col sm:flex-row items-center justify-center gap-3">
            {showLogout && (
              <button
                type="button"
                onClick={handleLogout}
                className="cta px-6 py-3 rounded-lg font-semibold w-full sm:w-auto text-center"
              >
                Logout
              </button>
            )}
            {showRetry && (
              <button 
                type="button" 
                onClick={handleRetry} 
                className="px-6 py-3 rounded-lg border text-gray-700 hover:bg-gray-50 w-full sm:w-auto"
              >
                Retry
              </button>
            )}
            {showHome && (
              <a 
                href="/" 
                className="px-6 py-3 rounded-lg border text-gray-700 hover:bg-gray-50 w-full sm:w-auto text-center"
              >
                Home
              </a>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default ErrorFallback;
