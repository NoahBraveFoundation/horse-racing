/**
 * Get the GraphQL API URL based on the environment
 */
export function getApiUrl(): string {
  const API_URL = import.meta.env.VITE_API_URL || '/graphql';
  return import.meta.env.DEV ? '/graphql' : API_URL;
}
