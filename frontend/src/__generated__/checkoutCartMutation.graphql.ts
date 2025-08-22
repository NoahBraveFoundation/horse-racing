/**
 * @generated SignedSource<<401ea819426bd46d2aa9ccc480c418e9>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type checkoutCartMutation$variables = Record<PropertyKey, never>;
export type checkoutCartMutation$data = {
  readonly checkoutCart: {
    readonly id: any | null | undefined;
    readonly paymentReceived: boolean;
    readonly totalCents: number;
  };
};
export type checkoutCartMutation = {
  response: checkoutCartMutation$data;
  variables: checkoutCartMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "alias": null,
    "args": null,
    "concreteType": "Payment",
    "kind": "LinkedField",
    "name": "checkoutCart",
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
        "name": "totalCents",
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
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "checkoutCartMutation",
    "selections": (v0/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "checkoutCartMutation",
    "selections": (v0/*: any*/)
  },
  "params": {
    "cacheID": "9b513ebf4062ab7604660fd22977d445",
    "id": null,
    "metadata": {},
    "name": "checkoutCartMutation",
    "operationKind": "mutation",
    "text": "mutation checkoutCartMutation {\n  checkoutCart {\n    id\n    totalCents\n    paymentReceived\n  }\n}\n"
  }
};
})();

(node as any).hash = "54610ccc734de068b8a59ab021ded87c";

export default node;
