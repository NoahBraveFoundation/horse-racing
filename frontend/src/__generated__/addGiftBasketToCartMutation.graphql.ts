/**
 * @generated SignedSource<<f7fd9dc4da1f734d976ae221f2266b18>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type addGiftBasketToCartMutation$variables = {
  description: string;
};
export type addGiftBasketToCartMutation$data = {
  readonly addGiftBasketToCart: {
    readonly description: string;
    readonly id: any | null | undefined;
  };
};
export type addGiftBasketToCartMutation = {
  response: addGiftBasketToCartMutation$data;
  variables: addGiftBasketToCartMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "description"
  }
],
v1 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "description",
        "variableName": "description"
      }
    ],
    "concreteType": "GiftBasketInterest",
    "kind": "LinkedField",
    "name": "addGiftBasketToCart",
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
        "name": "description",
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
    "name": "addGiftBasketToCartMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "addGiftBasketToCartMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "aed68422b92e9db62d69db6601ff57f6",
    "id": null,
    "metadata": {},
    "name": "addGiftBasketToCartMutation",
    "operationKind": "mutation",
    "text": "mutation addGiftBasketToCartMutation(\n  $description: String!\n) {\n  addGiftBasketToCart(description: $description) {\n    id\n    description\n  }\n}\n"
  }
};
})();

(node as any).hash = "def9cab43d6a3b84e3b5eafa80daaf92";

export default node;
