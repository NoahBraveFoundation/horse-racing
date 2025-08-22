import { graphql } from 'react-relay';

export const removeGiftBasketFromCartMutation = graphql`
  mutation removeGiftBasketFromCartMutation($giftId: UUID!) {
    removeGiftBasketFromCart(giftId: $giftId)
  }
`;
