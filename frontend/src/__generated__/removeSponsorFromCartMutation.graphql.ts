/**
 * @generated SignedSource<<8612137cde732335a43551f6ec47654e>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type removeSponsorFromCartMutation$variables = {
  sponsorId: any;
};
export type removeSponsorFromCartMutation$data = {
  readonly removeSponsorFromCart: boolean;
};
export type removeSponsorFromCartMutation = {
  response: removeSponsorFromCartMutation$data;
  variables: removeSponsorFromCartMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "sponsorId"
  }
],
v1 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "sponsorId",
        "variableName": "sponsorId"
      }
    ],
    "kind": "ScalarField",
    "name": "removeSponsorFromCart",
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "removeSponsorFromCartMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "removeSponsorFromCartMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "05a252e72bb4a700f911e97a3e9e58fb",
    "id": null,
    "metadata": {},
    "name": "removeSponsorFromCartMutation",
    "operationKind": "mutation",
    "text": "mutation removeSponsorFromCartMutation(\n  $sponsorId: UUID!\n) {\n  removeSponsorFromCart(sponsorId: $sponsorId)\n}\n"
  }
};
})();

(node as any).hash = "16324d553cded4f3d132e49a9eef78ee";

export default node;
