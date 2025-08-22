/**
 * @generated SignedSource<<5bdc136a65e3414bd5cee73a0ae371c5>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type HorsesReviewStepQuery$variables = Record<PropertyKey, never>;
export type HorsesReviewStepQuery$data = {
  readonly myCart: {
    readonly horses: ReadonlyArray<{
      readonly horseName: string;
      readonly id: any | null | undefined;
      readonly lane: {
        readonly id: any | null | undefined;
        readonly number: number;
        readonly round: {
          readonly endAt: any;
          readonly id: any | null | undefined;
          readonly name: string;
          readonly startAt: any;
        };
      };
      readonly ownershipLabel: string;
    }>;
    readonly id: any | null | undefined;
  };
};
export type HorsesReviewStepQuery = {
  response: HorsesReviewStepQuery$data;
  variables: HorsesReviewStepQuery$variables;
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
            "concreteType": "Lane",
            "kind": "LinkedField",
            "name": "lane",
            "plural": false,
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
                "concreteType": "Round",
                "kind": "LinkedField",
                "name": "round",
                "plural": false,
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
    "name": "HorsesReviewStepQuery",
    "selections": (v1/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "HorsesReviewStepQuery",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "52e497a04f753e6e42b14e5cdd77c43e",
    "id": null,
    "metadata": {},
    "name": "HorsesReviewStepQuery",
    "operationKind": "query",
    "text": "query HorsesReviewStepQuery {\n  myCart {\n    id\n    horses {\n      id\n      horseName\n      ownershipLabel\n      lane {\n        id\n        number\n        round {\n          id\n          name\n          startAt\n          endAt\n        }\n      }\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "9ba25eb4fa20b854eb5b3436450cc1a2";

export default node;
