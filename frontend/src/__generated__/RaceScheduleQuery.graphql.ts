/**
 * @generated SignedSource<<caa130ecc18d97e04a14b0855522248c>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
import { FragmentRefs } from "relay-runtime";
export type RaceScheduleQuery$variables = Record<PropertyKey, never>;
export type RaceScheduleQuery$data = {
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
  readonly sponsorInterests: ReadonlyArray<{
    readonly companyLogoBase64: string | null | undefined;
    readonly companyName: string;
    readonly costCents: number;
    readonly id: any | null | undefined;
  }>;
};
export type RaceScheduleQuery = {
  response: RaceScheduleQuery$data;
  variables: RaceScheduleQuery$variables;
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
  "kind": "ScalarField",
  "name": "number",
  "storageKey": null
},
v5 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "horseName",
  "storageKey": null
},
v6 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "ownershipLabel",
  "storageKey": null
},
v7 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "firstName",
  "storageKey": null
},
v8 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "lastName",
  "storageKey": null
},
v9 = {
  "alias": null,
  "args": null,
  "concreteType": "SponsorInterest",
  "kind": "LinkedField",
  "name": "sponsorInterests",
  "plural": true,
  "selections": [
    (v0/*: any*/),
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "companyName",
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "companyLogoBase64",
      "storageKey": null
    },
    {
      "alias": null,
      "args": null,
      "kind": "ScalarField",
      "name": "costCents",
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
    "name": "RaceScheduleQuery",
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
          {
            "alias": null,
            "args": null,
            "concreteType": "Lane",
            "kind": "LinkedField",
            "name": "lanes",
            "plural": true,
            "selections": [
              (v0/*: any*/),
              (v4/*: any*/),
              {
                "alias": null,
                "args": null,
                "concreteType": "Horse",
                "kind": "LinkedField",
                "name": "horse",
                "plural": false,
                "selections": [
                  (v0/*: any*/),
                  (v5/*: any*/),
                  (v6/*: any*/),
                  {
                    "alias": null,
                    "args": null,
                    "concreteType": "User",
                    "kind": "LinkedField",
                    "name": "owner",
                    "plural": false,
                    "selections": [
                      (v0/*: any*/),
                      (v7/*: any*/),
                      (v8/*: any*/)
                    ],
                    "storageKey": null
                  }
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
      },
      (v9/*: any*/)
    ],
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "RaceScheduleQuery",
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
          {
            "alias": null,
            "args": null,
            "concreteType": "Lane",
            "kind": "LinkedField",
            "name": "lanes",
            "plural": true,
            "selections": [
              (v0/*: any*/),
              (v4/*: any*/),
              {
                "alias": null,
                "args": null,
                "concreteType": "Horse",
                "kind": "LinkedField",
                "name": "horse",
                "plural": false,
                "selections": [
                  (v0/*: any*/),
                  (v5/*: any*/),
                  (v6/*: any*/),
                  {
                    "alias": null,
                    "args": null,
                    "concreteType": "User",
                    "kind": "LinkedField",
                    "name": "owner",
                    "plural": false,
                    "selections": [
                      (v0/*: any*/),
                      (v7/*: any*/),
                      (v8/*: any*/),
                      {
                        "alias": null,
                        "args": null,
                        "kind": "ScalarField",
                        "name": "email",
                        "storageKey": null
                      }
                    ],
                    "storageKey": null
                  },
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
      },
      (v9/*: any*/)
    ]
  },
  "params": {
    "cacheID": "15f453140ce4fdad697f160c490e5076",
    "id": null,
    "metadata": {},
    "name": "RaceScheduleQuery",
    "operationKind": "query",
    "text": "query RaceScheduleQuery {\n  rounds {\n    id\n    name\n    startAt\n    endAt\n    lanes {\n      id\n      number\n      horse {\n        id\n        horseName\n        ownershipLabel\n        owner {\n          id\n          firstName\n          lastName\n        }\n      }\n    }\n    ...RoundBoardFragment\n  }\n  sponsorInterests {\n    id\n    companyName\n    companyLogoBase64\n    costCents\n  }\n}\n\nfragment RoundBoardFragment on Round {\n  id\n  name\n  startAt\n  endAt\n  lanes {\n    id\n    number\n    horse {\n      id\n      horseName\n      ownershipLabel\n      owner {\n        id\n        firstName\n        lastName\n        email\n      }\n      state\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "3f44c35f13a49027cca22e048c20624c";

export default node;
