/**
 * @generated SignedSource<<b20affb2dbf9e1c47118af349f88d801>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type HorseEntryState = "confirmed" | "on_hold" | "pending_payment" | "%future added value";
export type TicketState = "confirmed" | "on_hold" | "pending_payment" | "%future added value";
export type DashboardAdminQuery$variables = Record<PropertyKey, never>;
export type DashboardAdminQuery$data = {
  readonly abandonedCarts: ReadonlyArray<{
    readonly id: any | null | undefined;
    readonly orderNumber: string;
    readonly user: {
      readonly email: string;
      readonly firstName: string;
      readonly id: any | null | undefined;
      readonly lastName: string;
    };
  }>;
  readonly adminStats: {
    readonly giftBasketCount: number;
    readonly sponsorCount: number;
    readonly ticketCount: number;
  };
  readonly allHorses: ReadonlyArray<{
    readonly horseName: string;
    readonly id: any | null | undefined;
    readonly lane: {
      readonly number: number;
    };
    readonly owner: {
      readonly firstName: string;
      readonly lastName: string;
    };
    readonly round: {
      readonly name: string;
    };
    readonly state: HorseEntryState;
  }>;
  readonly allTickets: ReadonlyArray<{
    readonly attendeeFirst: string;
    readonly attendeeLast: string;
    readonly id: any | null | undefined;
    readonly owner: {
      readonly firstName: string;
      readonly lastName: string;
    };
    readonly seatAssignment: string | null | undefined;
    readonly seatingPreference: string | null | undefined;
    readonly state: TicketState;
  }>;
  readonly giftBasketInterests: ReadonlyArray<{
    readonly description: string;
    readonly id: any | null | undefined;
    readonly user: {
      readonly firstName: string;
      readonly lastName: string;
    };
  }>;
  readonly payments: ReadonlyArray<{
    readonly id: any | null | undefined;
    readonly paymentReceived: boolean;
    readonly totalCents: number;
    readonly user: {
      readonly email: string;
      readonly firstName: string;
      readonly id: any | null | undefined;
      readonly lastName: string;
    };
  }>;
  readonly sponsorInterests: ReadonlyArray<{
    readonly companyLogoBase64: string | null | undefined;
    readonly companyName: string;
    readonly id: any | null | undefined;
  }>;
  readonly users: ReadonlyArray<{
    readonly email: string;
    readonly firstName: string;
    readonly id: any | null | undefined;
    readonly isAdmin: boolean;
    readonly lastName: string;
  }>;
};
export type DashboardAdminQuery = {
  response: DashboardAdminQuery$data;
  variables: DashboardAdminQuery$variables;
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
  "name": "firstName",
  "storageKey": null
},
v2 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "lastName",
  "storageKey": null
},
v3 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "email",
  "storageKey": null
},
v4 = {
  "alias": null,
  "args": null,
  "concreteType": "User",
  "kind": "LinkedField",
  "name": "user",
  "plural": false,
  "selections": [
    (v0/*: any*/),
    (v1/*: any*/),
    (v2/*: any*/),
    (v3/*: any*/)
  ],
  "storageKey": null
},
v5 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "state",
  "storageKey": null
},
v6 = [
  (v1/*: any*/),
  (v2/*: any*/)
],
v7 = {
  "alias": null,
  "args": null,
  "concreteType": "User",
  "kind": "LinkedField",
  "name": "owner",
  "plural": false,
  "selections": (v6/*: any*/),
  "storageKey": null
},
v8 = [
  {
    "alias": null,
    "args": null,
    "concreteType": "Payment",
    "kind": "LinkedField",
    "name": "payments",
    "plural": true,
    "selections": [
      (v0/*: any*/),
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "totalCents",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "paymentReceived",
        "storageKey": null
      },
      (v4/*: any*/)
    ],
    "storageKey": null
  },
  {
    "alias": null,
    "args": null,
    "concreteType": "User",
    "kind": "LinkedField",
    "name": "users",
    "plural": true,
    "selections": [
      (v0/*: any*/),
      (v3/*: any*/),
      (v1/*: any*/),
      (v2/*: any*/),
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "isAdmin",
        "storageKey": null
      }
    ],
    "storageKey": null
  },
  {
    "alias": null,
    "args": null,
    "concreteType": "AdminStats",
    "kind": "LinkedField",
    "name": "adminStats",
    "plural": false,
    "selections": [
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "ticketCount",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "sponsorCount",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "giftBasketCount",
        "storageKey": null
      }
    ],
    "storageKey": null
  },
  {
    "alias": null,
    "args": null,
    "concreteType": "Horse",
    "kind": "LinkedField",
    "name": "allHorses",
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
      (v5/*: any*/),
      {
        "alias": null,
        "args": null,
        "concreteType": "Round",
        "kind": "LinkedField",
        "name": "round",
        "plural": false,
        "selections": [
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "name",
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
        "selections": [
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "number",
            "storageKey": null
          }
        ],
        "storageKey": null
      },
      (v7/*: any*/)
    ],
    "storageKey": null
  },
  {
    "alias": null,
    "args": null,
    "concreteType": "Ticket",
    "kind": "LinkedField",
    "name": "allTickets",
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
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "seatingPreference",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "seatAssignment",
        "storageKey": null
      },
      (v5/*: any*/),
      (v7/*: any*/)
    ],
    "storageKey": null
  },
  {
    "alias": null,
    "args": null,
    "concreteType": "Cart",
    "kind": "LinkedField",
    "name": "abandonedCarts",
    "plural": true,
    "selections": [
      (v0/*: any*/),
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "orderNumber",
        "storageKey": null
      },
      (v4/*: any*/)
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
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "companyLogoBase64",
        "storageKey": null
      }
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
      },
      {
        "alias": null,
        "args": null,
        "concreteType": "User",
        "kind": "LinkedField",
        "name": "user",
        "plural": false,
        "selections": (v6/*: any*/),
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
    "name": "DashboardAdminQuery",
    "selections": (v8/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "DashboardAdminQuery",
    "selections": (v8/*: any*/)
  },
  "params": {
    "cacheID": "ab2b9bcda975529b7f9925b73aeeaf37",
    "id": null,
    "metadata": {},
    "name": "DashboardAdminQuery",
    "operationKind": "query",
    "text": "query DashboardAdminQuery {\n  payments {\n    id\n    totalCents\n    paymentReceived\n    user {\n      id\n      firstName\n      lastName\n      email\n    }\n  }\n  users {\n    id\n    email\n    firstName\n    lastName\n    isAdmin\n  }\n  adminStats {\n    ticketCount\n    sponsorCount\n    giftBasketCount\n  }\n  allHorses {\n    id\n    horseName\n    state\n    round {\n      name\n    }\n    lane {\n      number\n    }\n    owner {\n      firstName\n      lastName\n    }\n  }\n  allTickets {\n    id\n    attendeeFirst\n    attendeeLast\n    seatingPreference\n    seatAssignment\n    state\n    owner {\n      firstName\n      lastName\n    }\n  }\n  abandonedCarts {\n    id\n    orderNumber\n    user {\n      id\n      firstName\n      lastName\n      email\n    }\n  }\n  sponsorInterests {\n    id\n    companyName\n    companyLogoBase64\n  }\n  giftBasketInterests {\n    id\n    description\n    user {\n      firstName\n      lastName\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "25bdc21db7e32955082e6852fb57bd97";

export default node;
