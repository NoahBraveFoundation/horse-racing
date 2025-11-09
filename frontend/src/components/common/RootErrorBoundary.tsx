import { isRouteErrorResponse, useRouteError } from 'react-router-dom';
import ErrorFallback from './ErrorFallback';

/**
 * Root error boundary for React Router
 * Handles 404s and other routing errors with thematic error views
 */
const RootErrorBoundary = () => {
  const error = useRouteError();

  // Handle 404 - page not found
  if (isRouteErrorResponse(error) && error.status === 404) {
    return (
      <ErrorFallback
        title="Page Not Found"
        message="The page you're looking for doesn't exist. Let's get you back on track!"
        showLogout={false}
        showRetry={false}
        showHome
      />
    );
  }

  // Handle other routing errors
  if (isRouteErrorResponse(error)) {
    return (
      <ErrorFallback
        title="Something Went Wrong"
        message={error.statusText || "We encountered an unexpected error. Please try again or return home."}
        showLogout={false}
        showRetry
        showHome
      />
    );
  }

  // Handle generic errors
  if (error instanceof Error) {
    return (
      <ErrorFallback
        title="Something Went Wrong"
        message={error.message || "An unexpected error occurred. Please try again or return home."}
        showLogout={false}
        showRetry
        showHome
      />
    );
  }

  // Fallback for unknown error types
  return (
    <ErrorFallback
      title="Something Went Wrong"
      message="An unexpected error occurred. Please try again or return home."
      showLogout={false}
      showRetry
      showHome
    />
  );
};

export default RootErrorBoundary;
