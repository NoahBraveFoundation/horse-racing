/**
 * @generated SignedSource<<ee52e0c4b998f71b848aeb4f923d91dd>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type addTicketToCartMutation$variables = {
  attendeeFirst: string;
  attendeeLast: string;
};
export type addTicketToCartMutation$data = {
  readonly addTicketToCart: {
    readonly attendeeFirst: string;
    readonly attendeeLast: string;
    readonly id: any | null | undefined;
    readonly owner: {
      readonly id: any | null | undefined;
    };
  };
};
export type addTicketToCartMutation = {
  response: addTicketToCartMutation$data;
  variables: addTicketToCartMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "attendeeFirst"
  },
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "attendeeLast"
  }
],
v1 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
},
v2 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "attendeeFirst",
        "variableName": "attendeeFirst"
      },
      {
        "kind": "Variable",
        "name": "attendeeLast",
        "variableName": "attendeeLast"
      }
    ],
    "concreteType": "Ticket",
    "kind": "LinkedField",
    "name": "addTicketToCart",
    "plural": false,
    "selections": [
      (v1/*: any*/),
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
        "concreteType": "User",
        "kind": "LinkedField",
        "name": "owner",
        "plural": false,
        "selections": [
          (v1/*: any*/)
        ],
        "storageKey": null
      }
    ],
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "addTicketToCartMutation",
    "selections": (v2/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "addTicketToCartMutation",
    "selections": (v2/*: any*/)
  },
  "params": {
    "cacheID": "c08770549ae30a1a292fc98d16025640",
    "id": null,
    "metadata": {},
    "name": "addTicketToCartMutation",
    "operationKind": "mutation",
    "text": "mutation addTicketToCartMutation(\n  $attendeeFirst: String!\n  $attendeeLast: String!\n) {\n  addTicketToCart(attendeeFirst: $attendeeFirst, attendeeLast: $attendeeLast) {\n    id\n    attendeeFirst\n    attendeeLast\n    owner {\n      id\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "d376a02511720b37f0867c4174c20593";

export default node;
