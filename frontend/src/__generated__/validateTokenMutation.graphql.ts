/**
 * @generated SignedSource<<05a6d6fe3bdae674ec060007b81531e8>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type validateTokenMutation$variables = {
  token: string;
};
export type validateTokenMutation$data = {
  readonly validateToken: {
    readonly message: string;
    readonly success: boolean;
    readonly user: {
      readonly email: string;
      readonly firstName: string;
      readonly id: any | null | undefined;
      readonly isAdmin: boolean;
      readonly lastName: string;
    } | null | undefined;
  };
};
export type validateTokenMutation = {
  response: validateTokenMutation$data;
  variables: validateTokenMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "token"
  }
],
v1 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "token",
        "variableName": "token"
      }
    ],
    "concreteType": "ValidateTokenPayload",
    "kind": "LinkedField",
    "name": "validateToken",
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
      },
      {
        "alias": null,
        "args": null,
        "concreteType": "User",
        "kind": "LinkedField",
        "name": "user",
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
            "name": "email",
            "storageKey": null
          },
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
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "isAdmin",
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
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "validateTokenMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "validateTokenMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "14ef4a787da8040e04218e1d9a1ca14b",
    "id": null,
    "metadata": {},
    "name": "validateTokenMutation",
    "operationKind": "mutation",
    "text": "mutation validateTokenMutation(\n  $token: String!\n) {\n  validateToken(token: $token) {\n    success\n    message\n    user {\n      id\n      email\n      firstName\n      lastName\n      isAdmin\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "64ea3073c2929c3a1b08b53a98a8ee2b";

export default node;
