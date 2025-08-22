/**
 * @generated SignedSource<<db7d0e2d7644a3fd268c14d8b1d7d0d2>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type GiftBasketStepQuery$variables = Record<PropertyKey, never>;
export type GiftBasketStepQuery$data = {
  readonly myCart: {
    readonly giftBasketInterests: ReadonlyArray<{
      readonly description: string;
      readonly id: any | null | undefined;
    }>;
    readonly id: any | null | undefined;
  } | null | undefined;
};
export type GiftBasketStepQuery = {
  response: GiftBasketStepQuery$data;
  variables: GiftBasketStepQuery$variables;
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
        "concreteType": "GiftBasketInterest",
        "kind": "LinkedField",
        "name": "giftBasketInterests",
        "plural": true,
        "selections": [
          (v0/*: any*/),
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "description",
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
    "name": "GiftBasketStepQuery",
    "selections": (v1/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "GiftBasketStepQuery",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "4af3c399c7fc66e0fcb8093cef971767",
    "id": null,
    "metadata": {},
    "name": "GiftBasketStepQuery",
    "operationKind": "query",
    "text": "query GiftBasketStepQuery {\n  myCart {\n    id\n    giftBasketInterests {\n      id\n      description\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "9b59adce5ff077576fec9317f0012040";

export default node;
