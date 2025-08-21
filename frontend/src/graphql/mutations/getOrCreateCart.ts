import { graphql } from 'react-relay';

export const getOrCreateCartMutationGQL = graphql`
  mutation getOrCreateCartMutation {
    getOrCreateCart {
      id
      tickets { id }
      horses { id }
    }
  }
`;
