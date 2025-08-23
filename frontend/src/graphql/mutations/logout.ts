import { graphql } from 'react-relay';

// Minimal logout mutation. Backend should clear auth cookie.
export const logoutMutation = graphql`
  mutation logoutMutation {
    logout {
      success
      message
    }
  }
`;


