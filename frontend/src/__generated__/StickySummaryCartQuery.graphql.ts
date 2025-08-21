/**
 * @generated SignedSource<<8675438a269591432fadcd7844b70eea>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type StickySummaryCartQuery$variables = Record<PropertyKey, never>;
export type StickySummaryCartQuery$data = {
  readonly myCart: {
    readonly cost: {
      readonly horseCents: number;
      readonly sponsorCents: number;
      readonly ticketsCents: number;
      readonly totalCents: number;
    };
    readonly horses: ReadonlyArray<{
      readonly id: any | null | undefined;
    }>;
    readonly id: any | null | undefined;
    readonly tickets: ReadonlyArray<{
      readonly id: any | null | undefined;
    }>;
  };
};
export type StickySummaryCartQuery = {
  response: StickySummaryCartQuery$data;
  variables: StickySummaryCartQuery$variables;
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
    "name": "myCart",
    "plural": false,
    "selections": [
      (v0/*: any*/),
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
      },
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
    "name": "StickySummaryCartQuery",
    "selections": (v2/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "StickySummaryCartQuery",
    "selections": (v2/*: any*/)
  },
  "params": {
    "cacheID": "9b2228042f6806942c099d033040910f",
    "id": null,
    "metadata": {},
    "name": "StickySummaryCartQuery",
    "operationKind": "query",
    "text": "query StickySummaryCartQuery {\n  myCart {\n    id\n    cost {\n      ticketsCents\n      horseCents\n      sponsorCents\n      totalCents\n    }\n    tickets {\n      id\n    }\n    horses {\n      id\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "4546577e4e36adc365b21b1608052ea6";

export default node;
