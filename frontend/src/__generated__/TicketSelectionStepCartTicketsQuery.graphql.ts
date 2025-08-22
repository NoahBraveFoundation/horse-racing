/**
 * @generated SignedSource<<6389ffb2c866ca141b741e826c17ceb9>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type TicketSelectionStepCartTicketsQuery$variables = Record<PropertyKey, never>;
export type TicketSelectionStepCartTicketsQuery$data = {
  readonly me: {
    readonly firstName: string;
    readonly id: any | null | undefined;
    readonly lastName: string;
  };
  readonly myCart: {
    readonly id: any | null | undefined;
    readonly tickets: ReadonlyArray<{
      readonly attendeeFirst: string;
      readonly attendeeLast: string;
      readonly canRemove: boolean;
      readonly id: any | null | undefined;
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
v1 = [
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
      }
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
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "canRemove",
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
    "name": "TicketSelectionStepCartTicketsQuery",
    "selections": (v1/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "TicketSelectionStepCartTicketsQuery",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "bb93a1e1c8509c37795477b0b187c27f",
    "id": null,
    "metadata": {},
    "name": "TicketSelectionStepCartTicketsQuery",
    "operationKind": "query",
    "text": "query TicketSelectionStepCartTicketsQuery {\n  me {\n    id\n    firstName\n    lastName\n  }\n  myCart {\n    id\n    tickets {\n      id\n      attendeeFirst\n      attendeeLast\n      canRemove\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "39ab20feb686fff5e7238d5d471da4c9";

export default node;
