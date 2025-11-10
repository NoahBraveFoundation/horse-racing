import React from 'react';

interface LoadingIndicatorProps {
  label?: string;
}

const LoadingIndicator: React.FC<LoadingIndicatorProps> = ({ label = 'Loading...' }) => (
  <div className="flex flex-col items-center justify-center py-24" role="status" aria-live="polite">
    <svg
      className="h-12 w-12 animate-spin text-noahbrave-500"
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
    >
      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
      <path
        className="opacity-75"
        fill="currentColor"
        d="M4 12a8 8 0 018-8v4a4 4 0 00-4 4H4z"
      />
    </svg>
    <p className="mt-4 text-sm font-medium text-gray-600">{label}</p>
  </div>
);

export default LoadingIndicator;
