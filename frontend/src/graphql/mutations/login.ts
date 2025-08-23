import { graphql } from 'react-relay';

export const loginMutation = graphql`
  mutation loginMutation($email: String!, $redirectTo: String) {
    login(email: $email, redirectTo: $redirectTo) {
      success
      message
      tokenId
    }
  }
`;
