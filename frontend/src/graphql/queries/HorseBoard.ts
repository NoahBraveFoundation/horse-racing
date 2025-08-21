import { graphql } from 'react-relay';

export const HorseBoardQuery = graphql`
  query HorseBoardQuery {
    rounds {
      id
      name
      startAt
      endAt
      lanes {
        id
        number
        horse {
          id
          horseName
          ownershipLabel
          owner {
            firstName
            lastName
          }
        }
      }
    }
  }
`;
