import { graphql } from 'react-relay';

export const addSponsorToCartMutation = graphql`
  mutation addSponsorToCartMutation($companyName: String!, $amountCents: Int!, $companyLogoBase64: String) {
    addSponsorToCart(companyName: $companyName, amountCents: $amountCents, companyLogoBase64: $companyLogoBase64) { id companyName companyLogoBase64 }
  }
`;
