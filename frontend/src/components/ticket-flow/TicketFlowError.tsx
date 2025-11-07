import { isRouteErrorResponse, useRouteError } from 'react-router-dom';
import ErrorFallback from '../common/ErrorFallback';

function getErrorMessage(error: unknown): string {
  if (isRouteErrorResponse(error)) {
    if (error.status === 404) {
      return "We couldn't find that ticket step. Please return to the beginning.";
    }

    if (error.status === 500) {
      return 'Our ticketing service encountered an unexpected issue. Please try again shortly.';
    }

    return error.statusText || 'Something went wrong while loading your tickets.';
  }

  if (error instanceof Error) {
    return error.message;
  }

  return 'Something went wrong while loading your tickets.';
}

const TicketFlowError = () => {
  const error = useRouteError();
  const message = getErrorMessage(error);

  return (
    <ErrorFallback
      title="Ticket checkout hit a snag"
      message={message}
      showLogout={false}
      showRetry
      showHome
    />
  );
};

export default TicketFlowError;
