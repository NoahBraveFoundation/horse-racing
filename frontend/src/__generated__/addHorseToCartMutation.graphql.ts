/**
 * @generated SignedSource<<7d8cebe0f79c5228d464e479b9fc4137>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type addHorseToCartMutation$variables = {
  horseName: string;
  laneId: any;
  ownershipLabel: string;
  roundId: any;
};
export type addHorseToCartMutation$data = {
  readonly addHorseToCart: {
    readonly horseName: string;
    readonly id: any | null | undefined;
    readonly owner: {
      readonly id: any | null | undefined;
    };
    readonly ownershipLabel: string;
  };
};
export type addHorseToCartMutation = {
  response: addHorseToCartMutation$data;
  variables: addHorseToCartMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "horseName"
},
v1 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "laneId"
},
v2 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "ownershipLabel"
},
v3 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "roundId"
},
v4 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
},
v5 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "horseName",
        "variableName": "horseName"
      },
      {
        "kind": "Variable",
        "name": "laneId",
        "variableName": "laneId"
      },
      {
        "kind": "Variable",
        "name": "ownershipLabel",
        "variableName": "ownershipLabel"
      },
      {
        "kind": "Variable",
        "name": "roundId",
        "variableName": "roundId"
      }
    ],
    "concreteType": "Horse",
    "kind": "LinkedField",
    "name": "addHorseToCart",
    "plural": false,
    "selections": [
      (v4/*: any*/),
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "horseName",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "ownershipLabel",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "concreteType": "User",
        "kind": "LinkedField",
        "name": "owner",
        "plural": false,
        "selections": [
          (v4/*: any*/)
        ],
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
      (v1/*: any*/),
      (v2/*: any*/),
      (v3/*: any*/)
    ],
    "kind": "Fragment",
    "metadata": null,
    "name": "addHorseToCartMutation",
    "selections": (v5/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [
      (v3/*: any*/),
      (v1/*: any*/),
      (v0/*: any*/),
      (v2/*: any*/)
    ],
    "kind": "Operation",
    "name": "addHorseToCartMutation",
    "selections": (v5/*: any*/)
  },
  "params": {
    "cacheID": "a171759150d68a25fb150806b00880cd",
    "id": null,
    "metadata": {},
    "name": "addHorseToCartMutation",
    "operationKind": "mutation",
    "text": "mutation addHorseToCartMutation(\n  $roundId: UUID!\n  $laneId: UUID!\n  $horseName: String!\n  $ownershipLabel: String!\n) {\n  addHorseToCart(roundId: $roundId, laneId: $laneId, horseName: $horseName, ownershipLabel: $ownershipLabel) {\n    id\n    horseName\n    ownershipLabel\n    owner {\n      id\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "d0e812a39710a04ee317c6132336eec8";

export default node;
