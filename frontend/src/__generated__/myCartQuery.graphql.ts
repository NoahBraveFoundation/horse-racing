/**
 * @generated SignedSource<<88ae0c2c2ac03d3b7289f2b420ed5a75>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type myCartQuery$variables = Record<PropertyKey, never>;
export type myCartQuery$data = {
  readonly myCart: {
    readonly cost: {
      readonly horseCents: number;
      readonly sponsorCents: number;
      readonly ticketsCents: number;
      readonly totalCents: number;
    };
    readonly horses: ReadonlyArray<{
      readonly horseName: string;
      readonly id: any | null | undefined;
      readonly ownershipLabel: string;
    }>;
    readonly id: any | null | undefined;
    readonly tickets: ReadonlyArray<{
      readonly attendeeFirst: string;
      readonly attendeeLast: string;
      readonly id: any | null | undefined;
    }>;
  };
};
export type myCartQuery = {
  response: myCartQuery$data;
  variables: myCartQuery$variables;
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
          }
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
          }
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
            "name": "sponsorCents",
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
    "name": "myCartQuery",
    "selections": (v1/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "myCartQuery",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "09fb5c71da3647c4cf23439dbf140f08",
    "id": null,
    "metadata": {},
    "name": "myCartQuery",
    "operationKind": "query",
    "text": "query myCartQuery {\n  myCart {\n    id\n    tickets {\n      id\n      attendeeFirst\n      attendeeLast\n    }\n    horses {\n      id\n      horseName\n      ownershipLabel\n    }\n    cost {\n      ticketsCents\n      horseCents\n      sponsorCents\n      totalCents\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "6ea83e189d3309d8cf4b698040d42a9e";

export default node;
