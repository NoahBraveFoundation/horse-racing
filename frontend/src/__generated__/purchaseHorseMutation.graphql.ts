/**
 * @generated SignedSource<<06e346ec06efa627d513f9ebc2cfa80d>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type purchaseHorseMutation$variables = {
  horseName: string;
  laneId: any;
  ownershipLabel: string;
  roundId: any;
};
export type purchaseHorseMutation$data = {
  readonly purchaseHorse: {
    readonly horseName: string;
    readonly id: any | null | undefined;
    readonly lane: {
      readonly id: any | null | undefined;
    };
    readonly owner: {
      readonly firstName: string;
      readonly id: any | null | undefined;
      readonly lastName: string;
    };
    readonly ownershipLabel: string;
    readonly round: {
      readonly id: any | null | undefined;
    };
  };
};
export type purchaseHorseMutation = {
  response: purchaseHorseMutation$data;
  variables: purchaseHorseMutation$variables;
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
  (v4/*: any*/)
],
v6 = [
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
    "name": "purchaseHorse",
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
          (v4/*: any*/),
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "firstName",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "lastName",
            "storageKey": null
          }
        ],
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "concreteType": "Lane",
        "kind": "LinkedField",
        "name": "lane",
        "plural": false,
        "selections": (v5/*: any*/),
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "concreteType": "Round",
        "kind": "LinkedField",
        "name": "round",
        "plural": false,
        "selections": (v5/*: any*/),
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
    "name": "purchaseHorseMutation",
    "selections": (v6/*: any*/),
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
    "name": "purchaseHorseMutation",
    "selections": (v6/*: any*/)
  },
  "params": {
    "cacheID": "54fe7007009e419126f5608c5551d199",
    "id": null,
    "metadata": {},
    "name": "purchaseHorseMutation",
    "operationKind": "mutation",
    "text": "mutation purchaseHorseMutation(\n  $roundId: UUID!\n  $laneId: UUID!\n  $horseName: String!\n  $ownershipLabel: String!\n) {\n  purchaseHorse(roundId: $roundId, laneId: $laneId, horseName: $horseName, ownershipLabel: $ownershipLabel) {\n    id\n    horseName\n    ownershipLabel\n    owner {\n      id\n      firstName\n      lastName\n    }\n    lane {\n      id\n    }\n    round {\n      id\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "bf18e5b1e61492efc1bf8bb7b371770b";

export default node;
