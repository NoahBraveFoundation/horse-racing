/**
 * @generated SignedSource<<ea99d17b7ca61521367c1775dc661b91>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type DashboardUpdateSponsorLogoMutation$variables = {
  companyLogoBase64?: string | null | undefined;
  sponsorInterestId: any;
};
export type DashboardUpdateSponsorLogoMutation$data = {
  readonly adminUpdateSponsorLogo: {
    readonly companyLogoBase64: string | null | undefined;
    readonly id: any | null | undefined;
  };
};
export type DashboardUpdateSponsorLogoMutation = {
  response: DashboardUpdateSponsorLogoMutation$data;
  variables: DashboardUpdateSponsorLogoMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "companyLogoBase64"
},
v1 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "sponsorInterestId"
},
v2 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "companyLogoBase64",
        "variableName": "companyLogoBase64"
      },
      {
        "kind": "Variable",
        "name": "sponsorInterestId",
        "variableName": "sponsorInterestId"
      }
    ],
    "concreteType": "SponsorInterest",
    "kind": "LinkedField",
    "name": "adminUpdateSponsorLogo",
    "plural": false,
    "selections": [
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "id",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "companyLogoBase64",
        "storageKey": null
      }
    ],
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": [
      (v0/*: any*/),
      (v1/*: any*/)
    ],
    "kind": "Fragment",
    "metadata": null,
    "name": "DashboardUpdateSponsorLogoMutation",
    "selections": (v2/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [
      (v1/*: any*/),
      (v0/*: any*/)
    ],
    "kind": "Operation",
    "name": "DashboardUpdateSponsorLogoMutation",
    "selections": (v2/*: any*/)
  },
  "params": {
    "cacheID": "69a5654627073389713c1d2eeb30b89e",
    "id": null,
    "metadata": {},
    "name": "DashboardUpdateSponsorLogoMutation",
    "operationKind": "mutation",
    "text": "mutation DashboardUpdateSponsorLogoMutation(\n  $sponsorInterestId: UUID!\n  $companyLogoBase64: String\n) {\n  adminUpdateSponsorLogo(sponsorInterestId: $sponsorInterestId, companyLogoBase64: $companyLogoBase64) {\n    id\n    companyLogoBase64\n  }\n}\n"
  }
};
})();

(node as any).hash = "2945e6b1b93aae7d5ad9ada16f27e238";

export default node;
