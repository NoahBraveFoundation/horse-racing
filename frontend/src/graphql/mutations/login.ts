import { graphql } from 'react-relay';

export const loginMutation = graphql`
  mutation loginMutation($email: String!) {
    login(email: $email) {
      success
      message
      tokenId
    }
  }
`;
