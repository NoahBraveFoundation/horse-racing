import { graphql } from 'react-relay';

export const removeTicketFromCartMutation = graphql`
  mutation removeTicketFromCartMutation($ticketId: UUID!) {
    removeTicketFromCart(ticketId: $ticketId)
  }
`;
