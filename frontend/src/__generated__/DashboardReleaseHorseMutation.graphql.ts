/**
 * @generated SignedSource<<0d372b7dae970d446400993f3c8ca8a6>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type DashboardReleaseHorseMutation$variables = {
  horseId: any;
};
export type DashboardReleaseHorseMutation$data = {
  readonly releaseHorse: boolean;
};
export type DashboardReleaseHorseMutation = {
  response: DashboardReleaseHorseMutation$data;
  variables: DashboardReleaseHorseMutation$variables;
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
    "name": "releaseHorse",
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "DashboardReleaseHorseMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "DashboardReleaseHorseMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "ef13170665f3634f8a1cbee25902d1f7",
    "id": null,
    "metadata": {},
    "name": "DashboardReleaseHorseMutation",
    "operationKind": "mutation",
    "text": "mutation DashboardReleaseHorseMutation(\n  $horseId: UUID!\n) {\n  releaseHorse(horseId: $horseId)\n}\n"
  }
};
})();

(node as any).hash = "c55f63d11d3f635a36bcb38823a59a2d";

export default node;
