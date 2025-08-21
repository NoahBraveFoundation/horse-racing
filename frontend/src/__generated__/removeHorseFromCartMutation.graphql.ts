/**
 * @generated SignedSource<<ac4190b393cdf526bef8045ad775d5be>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type removeHorseFromCartMutation$variables = {
  horseId: any;
};
export type removeHorseFromCartMutation$data = {
  readonly removeHorseFromCart: boolean;
};
export type removeHorseFromCartMutation = {
  response: removeHorseFromCartMutation$data;
  variables: removeHorseFromCartMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "horseId"
  }
],
v1 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "horseId",
        "variableName": "horseId"
      }
    ],
    "kind": "ScalarField",
    "name": "removeHorseFromCart",
    "storageKey": null
  }
];
return {
  "fragment": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "removeHorseFromCartMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "removeHorseFromCartMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "a88b5b9ade30acd239fd171f3a83f182",
    "id": null,
    "metadata": {},
    "name": "removeHorseFromCartMutation",
    "operationKind": "mutation",
    "text": "mutation removeHorseFromCartMutation(\n  $horseId: UUID!\n) {\n  removeHorseFromCart(horseId: $horseId)\n}\n"
  }
};
})();

(node as any).hash = "101253b53cbc17cb90d23b7a561b2da9";

export default node;
