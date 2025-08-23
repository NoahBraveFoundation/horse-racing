/**
 * @generated SignedSource<<112e84be0c69078c266dcefdf4cd00ce>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type DashboardMarkPaidMutation$variables = {
  paymentId: any;
};
export type DashboardMarkPaidMutation$data = {
  readonly markPaymentReceived: {
    readonly id: any | null | undefined;
    readonly paymentReceived: boolean;
  };
};
export type DashboardMarkPaidMutation = {
  response: DashboardMarkPaidMutation$data;
  variables: DashboardMarkPaidMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "paymentId"
  }
],
v1 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "paymentId",
        "variableName": "paymentId"
      }
    ],
    "concreteType": "Payment",
    "kind": "LinkedField",
    "name": "markPaymentReceived",
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
        "name": "paymentReceived",
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
    "name": "DashboardMarkPaidMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "DashboardMarkPaidMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "229467fb4c104acfeffa94d5bf95be2d",
    "id": null,
    "metadata": {},
    "name": "DashboardMarkPaidMutation",
    "operationKind": "mutation",
    "text": "mutation DashboardMarkPaidMutation(\n  $paymentId: UUID!\n) {\n  markPaymentReceived(paymentId: $paymentId) {\n    id\n    paymentReceived\n  }\n}\n"
  }
};
})();

(node as any).hash = "c74fc6c1cb65a5c30f71e9dd09980067";

export default node;
