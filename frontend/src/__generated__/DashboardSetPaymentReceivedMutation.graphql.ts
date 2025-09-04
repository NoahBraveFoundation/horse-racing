/**
 * @generated SignedSource<<2abf90f2d82a85e7b1970b22a1efac88>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type DashboardSetPaymentReceivedMutation$variables = {
  paymentId: any;
  received: boolean;
};
export type DashboardSetPaymentReceivedMutation$data = {
  readonly setPaymentReceived: {
    readonly id: any | null | undefined;
    readonly paymentReceived: boolean;
  };
};
export type DashboardSetPaymentReceivedMutation = {
  response: DashboardSetPaymentReceivedMutation$data;
  variables: DashboardSetPaymentReceivedMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "paymentId"
  },
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "received"
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
      },
      {
        "kind": "Variable",
        "name": "received",
        "variableName": "received"
      }
    ],
    "concreteType": "Payment",
    "kind": "LinkedField",
    "name": "setPaymentReceived",
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
    "name": "DashboardSetPaymentReceivedMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "DashboardSetPaymentReceivedMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "a1ed5437c0cd5d5361e97e660b9dee84",
    "id": null,
    "metadata": {},
    "name": "DashboardSetPaymentReceivedMutation",
    "operationKind": "mutation",
    "text": "mutation DashboardSetPaymentReceivedMutation(\n  $paymentId: UUID!\n  $received: Boolean!\n) {\n  setPaymentReceived(paymentId: $paymentId, received: $received) {\n    id\n    paymentReceived\n  }\n}\n"
  }
};
})();

(node as any).hash = "e24b839ee4b6afafb65dab389c83c162";

export default node;
