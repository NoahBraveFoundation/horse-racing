/**
 * @generated SignedSource<<f47977a9cd5004d105b613e7b4b4ad69>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ReaderFragment } from 'relay-runtime';
import { FragmentRefs } from "relay-runtime";
export type RoundBoardFragment$data = {
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
  readonly " $fragmentType": "RoundBoardFragment";
};
export type RoundBoardFragment$key = {
  readonly " $data"?: RoundBoardFragment$data;
  readonly " $fragmentSpreads": FragmentRefs<"RoundBoardFragment">;
};

const node: ReaderFragment = (function(){
var v0 = {
  "alias": null,
  "args": null,
  "kind": "ScalarField",
  "name": "id",
  "storageKey": null
};
return {
  "argumentDefinitions": [],
  "kind": "Fragment",
  "metadata": null,
  "name": "RoundBoardFragment",
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
              "storageKey": null
            }
          ],
          "storageKey": null
        }
      ],
      "storageKey": null
    }
  ],
  "type": "Round",
  "abstractKey": null
};
})();

(node as any).hash = "e2140e4a42deca00ed5c8b03007fba17";

export default node;
