/**
 * @generated SignedSource<<0ad0f5aa91b19ef487ef2490f0df6453>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type removeGiftBasketFromCartMutation$variables = {
  giftId: any;
};
export type removeGiftBasketFromCartMutation$data = {
  readonly removeGiftBasketFromCart: boolean;
};
export type removeGiftBasketFromCartMutation = {
  response: removeGiftBasketFromCartMutation$data;
  variables: removeGiftBasketFromCartMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "giftId"
  }
],
v1 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "giftId",
        "variableName": "giftId"
      }
    ],
    "kind": "ScalarField",
    "name": "removeGiftBasketFromCart",
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "removeGiftBasketFromCartMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "removeGiftBasketFromCartMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "f9902f4aea148758026cb97363fc0285",
    "id": null,
    "metadata": {},
    "name": "removeGiftBasketFromCartMutation",
    "operationKind": "mutation",
    "text": "mutation removeGiftBasketFromCartMutation(\n  $giftId: UUID!\n) {\n  removeGiftBasketFromCart(giftId: $giftId)\n}\n"
  }
};
})();

(node as any).hash = "fea02fb927dc2e388961027c3ec517cc";

export default node;
