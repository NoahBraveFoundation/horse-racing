/**
 * @generated SignedSource<<00ecedcd26d4cdd9d4b88c80b8269018>>
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
    "cacheID": "0b0b60bc48ed769746adad9ab08079bf",
    "id": null,
    "metadata": {},
    "name": "DashboardRemoveSponsorInterestMutation",
    "operationKind": "mutation",
    "text": "mutation DashboardRemoveSponsorInterestMutation(\n  $sponsorInterestId: UUID!\n) {\n  adminRemoveSponsorInterest(sponsorInterestId: $sponsorInterestId)\n}\n"
  }
};
})();

(node as any).hash = "27c44174f2196ec0bb24383ecc46788a";

export default node;
