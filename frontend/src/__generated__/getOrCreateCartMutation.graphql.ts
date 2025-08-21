/**
 * @generated SignedSource<<9d38943e7044572c13b46c5cf2f379d8>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type getOrCreateCartMutation$variables = Record<PropertyKey, never>;
export type getOrCreateCartMutation$data = {
  readonly getOrCreateCart: {
    readonly horses: ReadonlyArray<{
      readonly id: any | null | undefined;
    }>;
    readonly id: any | null | undefined;
    readonly tickets: ReadonlyArray<{
      readonly id: any | null | undefined;
    }>;
  };
};
export type getOrCreateCartMutation = {
  response: getOrCreateCartMutation$data;
  variables: getOrCreateCartMutation$variables;
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
  (v0/*: any*/)
],
v2 = [
  {
    "alias": null,
    "args": null,
    "concreteType": "Cart",
    "kind": "LinkedField",
    "name": "getOrCreateCart",
    "plural": false,
    "selections": [
      (v0/*: any*/),
      {
        "alias": null,
        "args": null,
        "concreteType": "Ticket",
        "kind": "LinkedField",
        "name": "tickets",
        "plural": true,
        "selections": (v1/*: any*/),
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "concreteType": "Horse",
        "kind": "LinkedField",
        "name": "horses",
        "plural": true,
        "selections": (v1/*: any*/),
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
    "name": "getOrCreateCartMutation",
    "selections": (v2/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "getOrCreateCartMutation",
    "selections": (v2/*: any*/)
  },
  "params": {
    "cacheID": "c0841c92fb57a92294ffe6e7651bd21f",
    "id": null,
    "metadata": {},
    "name": "getOrCreateCartMutation",
    "operationKind": "mutation",
    "text": "mutation getOrCreateCartMutation {\n  getOrCreateCart {\n    id\n    tickets {\n      id\n    }\n    horses {\n      id\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "974be4a4c5da86791dca5bcd795f489c";

export default node;
