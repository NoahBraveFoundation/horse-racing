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
        owner { id firstName lastName }
      }
    }
  }
`;

interface Props {
  roundRef: any;
  onLaneClick?: (roundId: string, laneId: string) => void;
  meId?: string | null;
  cartHorseIds?: Set<string>;
  onRemoveHorse?: (horseId: string) => void;
}

function formatTime(value: number): string {
  const ms = value > 1e12 ? value : value * 1000;
  const d = new Date(ms);
  return d.toLocaleTimeString(undefined, { hour: 'numeric', minute: '2-digit' });
}

const RoundBoard: React.FC<Props> = ({ roundRef, onLaneClick, meId, cartHorseIds, onRemoveHorse }) => {
  const round = useFragment(RoundBoardFragment, roundRef);
  const hasMine = !!meId && round.lanes.some((l: any) => l.horse && l.horse.owner?.id === meId);
  return (
    <div className="rounded-2xl border border-noahbrave-200 p-4 bg-white">
      <div className="flex items-center justify-between mb-3">
        <h3 className="font-semibold text-gray-900">{round.name}</h3>
        <div className="text-sm text-gray-600">
          {formatTime(round.startAt)} — {formatTime(round.endAt)}
        </div>
      </div>
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-3">
        {round.lanes.map((lane: any) => {
          const available = !lane.horse;
          const ownedByMe = !!lane.horse && meId && lane.horse.owner?.id === meId;
          const inCart = !!lane.horse && cartHorseIds?.has(lane.horse.id);
          const clickable = available && !hasMine && !!onLaneClick;
          const baseClasses = 'relative text-left rounded-xl border p-3 transition';
          const className = ownedByMe
            ? `${baseClasses} border-noahbrave-600 bg-noahbrave-50`
            : available
              ? clickable
                ? `${baseClasses} border-noahbrave-300 bg-white hover:border-noahbrave-500 hover:shadow-sm`
                : `${baseClasses} border-gray-200 bg-gray-100 cursor-not-allowed opacity-60`
              : `${baseClasses} border-gray-300 bg-gray-50 cursor-default`;

          const buttonTitle = available
            ? (hasMine ? 'Only 1 horse per round' : '')
            : (lane.horse?.ownershipLabel || `${lane.horse.owner.firstName} ${lane.horse.owner.lastName}`);

          return (
            <button
              key={lane.id}
              type="button"
              title={buttonTitle}
              onClick={clickable ? () => onLaneClick!(round.id, lane.id) : undefined}
              aria-disabled={!clickable}
              className={className}
            >
              {inCart && onRemoveHorse && (
                <span
                  onClick={(e) => { e.stopPropagation(); onRemoveHorse(lane.horse.id); }}
                  className="absolute right-2 top-2 inline-flex items-center justify-center h-6 w-6 rounded-full bg-gray-200 text-gray-700 hover:bg-gray-300"
                  title="Remove from cart"
                  role="button"
                >
                  ×
                </span>
              )}
              <div className="text-xs text-gray-500 mb-1">Lane {lane.number}</div>
              {lane.horse ? (
                <div className="text-left">
                  <div className="font-medium text-gray-900 truncate flex items-center gap-2">
                    <span className="truncate">{lane.horse.horseName}</span>
                  </div>
                  <div className="text-xs text-gray-600 truncate">
                    {lane.horse.owner.firstName} {lane.horse.owner.lastName}
                  </div>
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
