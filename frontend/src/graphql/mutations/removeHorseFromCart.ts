import { graphql } from 'react-relay';

export const removeHorseFromCartMutation = graphql`
  mutation removeHorseFromCartMutation($horseId: UUID!) {
    removeHorseFromCart(horseId: $horseId)
  }
`;
