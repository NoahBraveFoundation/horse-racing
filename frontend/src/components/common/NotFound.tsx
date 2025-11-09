import ErrorFallback from './ErrorFallback';

/**
 * 404 Not Found page component
 */
const NotFound = () => {
  return (
    <ErrorFallback
      title="Page Not Found"
      message="The page you're looking for doesn't exist. Let's get you back on track!"
      showLogout={false}
      showRetry={false}
      showHome
    />
  );
};

export default NotFound;
