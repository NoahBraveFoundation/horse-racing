import { graphql } from 'react-relay';

export const addSponsorToCartMutation = graphql`
  mutation addSponsorToCartMutation($companyName: String!, $companyLogoBase64: String) {
    addSponsorToCart(companyName: $companyName, companyLogoBase64: $companyLogoBase64) { id companyName companyLogoBase64 }
  }
`;
