/**
 * @generated SignedSource<<manually_generated_for_adminUpdateSponsorLogo>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type DashboardUpdateSponsorLogoMutation$variables = {
  sponsorInterestId: any;
  companyLogoBase64?: string | null;
};
export type DashboardUpdateSponsorLogoMutation$data = {
  readonly adminUpdateSponsorLogo: {
    readonly id: any | null;
    readonly companyLogoBase64: string | null;
  };
};
export type DashboardUpdateSponsorLogoMutation = {
  response: DashboardUpdateSponsorLogoMutation$data;
  variables: DashboardUpdateSponsorLogoMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "sponsorInterestId"
  },
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "companyLogoBase64"
  }
],
v1 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "sponsorInterestId",
        "variableName": "sponsorInterestId"
      },
      {
        "kind": "Variable",
        "name": "companyLogoBase64",
        "variableName": "companyLogoBase64"
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
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "DashboardUpdateSponsorLogoMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "DashboardUpdateSponsorLogoMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "manually_generated_adminUpdateSponsorLogo",
    "id": null,
    "metadata": {},
    "name": "DashboardUpdateSponsorLogoMutation",
    "operationKind": "mutation",
    "text": "mutation DashboardUpdateSponsorLogoMutation(\n  $sponsorInterestId: UUID!\n  $companyLogoBase64: String\n) {\n  adminUpdateSponsorLogo(sponsorInterestId: $sponsorInterestId, companyLogoBase64: $companyLogoBase64) {\n    id\n    companyLogoBase64\n  }\n}\n"
  }
};
})();

(node as any).hash = "manually_generated_adminUpdateSponsorLogo";

export default node;
