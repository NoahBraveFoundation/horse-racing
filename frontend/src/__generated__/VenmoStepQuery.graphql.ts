/**
 * @generated SignedSource<<1e7ae59caf56edd413fa8c5aff2fd400>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type VenmoStepQuery$variables = Record<PropertyKey, never>;
export type VenmoStepQuery$data = {
  readonly myCart: {
    readonly cost: {
      readonly totalCents: number;
    };
    readonly id: any | null | undefined;
  };
};
export type VenmoStepQuery = {
  response: VenmoStepQuery$data;
  variables: VenmoStepQuery$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "alias": null,
    "args": null,
    "concreteType": "Cart",
    "kind": "LinkedField",
    "name": "myCart",
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
        "concreteType": "CartCost",
        "kind": "LinkedField",
        "name": "cost",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "totalCents",
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
    "name": "VenmoStepQuery",
    "selections": (v0/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "VenmoStepQuery",
    "selections": (v0/*: any*/)
  },
  "params": {
    "cacheID": "3a5c8086a3089254eeac3cf9df9a80da",
    "id": null,
    "metadata": {},
    "name": "VenmoStepQuery",
    "operationKind": "query",
    "text": "query VenmoStepQuery {\n  myCart {\n    id\n    cost {\n      totalCents\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "2a83c890eebbe8daf2a1a839e784bdf5";

export default node;
