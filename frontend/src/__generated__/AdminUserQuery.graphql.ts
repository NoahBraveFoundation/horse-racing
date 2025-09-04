/**
 * @generated SignedSource<<cee2d86256ab7bc62b14fdfd31401a4f>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type CartStatus = "abandoned" | "checkedOut" | "open" | "%future added value";
export type AdminUserQuery$variables = {
  userId: any;
};
export type AdminUserQuery$data = {
  readonly user: {
    readonly carts: ReadonlyArray<{
      readonly cost: {
        readonly horseCents: number;
        readonly sponsorCents: number;
        readonly ticketsCents: number;
        readonly totalCents: number;
      };
      readonly horses: ReadonlyArray<{
        readonly horseName: string;
        readonly id: any | null | undefined;
        readonly ownershipLabel: string;
      }>;
      readonly id: any | null | undefined;
      readonly orderNumber: string;
      readonly status: CartStatus;
      readonly tickets: ReadonlyArray<{
        readonly attendeeFirst: string;
        readonly attendeeLast: string;
        readonly id: any | null | undefined;
      }>;
    }>;
    readonly email: string;
    readonly firstName: string;
    readonly id: any | null | undefined;
    readonly lastName: string;
    readonly payments: ReadonlyArray<{
      readonly id: any | null | undefined;
      readonly paymentReceived: boolean;
      readonly totalCents: number;
    }>;
  };
};
export type AdminUserQuery = {
  response: AdminUserQuery$data;
  variables: AdminUserQuery$variables;
};

const node: ConcreteRequest = (function(){
var v0 = [
  {
    "defaultValue": null,
    "kind": "LocalArgument",
    "name": "userId"
  }
],
v1 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
},
v2 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "totalCents",
  "storageKey": null
},
v3 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "userId",
        "variableName": "userId"
      }
    ],
    "concreteType": "User",
    "kind": "LinkedField",
    "name": "user",
    "plural": false,
    "selections": [
      (v1/*: any*/),
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
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "email",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "concreteType": "Cart",
        "kind": "LinkedField",
        "name": "carts",
        "plural": true,
        "selections": [
          (v1/*: any*/),
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "status",
            "storageKey": null
          },
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "orderNumber",
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
              (v1/*: any*/),
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
              }
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
              (v1/*: any*/),
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
          },
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
              (v2/*: any*/)
            ],
            "storageKey": null
          }
        ],
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "concreteType": "Payment",
        "kind": "LinkedField",
        "name": "payments",
        "plural": true,
        "selections": [
          (v1/*: any*/),
          (v2/*: any*/),
          {
            "alias": null,
            "args": null,
            "kind": "ScalarField",
            "name": "paymentReceived",
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
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Fragment",
    "metadata": null,
    "name": "AdminUserQuery",
    "selections": (v3/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": (v0/*: any*/),
    "kind": "Operation",
    "name": "AdminUserQuery",
    "selections": (v3/*: any*/)
  },
  "params": {
    "cacheID": "ddb5540f794f881ae19fa5628227128b",
    "id": null,
    "metadata": {},
    "name": "AdminUserQuery",
    "operationKind": "query",
    "text": "query AdminUserQuery(\n  $userId: UUID!\n) {\n  user(userId: $userId) {\n    id\n    firstName\n    lastName\n    email\n    carts {\n      id\n      status\n      orderNumber\n      tickets {\n        id\n        attendeeFirst\n        attendeeLast\n      }\n      horses {\n        id\n        horseName\n        ownershipLabel\n      }\n      cost {\n        ticketsCents\n        horseCents\n        sponsorCents\n        totalCents\n      }\n    }\n    payments {\n      id\n      totalCents\n      paymentReceived\n    }\n  }\n}\n"
  }
};
})();

(node as any).hash = "d6b55a21ae75e8d98c8b7e0368d11a07";

export default node;
