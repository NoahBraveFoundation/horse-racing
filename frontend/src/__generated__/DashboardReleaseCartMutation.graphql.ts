/**
 * @generated SignedSource<<9ad5de6a555ab1dd9b3dad9b68736565>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type CartStatus = "abandoned" | "checkedOut" | "open" | "%future added value";
export type DashboardReleaseCartMutation$variables = {
  cartId: any;
};
export type DashboardReleaseCartMutation$data = {
  readonly releaseCart: {
    readonly id: any | null | undefined;
    readonly status: CartStatus;
  };
};
export type DashboardReleaseCartMutation = {
  response: DashboardReleaseCartMutation$data;
  variables: DashboardReleaseCartMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "cartId"
  }
],
v1 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "cartId",
        "variableName": "cartId"
      }
    ],
    "concreteType": "Cart",
    "kind": "LinkedField",
    "name": "releaseCart",
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
        "name": "status",
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
    "name": "DashboardReleaseCartMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "DashboardReleaseCartMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "dec58110c0bae592a8c9f0c308fc1b87",
    "id": null,
    "metadata": {},
    "name": "DashboardReleaseCartMutation",
    "operationKind": "mutation",
    "text": "mutation DashboardReleaseCartMutation(\n  $cartId: UUID!\n) {\n  releaseCart(cartId: $cartId) {\n    id\n    status\n  }\n}\n"
  }
};
})();

(node as any).hash = "d24f301096f2215b2d68eba557df0260";

export default node;
