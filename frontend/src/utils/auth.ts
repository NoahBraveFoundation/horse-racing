import { useMutation } from 'react-relay';
import { logoutMutation } from '../graphql/mutations/logout';
import type { logoutMutation as LogoutMutationType } from '../__generated__/logoutMutation.graphql';

// Hook: provides a logout function that calls backend to clear cookie, then clears client state
export function useLogout() {
  // eslint-disable-next-line react-hooks/rules-of-hooks
  const [commit] = useMutation<LogoutMutationType>(logoutMutation);

  const logout = (redirectTo: string = '/login') =>
    new Promise<void>((resolve) => {
      commit({
        variables: {},
        onCompleted: () => {
          try { localStorage.removeItem('user'); } catch {}
          window.location.href = redirectTo;
          resolve();
        },
        onError: () => {
          try { localStorage.removeItem('user'); } catch {}
          window.location.href = redirectTo;
          resolve();
        },
      });
    });

  return { logout };
}

// Non-hook utility for places outside React components (fallbacks, etc.)
export async function logoutAndRedirect(redirectTo: string = '/login') {
  try { localStorage.removeItem('user'); } catch {}
  window.location.href = redirectTo;
}


