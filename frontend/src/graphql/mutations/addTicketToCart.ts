import { graphql } from 'react-relay';

export const addTicketToCartMutation = graphql`
  mutation addTicketToCartMutation($attendeeFirst: String!, $attendeeLast: String!) {
    addTicketToCart(attendeeFirst: $attendeeFirst, attendeeLast: $attendeeLast) {
      id
      attendeeFirst
      attendeeLast
      owner { id }
    }
  }
`;
