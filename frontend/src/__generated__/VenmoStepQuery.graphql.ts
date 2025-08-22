/**
 * @generated SignedSource<<16e0c743e2bcb493c9848eaa17b1dce3>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type VenmoStepQuery$variables = Record<PropertyKey, never>;
export type VenmoStepQuery$data = {
  readonly me: {
    readonly email: string;
    readonly firstName: string;
    readonly id: any | null | undefined;
    readonly lastName: string;
  };
  readonly myCart: {
    readonly cost: {
      readonly totalCents: number;
    };
    readonly id: any | null | undefined;
    readonly orderNumber: string;
    readonly venmoLink: string;
    readonly venmoUser: string;
  } | null | undefined;
};
export type VenmoStepQuery = {
  response: VenmoStepQuery$data;
  variables: VenmoStepQuery$variables;
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
        "concreteType": "CartCost",
        "kind": "LinkedField",
        "name": "cost",
        "plural": false,
        "selections": [
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
        "kind": "ScalarField",
        "name": "orderNumber",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "venmoLink",
        "storageKey": null
      },
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "venmoUser",
        "storageKey": null
      }
    ],
    "storageKey": null
  },
  {
    "alias": null,
    "args": null,
    "concreteType": "User",
    "kind": "LinkedField",
    "name": "me",
    "plural": false,
    "selections": [
      (v0/*: any*/),
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
];
return {
  "fragment": {
    "argumentDefinitions": [],
    "kind": "Fragment",
    "metadata": null,
    "name": "VenmoStepQuery",
    "selections": (v1/*: any*/),
    "type": "Query",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [],
    "kind": "Operation",
    "name": "VenmoStepQuery",
    "selections": (v1/*: any*/)
  },
  "params": {
    "cacheID": "121cf99e5484f4373acf58e250f57c5a",
    "id": null,
    "metadata": {},
    "name": "VenmoStepQuery",
    "operationKind": "query",
    "text": "query VenmoStepQuery {\n  myCart {\n    id\n    cost {\n      totalCents\n    }\n    orderNumber\n    venmoLink\n    venmoUser\n  }\n  me {\n    id\n    email\n    firstName\n    lastName\n  }\n}\n"
  }
};
})();

(node as any).hash = "1051cf201fc0a94c7f9ea577cf18236c";

export default node;
