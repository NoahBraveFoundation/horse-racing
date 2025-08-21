import { graphql } from 'react-relay';

export const MyCartQuery = graphql`
  query myCartQuery {
    myCart {
      id
      tickets { id attendeeFirst attendeeLast }
      horses { id horseName ownershipLabel }
      cost {
        ticketsCents
        horseCents
        sponsorCents
        totalCents
      }
    }
  }
`;
