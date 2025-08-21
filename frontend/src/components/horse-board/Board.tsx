import React, { useEffect } from 'react';
import { graphql, useLazyLoadQuery } from 'react-relay';
import RoundBoard from './RoundBoard';
import { useTicketFlowStore, HORSE_PRICE } from '../../store/ticketFlow';
import { useHorseBoardStore } from '../../store/horseBoard';

const BoardQuery = graphql`
  query BoardQuery {
    rounds {
      id
      name
      startAt
      endAt
      lanes { id number horse { id horseName ownershipLabel owner { firstName lastName } } }
      ...RoundBoardFragment
    }
  }
`;

const Board: React.FC = () => {
  const refreshKey = useHorseBoardStore((s) => s.refreshKey);
  const setRefreshKey = useHorseBoardStore((s) => s.setRefreshKey);
  const startPolling = useHorseBoardStore((s) => s.startPolling);

  const data: any = useLazyLoadQuery(BoardQuery, {}, { fetchKey: refreshKey });
  const purchaseHorse = useTicketFlowStore((s) => s.purchaseHorse);
  const selections = useTicketFlowStore((s) => s.horseSelections);

  // Poll every 5s while viewing via store
  useEffect(() => startPolling(), [startPolling]);

  // Modal state from store
  const modal = useHorseBoardStore((s) => s.modal);
  const openModalStore = useHorseBoardStore((s) => s.openModal);
  const closeModal = useHorseBoardStore((s) => s.closeModal);
  const horseName = useHorseBoardStore((s) => s.horseName);
  const ownershipLabel = useHorseBoardStore((s) => s.ownershipLabel);
  const setHorseName = useHorseBoardStore((s) => s.setHorseName);
  const setOwnershipLabel = useHorseBoardStore((s) => s.setOwnershipLabel);
  const placing = useHorseBoardStore((s) => s.placing);
  const setPlacing = useHorseBoardStore((s) => s.setPlacing);
  const error = useHorseBoardStore((s) => s.error);
  const setError = useHorseBoardStore((s) => s.setError);

  const canPlaceInRound = (roundId: string) => !selections.some((s) => s.roundId === roundId);

  const onLaneClick = (roundId: string, laneId: string) => {
    if (!canPlaceInRound(roundId)) {
      setError('You already have a horse in this round.');
      return;
    }
    setHorseName('');
    setOwnershipLabel('');
    setError(null);
    openModalStore(roundId, laneId);
  };

  const onPlace = async () => {
    if (!modal.roundId || !modal.laneId) return;
    if (!horseName.trim() || !ownershipLabel.trim()) {
      setError('Please enter horse name and ownership label.');
      return;
    }
    setPlacing(true);
    try {
      await purchaseHorse({ roundId: modal.roundId, laneId: modal.laneId, horseName: horseName.trim(), ownershipLabel: ownershipLabel.trim() });
      setPlacing(false);
      closeModal();
      // Trigger immediate refresh after placing
      setRefreshKey((k) => k + 1);
    } catch (e: any) {
      setPlacing(false);
      setError(e?.message || 'Unable to place horse.');
    }
  };

  return (
    <div className="space-y-6">
      <div className="rounded-xl border border-noahbrave-200 bg-white p-3 text-center text-sm text-gray-700">
        Each horse costs <span className="font-semibold">${HORSE_PRICE}</span>. Tap an available lane to place your horse.
      </div>

      {data.rounds.map((round: any) => (
        <RoundBoard key={round.id} roundRef={round} onLaneClick={onLaneClick} />
      ))}

      {/* Modal */}
      {modal.open && (
        <div className="fixed inset-0 z-50 flex items-end sm:items-center justify-center">
          <div className="absolute inset-0 bg-black/40" onClick={closeModal} />
          <div className="relative w-full sm:w-[500px] bg-white rounded-t-2xl sm:rounded-2xl shadow-xl p-6">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-semibold text-gray-900">Place a horse (${HORSE_PRICE})</h3>
              <button className="text-gray-500 hover:text-gray-700" onClick={closeModal}>✕</button>
            </div>
            {error && <div className="mb-3 rounded-lg border border-red-200 bg-red-50 p-3 text-red-800 text-sm">{error}</div>}
            <div className="grid sm:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Horse name</label>
                <input
                  value={horseName}
                  onChange={(e) => setHorseName(e.target.value)}
                  className="w-full rounded-lg border px-3 py-2 border-gray-300 focus:outline-none focus:ring-2 focus:ring-noahbrave-600"
                  placeholder="Thunderbolt"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Presented by</label>
                <input
                  value={ownershipLabel}
                  onChange={(e) => setOwnershipLabel(e.target.value)}
                  className="w-full rounded-lg border px-3 py-2 border-gray-300 focus:outline-none focus:ring-2 focus:ring-noahbrave-600"
                  placeholder="Team Hope"
                />
              </div>
            </div>
            <div className="flex justify-end mt-5">
              <button onClick={closeModal} className="px-4 py-2 rounded-lg border mr-3">Cancel</button>
              <button onClick={onPlace} disabled={placing} className="cta px-5 py-2 rounded-lg font-semibold disabled:opacity-50">
                {placing ? 'Placing…' : 'Place horse'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default Board;
