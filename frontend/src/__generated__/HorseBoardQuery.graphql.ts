/**
 * @generated SignedSource<<9ec588330d14364ce191361ee0878670>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type HorseBoardQuery$variables = Record<PropertyKey, never>;
export type HorseBoardQuery$data = {
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
  }>;
};
export type HorseBoardQuery = {
  response: HorseBoardQuery$data;
  variables: HorseBoardQuery$variables;
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
  {
    "alias": null,
    "args": null,
    "concreteType": "Round",
    "kind": "LinkedField",
    "name": "rounds",
    "plural": true,
    "selections": [
      (v0/*: any*/),
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "name",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "startAt",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "endAt",
        "storageKey": null
      },
      {
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
    "name": "HorseBoardQuery",
    "selections": (v1/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "HorseBoardQuery",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "c7f9da282f5c7a67c18f120c235f215f",
    "id": null,
    "metadata": {},
    "name": "HorseBoardQuery",
    "operationKind": "query",
    "text": "query HorseBoardQuery {\n  rounds {\n    id\n    name\n    startAt\n    endAt\n    lanes {\n      id\n      number\n      horse {\n        id\n        horseName\n        ownershipLabel\n        owner {\n          firstName\n          lastName\n        }\n      }\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "8ed1c805e6a6b27c1c8b512846c8b1a2";

export default node;
