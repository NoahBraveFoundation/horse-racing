import { create } from 'zustand';

type ModalState = { open: boolean; roundId: string | null; laneId: string | null };

type HorseBoardState = {
  refreshKey: number;
  setRefreshKey: (fn: (k: number) => number) => void;
  startPolling: () => () => void;

  modal: ModalState;
  openModal: (roundId: string, laneId: string) => void;
  closeModal: () => void;

  horseName: string;
  ownershipLabel: string;
  setHorseName: (v: string) => void;
  setOwnershipLabel: (v: string) => void;
  placing: boolean;
  setPlacing: (v: boolean) => void;
  error: string | null;
  setError: (v: string | null) => void;
};

export const useHorseBoardStore = create<HorseBoardState>((set, get) => ({
  refreshKey: 0,
  setRefreshKey: (fn) => set((s) => ({ refreshKey: fn(s.refreshKey) })),
  startPolling: () => {
    const id = setInterval(() => get().setRefreshKey((k) => k + 1), 5000);
    return () => clearInterval(id);
  },

  modal: { open: false, roundId: null, laneId: null },
  openModal: (roundId, laneId) => set({ modal: { open: true, roundId, laneId } }),
  closeModal: () => set({ modal: { open: false, roundId: null, laneId: null }, horseName: '', ownershipLabel: '', error: null }),

  horseName: '',
  ownershipLabel: '',
  setHorseName: (v) => set({ horseName: v }),
  setOwnershipLabel: (v) => set({ ownershipLabel: v }),
  placing: false,
  setPlacing: (v) => set({ placing: v }),
  error: null,
  setError: (v) => set({ error: v }),
}));
