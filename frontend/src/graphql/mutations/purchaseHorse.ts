import { graphql } from 'react-relay';

export const purchaseHorseMutation = graphql`
  mutation purchaseHorseMutation(
    $roundId: UUID!
    $laneId: UUID!
    $horseName: String!
    $ownershipLabel: String!
  ) {
    purchaseHorse(
      roundId: $roundId
      laneId: $laneId
      horseName: $horseName
      ownershipLabel: $ownershipLabel
    ) {
      id
      horseName
      ownershipLabel
      owner { id firstName lastName }
      lane { id }
      round { id }
    }
  }
`;
