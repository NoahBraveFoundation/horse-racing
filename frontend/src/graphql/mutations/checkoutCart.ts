import { graphql } from 'react-relay';

export const checkoutCartMutation = graphql`
  mutation checkoutCartMutation {
    checkoutCart { id totalCents paymentReceived }
  }
`;
