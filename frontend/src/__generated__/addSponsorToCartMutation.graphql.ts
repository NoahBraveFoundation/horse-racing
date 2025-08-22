/**
 * @generated SignedSource<<3cbb16d60bc458221d132c60c4da3ccf>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ConcreteRequest } from 'relay-runtime';
export type addSponsorToCartMutation$variables = {
  companyLogoBase64?: string | null | undefined;
  companyName: string;
};
export type addSponsorToCartMutation$data = {
  readonly addSponsorToCart: {
    readonly companyLogoBase64: string | null | undefined;
    readonly companyName: string;
    readonly id: any | null | undefined;
  };
};
export type addSponsorToCartMutation = {
  response: addSponsorToCartMutation$data;
  variables: addSponsorToCartMutation$variables;
};

const node: ConcreteRequest = (function(){
var v0 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "companyLogoBase64"
},
v1 = {
  "defaultValue": null,
  "kind": "LocalArgument",
  "name": "companyName"
},
v2 = [
  {
    "alias": null,
    "args": [
      {
        "kind": "Variable",
        "name": "companyLogoBase64",
        "variableName": "companyLogoBase64"
      },
      {
        "kind": "Variable",
        "name": "companyName",
        "variableName": "companyName"
      }
    ],
    "concreteType": "SponsorInterest",
    "kind": "LinkedField",
    "name": "addSponsorToCart",
    "plural": false,
    "selections": [
      {
        "alias": null,
        "args": null,
        "kind": "ScalarField",
        "name": "id",
        "storageKey": null
      },
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
  }
];
return {
  "fragment": {
    "argumentDefinitions": [
      (v0/*: any*/),
      (v1/*: any*/)
    ],
    "kind": "Fragment",
    "metadata": null,
    "name": "addSponsorToCartMutation",
    "selections": (v2/*: any*/),
    "type": "Mutation",
    "abstractKey": null
  },
  "kind": "Request",
  "operation": {
    "argumentDefinitions": [
      (v1/*: any*/),
      (v0/*: any*/)
    ],
    "kind": "Operation",
    "name": "addSponsorToCartMutation",
    "selections": (v2/*: any*/)
  },
  "params": {
    "cacheID": "d0b097f76e91ffc89f216f22ab29567c",
    "id": null,
    "metadata": {},
    "name": "addSponsorToCartMutation",
    "operationKind": "mutation",
    "text": "mutation addSponsorToCartMutation(\n  $companyName: String!\n  $companyLogoBase64: String\n) {\n  addSponsorToCart(companyName: $companyName, companyLogoBase64: $companyLogoBase64) {\n    id\n    companyName\n    companyLogoBase64\n  }\n}\n"
  }
};
})();

(node as any).hash = "59712b73e1dd97b132961ef3c8330cf1";

export default node;
