/**
 * @generated SignedSource<<28d89766d7a8e7e32e4424fc8c9d1543>>
 * @lightSyntaxTransform
 * @nogrep
 */

/* tslint:disable */
/* eslint-disable */
// @ts-nocheck

import { ReaderFragment } from 'relay-runtime';
export type HorseEntryState = "confirmed" | "on_hold" | "pending_payment" | "%future added value";
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
      readonly state: HorseEntryState;
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
  "type": "Round",
  "abstractKey": null
};
})();

(node as any).hash = "6676535fb5ec69b185485c877659f061";

export default node;
