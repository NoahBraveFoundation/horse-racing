/**
 * @generated SignedSource<<a1f86a41834238962a8297ad91dff136>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type DashboardSetSeatAssignmentMutation$variables = {
  seatAssignment?: string | null | undefined;
  ticketId: any;
};
export type DashboardSetSeatAssignmentMutation$data = {
  readonly setTicketSeatAssignment: {
    readonly id: any | null | undefined;
    readonly seatAssignment: string | null | undefined;
  };
};
export type DashboardSetSeatAssignmentMutation = {
  response: DashboardSetSeatAssignmentMutation$data;
  variables: DashboardSetSeatAssignmentMutation$variables;
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
    "name": "DashboardSetSeatAssignmentMutation",
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
    "name": "DashboardSetSeatAssignmentMutation",
    "selections": (v2/*: any*/)
  },
  "params": {
    "cacheID": "9dcbb7f0b19af55a29c8373eec7c248d",
    "id": null,
    "metadata": {},
    "name": "DashboardSetSeatAssignmentMutation",
    "operationKind": "mutation",
    "text": "mutation DashboardSetSeatAssignmentMutation(\n  $ticketId: UUID!\n  $seatAssignment: String\n) {\n  setTicketSeatAssignment(ticketId: $ticketId, seatAssignment: $seatAssignment) {\n    id\n    seatAssignment\n  }\n}\n"
  }
};
})();

(node as any).hash = "f769cb78e9301658660542f8b9c618a3";

export default node;
