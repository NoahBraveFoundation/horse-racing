/**
 * @generated SignedSource<<49abcbf08dcfdfa1ff1ae6ecfa78d975>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type SummaryStepQuery$variables = Record<PropertyKey, never>;
export type SummaryStepQuery$data = {
  readonly myCart: {
    readonly cost: {
      readonly horseCents: number;
      readonly sponsorCents: number;
      readonly ticketsCents: number;
      readonly totalCents: number;
    };
    readonly giftBasketInterests: ReadonlyArray<{
      readonly description: string;
      readonly id: any | null | undefined;
    }>;
    readonly horses: ReadonlyArray<{
      readonly costCents: number;
      readonly horseName: string;
      readonly id: any | null | undefined;
      readonly ownershipLabel: string;
    }>;
    readonly id: any | null | undefined;
    readonly sponsorInterests: ReadonlyArray<{
      readonly companyName: string;
      readonly costCents: number;
      readonly id: any | null | undefined;
    }>;
    readonly tickets: ReadonlyArray<{
      readonly attendeeFirst: string;
      readonly attendeeLast: string;
      readonly costCents: number;
      readonly id: any | null | undefined;
    }>;
  };
};
export type SummaryStepQuery = {
  response: SummaryStepQuery$data;
  variables: SummaryStepQuery$variables;
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
  "name": "costCents",
  "storageKey": null
},
v2 = [
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
        "concreteType": "CartCost",
        "kind": "LinkedField",
        "name": "cost",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "ticketsCents",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "horseCents",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "sponsorCents",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "totalCents",
            "storageKey": null
          }
        ],
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "concreteType": "Ticket",
        "kind": "LinkedField",
        "name": "tickets",
        "plural": true,
        "selections": [
          (v0/*: any*/),
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "attendeeFirst",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "attendeeLast",
            "storageKey": null
          },
          (v1/*: any*/)
        ],
        "storageKey": null
      },
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
          (v1/*: any*/)
        ],
        "storageKey": null
      },
      {
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
          (v1/*: any*/)
        ],
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "concreteType": "GiftBasketInterest",
        "kind": "LinkedField",
        "name": "giftBasketInterests",
        "plural": true,
        "selections": [
          (v0/*: any*/),
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "description",
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
    "name": "SummaryStepQuery",
    "selections": (v2/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "SummaryStepQuery",
    "selections": (v2/*: any*/)
  },
  "params": {
    "cacheID": "324b6d0a64d93ff95138212dafb8212c",
    "id": null,
    "metadata": {},
    "name": "SummaryStepQuery",
    "operationKind": "query",
    "text": "query SummaryStepQuery {\n  myCart {\n    id\n    cost {\n      ticketsCents\n      horseCents\n      sponsorCents\n      totalCents\n    }\n    tickets {\n      id\n      attendeeFirst\n      attendeeLast\n      costCents\n    }\n    horses {\n      id\n      horseName\n      ownershipLabel\n      costCents\n    }\n    sponsorInterests {\n      id\n      companyName\n      costCents\n    }\n    giftBasketInterests {\n      id\n      description\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "175078baffc35ab2d88a59992aa7e555";

export default node;
