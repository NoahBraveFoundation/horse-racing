import React, { useCallback } from 'react';
import { shallow } from 'zustand/shallow';
import { HORSE_PRICE, useTicketFlowStore } from '../../store/ticketFlow';
import { useHorseBoardStore } from '../../store/horseBoard';

type Props = {
  canPlaceInRound: (roundId: string) => boolean;
  refreshAfterPlacement: () => void;
};

const HorsePlacementModal: React.FC<Props> = ({ canPlaceInRound, refreshAfterPlacement }) => {
  const {
    modal,
    closeModal,
    horseName,
    setHorseName,
    ownershipLabel,
    setOwnershipLabel,
    placing,
    setPlacing,
    error,
    setError,
  } = useHorseBoardStore(
    (state) => ({
      modal: state.modal,
      closeModal: state.closeModal,
      horseName: state.horseName,
      setHorseName: state.setHorseName,
      ownershipLabel: state.ownershipLabel,
      setOwnershipLabel: state.setOwnershipLabel,
      placing: state.placing,
      setPlacing: state.setPlacing,
      error: state.error,
      setError: state.setError,
    }),
    shallow,
  );

  const addHorseToCart = useTicketFlowStore((s) => s.addHorseToCart);

  const onPlace = useCallback(async () => {
    if (!modal.roundId || !modal.laneId) return;
    if (!horseName.trim() || !ownershipLabel.trim()) {
      setError('Please enter horse name and ownership label.');
      return;
    }
    if (!canPlaceInRound(modal.roundId)) {
      setError('You already have a horse in this round.');
      return;
    }
    setPlacing(true);
    try {
      await addHorseToCart({
        roundId: modal.roundId,
        laneId: modal.laneId,
        horseName: horseName.trim(),
        ownershipLabel: ownershipLabel.trim(),
      });
      setPlacing(false);
      closeModal();
      refreshAfterPlacement();
    } catch (e: unknown) {
      setPlacing(false);
      const message = e instanceof Error && e.message ? e.message : 'Unable to place horse.';
      setError(message);
    }
  }, [
    addHorseToCart,
    canPlaceInRound,
    closeModal,
    horseName,
    modal.laneId,
    modal.roundId,
    ownershipLabel,
    refreshAfterPlacement,
    setError,
    setPlacing,
  ]);

  if (!modal.open) {
    return null;
  }

  return (
    <div className="fixed inset-0 z-[60] flex items-end sm:items-center justify-center">
      <div className="absolute inset-0 bg-black/40" onClick={closeModal} />
      <div className="relative w-full sm:w-[500px] bg-white rounded-t-2xl sm:rounded-2xl shadow-xl p-6">
        <div className="flex items-center justify-between mb-4">
          <h3 className="text-lg font-semibold text-gray-900">Place a horse (${HORSE_PRICE})</h3>
          <button className="text-gray-500 hover:text-gray-700" onClick={closeModal}>
            ✕
          </button>
        </div>
        {error && (
          <div className="mb-3 rounded-lg border border-red-200 bg-red-50 p-3 text-red-800 text-sm">{error}</div>
        )}
        <div className="grid sm:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Horse name (get creative!)</label>
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
              placeholder="Your name"
            />
          </div>
        </div>
        <div className="flex justify-end mt-5">
          <button onClick={closeModal} className="px-4 py-2 rounded-lg border mr-3">
            Cancel
          </button>
          <button onClick={onPlace} disabled={placing} className="cta px-5 py-2 rounded-lg font-semibold disabled:opacity-50">
            {placing ? 'Placing…' : 'Place horse'}
          </button>
        </div>
      </div>
    </div>
  );
};

export default HorsePlacementModal;
