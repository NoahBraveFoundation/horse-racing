import { graphql } from 'react-relay';

export const setTicketSeatAssignmentMutation = graphql`
  mutation setTicketSeatAssignmentMutation($ticketId: UUID!, $seatAssignment: String) {
    setTicketSeatAssignment(ticketId: $ticketId, seatAssignment: $seatAssignment) {
      id
      seatAssignment
    }
  }
`;
