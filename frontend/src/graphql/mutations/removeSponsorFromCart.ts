import { graphql } from 'react-relay';

export const removeSponsorFromCartMutation = graphql`
  mutation removeSponsorFromCartMutation($sponsorId: UUID!) {
    removeSponsorFromCart(sponsorId: $sponsorId)
  }
`;
