/**
 * @generated SignedSource<<af7eae968eab00646ac54458336d2919>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type addSponsorToCartMutation$variables = {
  amountCents: number;
  companyLogoBase64?: string | null | undefined;
  companyName: string;
};
export type addSponsorToCartMutation$data = {
  readonly addSponsorToCart: {
    readonly companyLogoBase64: string | null | undefined;
    readonly companyName: string;
    readonly id: any | null | undefined;
  };
};
export type addSponsorToCartMutation = {
  response: addSponsorToCartMutation$data;
  variables: addSponsorToCartMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "amountCents"
},
v1 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "companyLogoBase64"
},
v2 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "companyName"
},
v3 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "amountCents",
        "variableName": "amountCents"
      },
      {
        "kind": "Variable",
        "name": "companyLogoBase64",
        "variableName": "companyLogoBase64"
      },
      {
        "kind": "Variable",
        "name": "companyName",
        "variableName": "companyName"
      }
    ],
    "concreteType": "SponsorInterest",
    "kind": "LinkedField",
    "name": "addSponsorToCart",
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
        "name": "companyName",
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
      (v1/*: any*/),
      (v2/*: any*/)
    ],
    "kind": "Fragment",
    "metadata": null,
    "name": "addSponsorToCartMutation",
    "selections": (v3/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [
      (v2/*: any*/),
      (v0/*: any*/),
      (v1/*: any*/)
    ],
    "kind": "Operation",
    "name": "addSponsorToCartMutation",
    "selections": (v3/*: any*/)
  },
  "params": {
    "cacheID": "962a82405c6fef897b74d76cd4046b1d",
    "id": null,
    "metadata": {},
    "name": "addSponsorToCartMutation",
    "operationKind": "mutation",
    "text": "mutation addSponsorToCartMutation(\n  $companyName: String!\n  $amountCents: Int!\n  $companyLogoBase64: String\n) {\n  addSponsorToCart(companyName: $companyName, amountCents: $amountCents, companyLogoBase64: $companyLogoBase64) {\n    id\n    companyName\n    companyLogoBase64\n  }\n}\n"
  }
};
})();

(node as any).hash = "96933e07bcfe7ef6772e5b7be961b572";

export default node;
