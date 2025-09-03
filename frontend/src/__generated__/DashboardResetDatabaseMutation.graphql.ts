/**
 * @generated SignedSource<<70532bd5ccb20bb2ea048324b00125fb>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type DashboardResetDatabaseMutation$variables = Record<PropertyKey, never>;
export type DashboardResetDatabaseMutation$data = {
  readonly resetDatabase: boolean;
};
export type DashboardResetDatabaseMutation = {
  response: DashboardResetDatabaseMutation$data;
  variables: DashboardResetDatabaseMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "alias": null,
    "args": null,
    "kind": "ScalarField",
    "name": "resetDatabase",
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "DashboardResetDatabaseMutation",
    "selections": (v0/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "DashboardResetDatabaseMutation",
    "selections": (v0/*: any*/)
  },
  "params": {
    "cacheID": "a3aa1c515d5d5e90e1e6c15648bb5d44",
    "id": null,
    "metadata": {},
    "name": "DashboardResetDatabaseMutation",
    "operationKind": "mutation",
    "text": "mutation DashboardResetDatabaseMutation {\n  resetDatabase\n}\n"
  }
};
})();

(node as any).hash = "1eda6c7be14b68872375cbaac85bc2a3";

export default node;
