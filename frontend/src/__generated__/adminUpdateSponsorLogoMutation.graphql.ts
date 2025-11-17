/**
 * @generated SignedSource<<a124d6a100b6ab617873419a4c672b9a>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type adminUpdateSponsorLogoMutation$variables = {
  companyLogoBase64?: string | null | undefined;
  sponsorInterestId: any;
};
export type adminUpdateSponsorLogoMutation$data = {
  readonly adminUpdateSponsorLogo: {
    readonly companyLogoBase64: string | null | undefined;
    readonly id: any | null | undefined;
  };
};
export type adminUpdateSponsorLogoMutation = {
  response: adminUpdateSponsorLogoMutation$data;
  variables: adminUpdateSponsorLogoMutation$variables;
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
    "name": "adminUpdateSponsorLogoMutation",
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
    "name": "adminUpdateSponsorLogoMutation",
    "selections": (v2/*: any*/)
  },
  "params": {
    "cacheID": "49863ac64be0ad07a9cb9d5a1b57b8b9",
    "id": null,
    "metadata": {},
    "name": "adminUpdateSponsorLogoMutation",
    "operationKind": "mutation",
    "text": "mutation adminUpdateSponsorLogoMutation(\n  $sponsorInterestId: UUID!\n  $companyLogoBase64: String\n) {\n  adminUpdateSponsorLogo(sponsorInterestId: $sponsorInterestId, companyLogoBase64: $companyLogoBase64) {\n    id\n    companyLogoBase64\n  }\n}\n"
  }
};
})();

(node as any).hash = "82331edce9063aaf14223cc5791a435d";

export default node;
