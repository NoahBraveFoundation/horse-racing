/**
 * @generated SignedSource<<dd9b3474d74f7a98f266aa4e18cfe784>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type SponsorStepQuery$variables = Record<PropertyKey, never>;
export type SponsorStepQuery$data = {
  readonly myCart: {
    readonly id: any | null | undefined;
    readonly sponsorInterests: ReadonlyArray<{
      readonly companyLogoBase64: string | null | undefined;
      readonly companyName: string;
      readonly costCents: number;
      readonly id: any | null | undefined;
    }>;
  } | null | undefined;
};
export type SponsorStepQuery = {
  response: SponsorStepQuery$data;
  variables: SponsorStepQuery$variables;
};

const node: ConcreteRequest = (function(){
var v0 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
},
v1 = [
  {
    "alias": null,
    "args": null,
    "concreteType": "Cart",
    "kind": "LinkedField",
    "name": "myCart",
    "plural": false,
    "selections": [
      (v0/*: any*/),
      {
        "alias": null,
        "args": null,
        "concreteType": "SponsorInterest",
        "kind": "LinkedField",
        "name": "sponsorInterests",
        "plural": true,
        "selections": [
          (v0/*: any*/),
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
          },
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "costCents",
            "storageKey": null
          }
        ],
        "storageKey": null
      }
    ],
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "SponsorStepQuery",
    "selections": (v1/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "SponsorStepQuery",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "8d67765ea9fc488c9fd19a6499da5ea0",
    "id": null,
    "metadata": {},
    "name": "SponsorStepQuery",
    "operationKind": "query",
    "text": "query SponsorStepQuery {\n  myCart {\n    id\n    sponsorInterests {\n      id\n      companyName\n      companyLogoBase64\n      costCents\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "fe6933e7a4ab23341f9b94ef691797f9";

export default node;
