/**
 * @generated SignedSource<<87fc0bd1fbee0aefb325719a6ded8152>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type AdminUserRemoveTicketMutation$variables = {
  ticketId: any;
};
export type AdminUserRemoveTicketMutation$data = {
  readonly adminRemoveTicket: boolean;
};
export type AdminUserRemoveTicketMutation = {
  response: AdminUserRemoveTicketMutation$data;
  variables: AdminUserRemoveTicketMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "ticketId"
  }
],
v1 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "ticketId",
        "variableName": "ticketId"
      }
    ],
    "kind": "ScalarField",
    "name": "adminRemoveTicket",
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "AdminUserRemoveTicketMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "AdminUserRemoveTicketMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "b3caa1f35fe94e9f6905cebe386ce7d3",
    "id": null,
    "metadata": {},
    "name": "AdminUserRemoveTicketMutation",
    "operationKind": "mutation",
    "text": "mutation AdminUserRemoveTicketMutation(\n  $ticketId: UUID!\n) {\n  adminRemoveTicket(ticketId: $ticketId)\n}\n"
  }
};
})();

(node as any).hash = "757329907675efb4c525be9646637087";

export default node;
