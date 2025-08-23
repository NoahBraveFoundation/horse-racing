import { graphql } from 'react-relay';

export const renameHorseMutation = graphql`
  mutation renameHorseMutation($horseId: UUID!, $horseName: String!, $ownershipLabel: String!) {
    renameHorse(horseId: $horseId, horseName: $horseName, ownershipLabel: $ownershipLabel) {
      id
      horseName
      ownershipLabel
    }
  }
`;
