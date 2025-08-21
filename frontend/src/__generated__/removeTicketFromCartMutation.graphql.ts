/**
 * @generated SignedSource<<4555041d8488e8bf47317f69e9107420>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type removeTicketFromCartMutation$variables = {
  ticketId: any;
};
export type removeTicketFromCartMutation$data = {
  readonly removeTicketFromCart: boolean;
};
export type removeTicketFromCartMutation = {
  response: removeTicketFromCartMutation$data;
  variables: removeTicketFromCartMutation$variables;
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
    "name": "removeTicketFromCart",
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "removeTicketFromCartMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "removeTicketFromCartMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "4c96fb22ed0e562e5a1f7ba64557d224",
    "id": null,
    "metadata": {},
    "name": "removeTicketFromCartMutation",
    "operationKind": "mutation",
    "text": "mutation removeTicketFromCartMutation(\n  $ticketId: UUID!\n) {\n  removeTicketFromCart(ticketId: $ticketId)\n}\n"
  }
};
})();

(node as any).hash = "7a354c305faace88be5051e18893857d";

export default node;
