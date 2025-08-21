/**
 * @generated SignedSource<<61b21e5ed6658bcddfaed8b69613112d>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
import { FragmentRefs } from "relay-runtime";
export type BoardQuery$variables = Record<PropertyKey, never>;
export type BoardQuery$data = {
  readonly rounds: ReadonlyArray<{
    readonly endAt: any;
    readonly id: any | null | undefined;
    readonly lanes: ReadonlyArray<{
      readonly horse: {
        readonly horseName: string;
        readonly id: any | null | undefined;
        readonly owner: {
          readonly firstName: string;
          readonly lastName: string;
        };
        readonly ownershipLabel: string;
      } | null | undefined;
      readonly id: any | null | undefined;
      readonly number: number;
    }>;
    readonly name: string;
    readonly startAt: any;
    readonly " $fragmentSpreads": FragmentRefs<"RoundBoardFragment">;
  }>;
};
export type BoardQuery = {
  response: BoardQuery$data;
  variables: BoardQuery$variables;
};

const node: ConcreteRequest = (function(){
var v0 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
},
v1 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "name",
  "storageKey": null
},
v2 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "startAt",
  "storageKey": null
},
v3 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "endAt",
  "storageKey": null
},
v4 = {
  "alias": null,
  "args": null,
  "concreteType": "Lane",
  "kind": "LinkedField",
  "name": "lanes",
  "plural": true,
  "selections": [
    (v0/*: any*/),
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "number",
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "concreteType": "Horse",
      "kind": "LinkedField",
      "name": "horse",
      "plural": false,
      "selections": [
        (v0/*: any*/),
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
        }
      ],
      "storageKey": null
    }
  ],
  "storageKey": null
};
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "BoardQuery",
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "Round",
        "kind": "LinkedField",
        "name": "rounds",
        "plural": true,
        "selections": [
          (v0/*: any*/),
          (v1/*: any*/),
          (v2/*: any*/),
          (v3/*: any*/),
          (v4/*: any*/),
          {
            "args": null,
            "kind": "FragmentSpread",
            "name": "RoundBoardFragment"
          }
        ],
        "storageKey": null
      }
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "BoardQuery",
    "selections": [
      {
        "alias": null,
        "args": null,
        "concreteType": "Round",
        "kind": "LinkedField",
        "name": "rounds",
        "plural": true,
        "selections": [
          (v0/*: any*/),
          (v1/*: any*/),
          (v2/*: any*/),
          (v3/*: any*/),
          (v4/*: any*/)
        ],
        "storageKey": null
      }
    ]
  },
  "params": {
    "cacheID": "5ef27905eaa791a19412cbb815b6763a",
    "id": null,
    "metadata": {},
    "name": "BoardQuery",
    "operationKind": "query",
    "text": "query BoardQuery {\n  rounds {\n    id\n    name\n    startAt\n    endAt\n    lanes {\n      id\n      number\n      horse {\n        id\n        horseName\n        ownershipLabel\n        owner {\n          firstName\n          lastName\n        }\n      }\n    }\n    ...RoundBoardFragment\n  }\n}\n\nfragment RoundBoardFragment on Round {\n  id\n  name\n  startAt\n  endAt\n  lanes {\n    id\n    number\n    horse {\n      id\n      horseName\n      ownershipLabel\n      owner {\n        firstName\n        lastName\n      }\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "0a4f61b1c2307dc42a2aa868b8a77568";

export default node;
