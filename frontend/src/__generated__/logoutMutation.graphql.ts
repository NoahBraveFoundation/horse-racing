/**
 * @generated SignedSource<<8a285a73b4cc49dd1dad97e8dd3d303e>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type logoutMutation$variables = Record<PropertyKey, never>;
export type logoutMutation$data = {
  readonly logout: {
    readonly message: string;
    readonly success: boolean;
  };
};
export type logoutMutation = {
  response: logoutMutation$data;
  variables: logoutMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "alias": null,
    "args": null,
    "concreteType": "LogoutPayload",
    "kind": "LinkedField",
    "name": "logout",
    "plural": false,
    "selections": [
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "success",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "message",
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
    "name": "logoutMutation",
    "selections": (v0/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "logoutMutation",
    "selections": (v0/*: any*/)
  },
  "params": {
    "cacheID": "70f9c29b0fe252066f5c46d3e39df708",
    "id": null,
    "metadata": {},
    "name": "logoutMutation",
    "operationKind": "mutation",
    "text": "mutation logoutMutation {\n  logout {\n    success\n    message\n  }\n}\n"
  }
};
})();

(node as any).hash = "78a64bfa9ee932cda967f07557def042";

export default node;
