/**
 * @generated SignedSource<<68588fedb16ad5877635ab7f5702374c>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type TicketState = "confirmed" | "on_hold" | "pending_payment" | "%future added value";
export type TicketSelectionStepCartTicketsQuery$variables = Record<PropertyKey, never>;
export type TicketSelectionStepCartTicketsQuery$data = {
  readonly me: {
    readonly firstName: string;
    readonly id: any | null | undefined;
    readonly lastName: string;
    readonly tickets: ReadonlyArray<{
      readonly attendeeFirst: string;
      readonly attendeeLast: string;
      readonly canRemove: boolean;
      readonly id: any | null | undefined;
      readonly state: TicketState;
    }>;
  };
  readonly myCart: {
    readonly id: any | null | undefined;
    readonly tickets: ReadonlyArray<{
      readonly attendeeFirst: string;
      readonly attendeeLast: string;
      readonly canRemove: boolean;
      readonly id: any | null | undefined;
      readonly state: TicketState;
    }>;
  } | null | undefined;
};
export type TicketSelectionStepCartTicketsQuery = {
  response: TicketSelectionStepCartTicketsQuery$data;
  variables: TicketSelectionStepCartTicketsQuery$variables;
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
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "canRemove",
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "state",
      "storageKey": null
    }
  ],
  "storageKey": null
},
v2 = [
  {
    "alias": null,
    "args": null,
    "concreteType": "User",
    "kind": "LinkedField",
    "name": "me",
    "plural": false,
    "selections": [
      (v0/*: any*/),
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "firstName",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "lastName",
        "storageKey": null
      },
      (v1/*: any*/)
    ],
    "storageKey": null
  },
  {
    "alias": null,
    "args": null,
    "concreteType": "Cart",
    "kind": "LinkedField",
    "name": "myCart",
    "plural": false,
    "selections": [
      (v0/*: any*/),
      (v1/*: any*/)
    ],
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "TicketSelectionStepCartTicketsQuery",
    "selections": (v2/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "TicketSelectionStepCartTicketsQuery",
    "selections": (v2/*: any*/)
  },
  "params": {
    "cacheID": "6c3cae7589da53ecfb45f2429d4dc3cf",
    "id": null,
    "metadata": {},
    "name": "TicketSelectionStepCartTicketsQuery",
    "operationKind": "query",
    "text": "query TicketSelectionStepCartTicketsQuery {\n  me {\n    id\n    firstName\n    lastName\n    tickets {\n      id\n      attendeeFirst\n      attendeeLast\n      canRemove\n      state\n    }\n  }\n  myCart {\n    id\n    tickets {\n      id\n      attendeeFirst\n      attendeeLast\n      canRemove\n      state\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "b4b97ea4bbaf3fc1499ac1235d77717d";

export default node;
