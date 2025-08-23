/**
 * @generated SignedSource<<bbeff71cea68548414386324b1040d4b>>
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
  readonly me: {
    readonly firstName: string;
    readonly id: any | null | undefined;
    readonly lastName: string;
  };
  readonly myCart: {
    readonly horses: ReadonlyArray<{
      readonly id: any | null | undefined;
    }>;
    readonly id: any | null | undefined;
  } | null | undefined;
  readonly rounds: ReadonlyArray<{
    readonly endAt: any;
    readonly id: any | null | undefined;
    readonly lanes: ReadonlyArray<{
      readonly horse: {
        readonly horseName: string;
        readonly id: any | null | undefined;
        readonly owner: {
          readonly firstName: string;
          readonly id: any | null | undefined;
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
v1 = [
  (v0/*: any*/),
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
v2 = {
  "alias": null,
  "args": null,
  "concreteType": "User",
  "kind": "LinkedField",
  "name": "me",
  "plural": false,
  "selections": (v1/*: any*/),
  "storageKey": null
},
v3 = {
  "alias": null,
  "args": null,
  "concreteType": "Cart",
  "kind": "LinkedField",
  "name": "myCart",
  "plural": false,
  "selections": [
    (v0/*: any*/),
    {
      "alias": null,
      "args": null,
      "concreteType": "Horse",
      "kind": "LinkedField",
      "name": "horses",
      "plural": true,
      "selections": [
        (v0/*: any*/)
      ],
      "storageKey": null
    }
  ],
  "storageKey": null
},
v4 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "name",
  "storageKey": null
},
v5 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "startAt",
  "storageKey": null
},
v6 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "endAt",
  "storageKey": null
},
v7 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "number",
  "storageKey": null
},
v8 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "horseName",
  "storageKey": null
},
v9 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "ownershipLabel",
  "storageKey": null
},
v10 = {
  "alias": null,
  "args": null,
  "concreteType": "User",
  "kind": "LinkedField",
  "name": "owner",
  "plural": false,
  "selections": (v1/*: any*/),
  "storageKey": null
};
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "BoardQuery",
    "selections": [
      (v2/*: any*/),
      (v3/*: any*/),
      {
        "alias": null,
        "args": null,
        "concreteType": "Round",
        "kind": "LinkedField",
        "name": "rounds",
        "plural": true,
        "selections": [
          (v0/*: any*/),
          (v4/*: any*/),
          (v5/*: any*/),
          (v6/*: any*/),
          {
            "alias": null,
            "args": null,
            "concreteType": "Lane",
            "kind": "LinkedField",
            "name": "lanes",
            "plural": true,
            "selections": [
              (v0/*: any*/),
              (v7/*: any*/),
              {
                "alias": null,
                "args": null,
                "concreteType": "Horse",
                "kind": "LinkedField",
                "name": "horse",
                "plural": false,
                "selections": [
                  (v0/*: any*/),
                  (v8/*: any*/),
                  (v9/*: any*/),
                  (v10/*: any*/)
                ],
                "storageKey": null
              }
            ],
            "storageKey": null
          },
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
      (v2/*: any*/),
      (v3/*: any*/),
      {
        "alias": null,
        "args": null,
        "concreteType": "Round",
        "kind": "LinkedField",
        "name": "rounds",
        "plural": true,
        "selections": [
          (v0/*: any*/),
          (v4/*: any*/),
          (v5/*: any*/),
          (v6/*: any*/),
          {
            "alias": null,
            "args": null,
            "concreteType": "Lane",
            "kind": "LinkedField",
            "name": "lanes",
            "plural": true,
            "selections": [
              (v0/*: any*/),
              (v7/*: any*/),
              {
                "alias": null,
                "args": null,
                "concreteType": "Horse",
                "kind": "LinkedField",
                "name": "horse",
                "plural": false,
                "selections": [
                  (v0/*: any*/),
                  (v8/*: any*/),
                  (v9/*: any*/),
                  (v10/*: any*/),
                  {
                    "alias": null,
                    "args": null,
                    "kind": "ScalarField",
                    "name": "state",
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
      }
    ]
  },
  "params": {
    "cacheID": "78d9b75128057fac27e11295704bcd79",
    "id": null,
    "metadata": {},
    "name": "BoardQuery",
    "operationKind": "query",
    "text": "query BoardQuery {\n  me {\n    id\n    firstName\n    lastName\n  }\n  myCart {\n    id\n    horses {\n      id\n    }\n  }\n  rounds {\n    id\n    name\n    startAt\n    endAt\n    lanes {\n      id\n      number\n      horse {\n        id\n        horseName\n        ownershipLabel\n        owner {\n          id\n          firstName\n          lastName\n        }\n      }\n    }\n    ...RoundBoardFragment\n  }\n}\n\nfragment RoundBoardFragment on Round {\n  id\n  name\n  startAt\n  endAt\n  lanes {\n    id\n    number\n    horse {\n      id\n      horseName\n      ownershipLabel\n      owner {\n        id\n        firstName\n        lastName\n      }\n      state\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "bac995fcb19303aca955377fb68e430d";

export default node;
