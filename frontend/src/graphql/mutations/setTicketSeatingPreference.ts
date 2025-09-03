import { graphql } from 'react-relay';

export const setTicketSeatingPreferenceMutation = graphql`
  mutation setTicketSeatingPreferenceMutation($ticketId: UUID!, $seatingPreference: String) {
    setTicketSeatingPreference(ticketId: $ticketId, seatingPreference: $seatingPreference) {
      id
      seatingPreference
    }
  }
`;
