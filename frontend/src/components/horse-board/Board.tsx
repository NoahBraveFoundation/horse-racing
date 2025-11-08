import React, { useEffect } from 'react';
import { graphql, useLazyLoadQuery } from 'react-relay';
import RoundBoard from './RoundBoard';
import HorsePlacementModal from './HorsePlacementModal';
import { useTicketFlowStore, HORSE_PRICE } from '../../store/ticketFlow';
import { useHorseBoardStore } from '../../store/horseBoard';
import type { BoardQuery } from '../../__generated__/BoardQuery.graphql';

const BoardQuery = graphql`
  query BoardQuery {
    me { id firstName lastName }
    myCart { id horses { id } }
    rounds {
      id
      name
      startAt
      endAt
      lanes { id number horse { id horseName ownershipLabel owner { id firstName lastName } } }
      ...RoundBoardFragment
    }
  }
`;

const Board: React.FC = () => {
  const refreshKey = useHorseBoardStore((s) => s.refreshKey);
  const setRefreshKey = useHorseBoardStore((s) => s.setRefreshKey);
  const startPolling = useHorseBoardStore((s) => s.startPolling);

  const data = useLazyLoadQuery<BoardQuery>(BoardQuery, {}, { fetchKey: refreshKey, fetchPolicy: 'network-only' });
  const removeHorseFromCart = useTicketFlowStore((s) => s.removeHorseFromCart);
  const selections = useTicketFlowStore((s) => s.horseSelections);
  const refreshCart = useTicketFlowStore((s) => s.refreshCart);

  // Poll every 5s while viewing via store
  useEffect(() => startPolling(), [startPolling]);

  // Modal state from store
  const openModalStore = useHorseBoardStore((s) => s.openModal);
  const setError = useHorseBoardStore((s) => s.setError);

  const me = data?.me;
  const cartHorseIds = new Set<string>((data?.myCart?.horses ?? []).map((h: any) => h.id));

  const canPlaceInRound = (roundId: string) => !selections.some((s) => s.roundId === roundId);

  const onLaneClick = (roundId: string, laneId: string) => {
    if (!canPlaceInRound(roundId)) {
      setError('You already have a horse in this round.');
      return;
    }
    const { setHorseName, setOwnershipLabel, setError: resetError } = useHorseBoardStore.getState();
    setHorseName('');
    // Autofill Presented by with user name
    setOwnershipLabel(me ? `${me.firstName} ${me.lastName}` : '');
    resetError(null);
    openModalStore(roundId, laneId);
  };

  const onRemoveHorse = async (horseId: string) => {
    await removeHorseFromCart(horseId);
    setRefreshKey((k) => k + 1);
    refreshCart();
  };

  const refreshAfterPlacement = () => {
    setRefreshKey((k) => k + 1);
    refreshCart();
  };

  return (
    <div className="space-y-6">
      <div className="rounded-xl border border-noahbrave-200 bg-white p-3 text-center text-sm text-gray-700">
        Each horse costs <span className="font-semibold">${HORSE_PRICE}</span>. Tap an available lane to place your horse.
        <br />
        <span className="italic">✨ Tip: Pick a creative name - it makes it more fun!</span>
      </div>

      {data.rounds.map((round: any) => (
        <RoundBoard
          key={round.id}
          roundRef={round}
          onLaneClick={onLaneClick}
          meId={me?.id || null}
          cartHorseIds={cartHorseIds}
          onRemoveHorse={onRemoveHorse}
        />
      ))}

      <HorsePlacementModal canPlaceInRound={canPlaceInRound} refreshAfterPlacement={refreshAfterPlacement} />
    </div>
  );
};

export default Board;
