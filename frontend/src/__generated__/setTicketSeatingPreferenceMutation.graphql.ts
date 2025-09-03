/**
 * @generated SignedSource<<84d122af39e37c99e74302e43904c85e>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type setTicketSeatingPreferenceMutation$variables = {
  seatingPreference?: string | null | undefined;
  ticketId: any;
};
export type setTicketSeatingPreferenceMutation$data = {
  readonly setTicketSeatingPreference: {
    readonly id: any | null | undefined;
    readonly seatingPreference: string | null | undefined;
  };
};
export type setTicketSeatingPreferenceMutation = {
  response: setTicketSeatingPreferenceMutation$data;
  variables: setTicketSeatingPreferenceMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "seatingPreference"
},
v1 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "ticketId"
},
v2 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "seatingPreference",
        "variableName": "seatingPreference"
      },
      {
        "kind": "Variable",
        "name": "ticketId",
        "variableName": "ticketId"
      }
    ],
    "concreteType": "Ticket",
    "kind": "LinkedField",
    "name": "setTicketSeatingPreference",
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
        "kind": "ScalarField",
        "name": "seatingPreference",
        "storageKey": null
      }
    ],
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": [
      (v0/*: any*/),
      (v1/*: any*/)
    ],
    "kind": "Fragment",
    "metadata": null,
    "name": "setTicketSeatingPreferenceMutation",
    "selections": (v2/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [
      (v1/*: any*/),
      (v0/*: any*/)
    ],
    "kind": "Operation",
    "name": "setTicketSeatingPreferenceMutation",
    "selections": (v2/*: any*/)
  },
  "params": {
    "cacheID": "d0be5439bce96209084ea7d60abc8179",
    "id": null,
    "metadata": {},
    "name": "setTicketSeatingPreferenceMutation",
    "operationKind": "mutation",
    "text": "mutation setTicketSeatingPreferenceMutation(\n  $ticketId: UUID!\n  $seatingPreference: String\n) {\n  setTicketSeatingPreference(ticketId: $ticketId, seatingPreference: $seatingPreference) {\n    id\n    seatingPreference\n  }\n}\n"
  }
};
})();

(node as any).hash = "d463d60627a88204fcfca6fb9028d149";

export default node;
