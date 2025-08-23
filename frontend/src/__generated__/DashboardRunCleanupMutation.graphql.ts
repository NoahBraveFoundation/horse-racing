/**
 * @generated SignedSource<<1f31ea4f88d41df2fcb4b23fb54dad7d>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type DashboardRunCleanupMutation$variables = Record<PropertyKey, never>;
export type DashboardRunCleanupMutation$data = {
  readonly runAdminCleanup: boolean;
};
export type DashboardRunCleanupMutation = {
  response: DashboardRunCleanupMutation$data;
  variables: DashboardRunCleanupMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "alias": null,
    "args": null,
    "kind": "ScalarField",
    "name": "runAdminCleanup",
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "DashboardRunCleanupMutation",
    "selections": (v0/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "DashboardRunCleanupMutation",
    "selections": (v0/*: any*/)
  },
  "params": {
    "cacheID": "a6ed3518518345bcfaf7c498a3223e7c",
    "id": null,
    "metadata": {},
    "name": "DashboardRunCleanupMutation",
    "operationKind": "mutation",
    "text": "mutation DashboardRunCleanupMutation {\n  runAdminCleanup\n}\n"
  }
};
})();

(node as any).hash = "025cb71baa3fd7b2a5fa0a359a1e484d";

export default node;
