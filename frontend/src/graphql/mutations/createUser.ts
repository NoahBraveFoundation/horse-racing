import { graphql } from 'react-relay';

export const createUserMutation = graphql`
  mutation createUserMutation(
    $firstName: String!
    $lastName: String!
    $email: String!
  ) {
    createUser(
      firstName: $firstName
      lastName: $lastName
      email: $email
    ) {
      id
      firstName
      lastName
      email
    }
  }
`;
