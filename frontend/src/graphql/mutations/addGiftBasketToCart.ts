import { graphql } from 'react-relay';

export const addGiftBasketToCartMutation = graphql`
  mutation addGiftBasketToCartMutation($description: String!) {
    addGiftBasketToCart(description: $description) { id description }
  }
`;
