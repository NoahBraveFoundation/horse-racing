import React from 'react';
import { graphql, useFragment } from 'react-relay';

const RoundBoardFragment = graphql`
  fragment RoundBoardFragment on Round {
    id
    name
    startAt
    endAt
    lanes {
      id
      number
      horse {
        id
        horseName
        ownershipLabel
        owner { firstName lastName }
      }
    }
  }
`;

interface Props {
  roundRef: any;
  onLaneClick?: (roundId: string, laneId: string) => void;
}

function formatEpoch(value: number): string {
  // Treat incoming numbers as ms by default; if very small, assume seconds
  const ms = value > 1e12 ? value : value * 1000;
  const d = new Date(ms);
  return d.toLocaleString(undefined, { dateStyle: 'medium', timeStyle: 'short' });
}

const RoundBoard: React.FC<Props> = ({ roundRef, onLaneClick }) => {
  const round = useFragment(RoundBoardFragment, roundRef);
  return (
    <div className="rounded-2xl border border-noahbrave-200 p-4">
      <div className="flex items-center justify-between mb-3">
        <h3 className="font-semibold text-gray-900">{round.name}</h3>
        <div className="text-sm text-gray-600">
          {formatEpoch(round.startAt)} — {formatEpoch(round.endAt)}
        </div>
      </div>
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-3">
        {round.lanes.map((lane: any) => {
          const available = !lane.horse;
          return (
            <button
              key={lane.id}
              type="button"
              title={lane.horse?.ownershipLabel || ''}
              onClick={available && onLaneClick ? () => onLaneClick(round.id, lane.id) : undefined}
              className={`text-left rounded-xl border p-3 transition ${
                available
                  ? 'border-noahbrave-300 bg-white hover:border-noahbrave-500 hover:shadow-sm'
                  : 'border-gray-300 bg-gray-50 cursor-default'
              }`}
            >
              <div className="text-xs text-gray-500 mb-1">Lane {lane.number}</div>
              {lane.horse ? (
                <div>
                  <div className="font-medium text-gray-900 truncate">{lane.horse.horseName}</div>
                  <div className="text-xs text-gray-600 truncate">{lane.horse.owner.firstName} {lane.horse.owner.lastName}</div>
                </div>
              ) : (
                <div className="text-gray-400 text-sm">Available</div>
              )}
            </button>
          );
        })}
      </div>
    </div>
  );
};

export default RoundBoard;
