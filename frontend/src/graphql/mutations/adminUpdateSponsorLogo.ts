import { graphql } from 'react-relay'

export const adminUpdateSponsorLogoMutation = graphql`
  mutation adminUpdateSponsorLogoMutation($sponsorInterestId: UUID!, $companyLogoBase64: String) {
    adminUpdateSponsorLogo(sponsorInterestId: $sponsorInterestId, companyLogoBase64: $companyLogoBase64) {
      id
      companyLogoBase64
    }
  }
`
