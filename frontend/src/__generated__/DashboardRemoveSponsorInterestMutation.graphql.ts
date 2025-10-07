/**
 * @generated SignedSource<<4efad1f4a8b7d9e0a2f629c3dc0329a3>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type DashboardRemoveSponsorInterestMutation$variables = {
  sponsorInterestId: any;
};
export type DashboardRemoveSponsorInterestMutation$data = {
  readonly adminRemoveSponsorInterest: boolean;
};
export type DashboardRemoveSponsorInterestMutation = {
  response: DashboardRemoveSponsorInterestMutation$data;
  variables: DashboardRemoveSponsorInterestMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "sponsorInterestId"
  }
],
v1 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "sponsorInterestId",
        "variableName": "sponsorInterestId"
      }
    ],
    "kind": "ScalarField",
    "name": "adminRemoveSponsorInterest",
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "DashboardRemoveSponsorInterestMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "DashboardRemoveSponsorInterestMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "8d57ce475fe3c32d07c2e0fc35a4c343",
    "id": null,
    "metadata": {},
    "name": "DashboardRemoveSponsorInterestMutation",
    "operationKind": "mutation",
    "text": "mutation DashboardRemoveSponsorInterestMutation(\n  $sponsorInterestId: UUID!\n) {\n  adminRemoveSponsorInterest(sponsorInterestId: $sponsorInterestId)\n}\n"
  }
};
})();

(node as any).hash = "f8d7df1adf7e4e516823823c68c8b09d";

export default node;
