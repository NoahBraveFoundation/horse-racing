/**
 * @generated SignedSource<<c1e7ecf6efcd406c893aadc8e049737d>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type setTicketSeatAssignmentMutation$variables = {
  seatAssignment?: string | null | undefined;
  ticketId: any;
};
export type setTicketSeatAssignmentMutation$data = {
  readonly setTicketSeatAssignment: {
    readonly id: any | null | undefined;
    readonly seatAssignment: string | null | undefined;
  };
};
export type setTicketSeatAssignmentMutation = {
  response: setTicketSeatAssignmentMutation$data;
  variables: setTicketSeatAssignmentMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "seatAssignment"
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
        "name": "seatAssignment",
        "variableName": "seatAssignment"
      },
      {
        "kind": "Variable",
        "name": "ticketId",
        "variableName": "ticketId"
      }
    ],
    "concreteType": "Ticket",
    "kind": "LinkedField",
    "name": "setTicketSeatAssignment",
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
        "name": "seatAssignment",
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
    "name": "setTicketSeatAssignmentMutation",
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
    "name": "setTicketSeatAssignmentMutation",
    "selections": (v2/*: any*/)
  },
  "params": {
    "cacheID": "fae4e99bc2403408f11f414b332215fb",
    "id": null,
    "metadata": {},
    "name": "setTicketSeatAssignmentMutation",
    "operationKind": "mutation",
    "text": "mutation setTicketSeatAssignmentMutation(\n  $ticketId: UUID!\n  $seatAssignment: String\n) {\n  setTicketSeatAssignment(ticketId: $ticketId, seatAssignment: $seatAssignment) {\n    id\n    seatAssignment\n  }\n}\n"
  }
};
})();

(node as any).hash = "507ec74ebe65ac2a5c3b7ad9c9143812";

export default node;
