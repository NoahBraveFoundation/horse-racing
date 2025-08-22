import { graphql } from 'react-relay';

export const validateTokenMutation = graphql`
  mutation validateTokenMutation($token: String!) {
    validateToken(token: $token) {
      success
      message
      user {
        id
        email
        firstName
        lastName
        isAdmin
      }
    }
  }
`;
