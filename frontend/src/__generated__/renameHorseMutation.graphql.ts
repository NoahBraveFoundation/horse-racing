/**
 * @generated SignedSource<<3d56b1fc0fa71c6e22f116d52275e638>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type renameHorseMutation$variables = {
  horseId: any;
  horseName: string;
  ownershipLabel: string;
};
export type renameHorseMutation$data = {
  readonly renameHorse: {
    readonly horseName: string;
    readonly id: any | null | undefined;
    readonly ownershipLabel: string;
  };
};
export type renameHorseMutation = {
  response: renameHorseMutation$data;
  variables: renameHorseMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "horseId"
  },
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "horseName"
  },
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "ownershipLabel"
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
      },
      {
        "kind": "Variable",
        "name": "horseName",
        "variableName": "horseName"
      },
      {
        "kind": "Variable",
        "name": "ownershipLabel",
        "variableName": "ownershipLabel"
      }
    ],
    "concreteType": "Horse",
    "kind": "LinkedField",
    "name": "renameHorse",
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
        "name": "horseName",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "ownershipLabel",
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
    "name": "renameHorseMutation",
    "selections": (v1/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "renameHorseMutation",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "42f401f14cf2068bceee0f3c88f28380",
    "id": null,
    "metadata": {},
    "name": "renameHorseMutation",
    "operationKind": "mutation",
    "text": "mutation renameHorseMutation(\n  $horseId: UUID!\n  $horseName: String!\n  $ownershipLabel: String!\n) {\n  renameHorse(horseId: $horseId, horseName: $horseName, ownershipLabel: $ownershipLabel) {\n    id\n    horseName\n    ownershipLabel\n  }\n}\n"
  }
};
})();

(node as any).hash = "d67adf12e7beb0662870afee8ac8f166";

export default node;
