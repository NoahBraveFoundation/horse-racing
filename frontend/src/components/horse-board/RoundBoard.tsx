import React from 'react';
import { graphql, useFragment } from 'react-relay';
import type { RoundBoardFragment$key } from '../../__generated__/RoundBoardFragment.graphql';

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
        owner { id firstName lastName email }
        state
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
  onRenameHorse?: (horse: { id: string; horseName: string; ownershipLabel: string }) => void;
  showAdminInfo?: boolean;
  showTimes?: boolean;
}

function formatTime(value: number): string {
  const ms = value > 1e12 ? value : value * 1000;
  const d = new Date(ms);
  return d.toLocaleTimeString(undefined, { hour: 'numeric', minute: '2-digit' });
}

const RoundBoard: React.FC<Props> = ({ 
  roundRef, 
  onLaneClick, 
  meId, 
  cartHorseIds, 
  onRemoveHorse, 
  onRenameHorse,
  showAdminInfo = false,
  showTimes = true
}) => {
  const round = useFragment<RoundBoardFragment$key>(RoundBoardFragment, roundRef);
  const hasMine = !!meId && round.lanes.some((l: any) => l.horse && l.horse.owner?.id === meId);
  
  return (
    <div className="rounded-2xl border border-noahbrave-200 p-4 bg-white print:rounded-lg print:border-gray-300 print:p-2 print:text-xs">
      <div className="flex items-center justify-between mb-2 print:mb-1 print:flex-wrap print:gap-y-1">
        <h3 className="font-semibold text-gray-900 text-lg print:text-base">{round.name}</h3>
        {showTimes && (
          <div className="text-sm text-gray-600 print:text-xs">
            {formatTime(round.startAt)} — {formatTime(round.endAt)}
          </div>
        )}
      </div>
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-2 print:grid-cols-5 print:gap-1.5">
        {round.lanes.map((lane: any) => {
          const available = !lane.horse;
          const ownedByMe = !!lane.horse && meId && lane.horse.owner?.id === meId;
          const inCart = !!lane.horse && cartHorseIds?.has(lane.horse.id);
          const clickable = available && !hasMine && !!onLaneClick;
          const canRename = ownedByMe && !!onRenameHorse;
          const baseClasses = 'relative text-left rounded-xl border p-2.5 text-sm transition print:p-1.5 print:text-[11px] print:rounded-lg';
          const className = ownedByMe
            ? `${baseClasses} border-green-600 bg-green-100`
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
              onClick={clickable ? () => onLaneClick!(round.id, lane.id) : canRename ? () => onRenameHorse!(lane.horse) : undefined}
              aria-disabled={!(clickable || canRename)}
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
              {canRename && !inCart && (
                <span className="absolute right-2 top-2 inline-flex items-center justify-center h-5 w-5 rounded-full bg-gray-200 text-gray-700">
                  ✎
                </span>
              )}
              <div className="text-xs text-gray-500 mb-1 print:text-[10px]">Lane {lane.number}</div>
              {lane.horse ? (
                <div className="text-left">
                  <div className="font-medium text-gray-900 flex items-center gap-2 text-sm leading-tight print:text-[11px]">
                    <span
                      className="overflow-hidden"
                      style={{ display: '-webkit-box', WebkitLineClamp: 2, WebkitBoxOrient: 'vertical' }}
                    >
                      {lane.horse.horseName}
                    </span>
                  </div>
                  <div className="text-xs text-gray-600 truncate print:text-[10px]">
                    {lane.horse.ownershipLabel}
                  </div>
                  {showAdminInfo && (
                    <>
                      <div className="text-xs text-gray-500 mt-1 print:text-[10px]">
                        <span
                          className="overflow-hidden"
                          style={{ display: '-webkit-box', WebkitLineClamp: 2, WebkitBoxOrient: 'vertical' }}
                        >
                          {lane.horse.owner.firstName} {lane.horse.owner.lastName}
                        </span>
                      </div>
                      <div className="text-xs text-gray-400 mt-1 print:text-[10px]">
                        {lane.horse.owner.email}
                      </div>
                      {lane.horse.state && (
                        <div className={`text-xs px-2 py-1 rounded mt-1 inline-block ${
                          lane.horse.state === 'confirmed' ? 'bg-green-100 text-green-800' :
                          lane.horse.state === 'pending_payment' ? 'bg-yellow-100 text-yellow-800' :
                          'bg-red-100 text-red-800'
                        }`}>
                          {lane.horse.state.replace('_', ' ')}
                        </div>
                      )}
                    </>
                  )}
                </div>
              ) : (
                <div className="text-gray-400 text-sm print:text-[11px]">Available</div>
              )}
            </button>
          );
        })}
      </div>
    </div>
  );
};

export default RoundBoard;
