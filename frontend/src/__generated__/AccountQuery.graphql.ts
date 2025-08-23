/**
 * @generated SignedSource<<733acc424205b9721404207578c9903a>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type AccountQuery$variables = Record<PropertyKey, never>;
export type AccountQuery$data = {
  readonly myCart: {
    readonly cost: {
      readonly horseCents: number;
      readonly ticketsCents: number;
      readonly totalCents: number;
    };
    readonly horses: ReadonlyArray<{
      readonly costCents: number;
      readonly horseName: string;
      readonly id: any | null | undefined;
      readonly ownershipLabel: string;
    }>;
    readonly id: any | null | undefined;
    readonly tickets: ReadonlyArray<{
      readonly attendeeFirst: string;
      readonly attendeeLast: string;
      readonly costCents: number;
      readonly id: any | null | undefined;
    }>;
  } | null | undefined;
};
export type AccountQuery = {
  response: AccountQuery$data;
  variables: AccountQuery$variables;
};

const node: ConcreteRequest = (function(){
var v0 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
},
v1 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "costCents",
  "storageKey": null
},
v2 = [
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
        "concreteType": "Ticket",
        "kind": "LinkedField",
        "name": "tickets",
        "plural": true,
        "selections": [
          (v0/*: any*/),
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "attendeeFirst",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "attendeeLast",
            "storageKey": null
          },
          (v1/*: any*/)
        ],
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "concreteType": "Horse",
        "kind": "LinkedField",
        "name": "horses",
        "plural": true,
        "selections": [
          (v0/*: any*/),
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "horseName",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "ownershipLabel",
            "storageKey": null
          },
          (v1/*: any*/)
        ],
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
            "name": "ticketsCents",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "horseCents",
            "storageKey": null
          },
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
    "name": "AccountQuery",
    "selections": (v2/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "AccountQuery",
    "selections": (v2/*: any*/)
  },
  "params": {
    "cacheID": "6766c7a4b8cb33f507a58a6d7882b379",
    "id": null,
    "metadata": {},
    "name": "AccountQuery",
    "operationKind": "query",
    "text": "query AccountQuery {\n  myCart {\n    id\n    tickets {\n      id\n      attendeeFirst\n      attendeeLast\n      costCents\n    }\n    horses {\n      id\n      horseName\n      ownershipLabel\n      costCents\n    }\n    cost {\n      ticketsCents\n      horseCents\n      totalCents\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "fbd430af538cf00e33b7bf9aa674f638";

export default node;
