import { graphql } from 'react-relay';

export const addHorseToCartMutation = graphql`
  mutation addHorseToCartMutation($roundId: UUID!, $laneId: UUID!, $horseName: String!, $ownershipLabel: String!) {
    addHorseToCart(roundId: $roundId, laneId: $laneId, horseName: $horseName, ownershipLabel: $ownershipLabel) {
      id
      horseName
      ownershipLabel
      owner { id }
    }
  }
`;
