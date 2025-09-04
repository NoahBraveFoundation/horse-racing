/**
 * @generated SignedSource<<bfe5e04645c1f3fc79c2d8cdf365f0ae>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type AdminUserRemoveHorseMutation$variables = {
  horseId: any;
};
export type AdminUserRemoveHorseMutation$data = {
  readonly adminRemoveHorse: boolean;
};
export type AdminUserRemoveHorseMutation = {
  response: AdminUserRemoveHorseMutation$data;
  variables: AdminUserRemoveHorseMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "horseId"
  }
],
v1 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "horseId",
        "variableName": "horseId"
      }
    ],
    "kind": "ScalarField",
    "name": "adminRemoveHorse",
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "AdminUserRemoveHorseMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "AdminUserRemoveHorseMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "a35a5c3d523acd8ef0a201ac2decb123",
    "id": null,
    "metadata": {},
    "name": "AdminUserRemoveHorseMutation",
    "operationKind": "mutation",
    "text": "mutation AdminUserRemoveHorseMutation(\n  $horseId: UUID!\n) {\n  adminRemoveHorse(horseId: $horseId)\n}\n"
  }
};
})();

(node as any).hash = "842e89f5dc542ec67d8904b60c0836d0";

export default node;
