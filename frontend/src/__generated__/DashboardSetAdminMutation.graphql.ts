/**
 * @generated SignedSource<<4c895293021634da440410266c869e0c>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type DashboardSetAdminMutation$variables = {
  isAdmin: boolean;
  userId: any;
};
export type DashboardSetAdminMutation$data = {
  readonly setUserAdmin: {
    readonly id: any | null | undefined;
    readonly isAdmin: boolean;
  };
};
export type DashboardSetAdminMutation = {
  response: DashboardSetAdminMutation$data;
  variables: DashboardSetAdminMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "isAdmin"
},
v1 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "userId"
},
v2 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "isAdmin",
        "variableName": "isAdmin"
      },
      {
        "kind": "Variable",
        "name": "userId",
        "variableName": "userId"
      }
    ],
    "concreteType": "User",
    "kind": "LinkedField",
    "name": "setUserAdmin",
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
        "name": "isAdmin",
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
    "name": "DashboardSetAdminMutation",
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
    "name": "DashboardSetAdminMutation",
    "selections": (v2/*: any*/)
  },
  "params": {
    "cacheID": "775e8700dd1cd347a217adce017f533a",
    "id": null,
    "metadata": {},
    "name": "DashboardSetAdminMutation",
    "operationKind": "mutation",
    "text": "mutation DashboardSetAdminMutation(\n  $userId: UUID!\n  $isAdmin: Boolean!\n) {\n  setUserAdmin(userId: $userId, isAdmin: $isAdmin) {\n    id\n    isAdmin\n  }\n}\n"
  }
};
})();

(node as any).hash = "e44514ab14a2cc3b4146b948a7ae486b";

export default node;
