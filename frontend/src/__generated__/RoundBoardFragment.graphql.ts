/**
 * @generated SignedSource<<7d6d897a1ea840540a35af83eabcbb83>>
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

(node as any).hash = "9ab65719524b5b21627990cf679ee27c";

export default node;
