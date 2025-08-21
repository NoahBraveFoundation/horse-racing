import { create } from 'zustand';
import type { User } from '../types/ticket';
import { commitMutation } from 'react-relay';
import environment from '../relay/environment';
import { createUserMutation } from '../graphql/mutations/createUser';
import { purchaseHorseMutation } from '../graphql/mutations/purchaseHorse';

export type Attendee = { firstName: string; lastName: string };
export type HorseSelection = { roundId: string; laneId: string; horseName: string; ownershipLabel: string; horseId?: string };

export const TICKET_PRICE = 75;
export const HORSE_PRICE = 30;

type TicketFlowState = {
  currentStep: number;
  user: User;
  attendees: Attendee[];
  horseSelections: HorseSelection[];
  isCreatingUser: boolean;
  errorMessage: string | null;

  // actions
  setUser: (updates: Partial<User>) => void;
  nextStep: () => void;
  prevStep: () => void;
  goToStep: (step: number) => void;

  addAttendee: () => void;
  removeAttendee: (index: number) => void;
  updateAttendee: (index: number, updates: Partial<Attendee>) => void;

  createUser: (vars: { firstName: string; lastName: string; email: string }) => Promise<User>;

  purchaseHorse: (vars: { roundId: string; laneId: string; horseName: string; ownershipLabel: string }) => Promise<HorseSelection>;

  // selectors
  totalTickets: () => number;
  totalHorseCount: () => number;
  ticketsTotal: () => number;
  horsesTotal: () => number;
  grandTotal: () => number;
};

export const useTicketFlowStore = create<TicketFlowState>((set, get) => ({
  currentStep: 1,
  user: { firstName: '', lastName: '', email: '' },
  attendees: [],
  horseSelections: [],
  isCreatingUser: false,
  errorMessage: null,

  setUser: (updates) => set((state) => ({ user: { ...state.user, ...updates } })),
  nextStep: () => set((s) => ({ currentStep: s.currentStep + 1 })),
  prevStep: () => set((s) => ({ currentStep: Math.max(1, s.currentStep - 1) })),
  goToStep: (step) => set(() => ({ currentStep: Math.max(1, step) })),

  addAttendee: () => set((s) => ({ attendees: [...s.attendees, { firstName: '', lastName: '' }] })),
  removeAttendee: (index) => set((s) => ({ attendees: s.attendees.filter((_, i) => i !== index) })),
  updateAttendee: (index, updates) =>
    set((s) => ({ attendees: s.attendees.map((a, i) => (i === index ? { ...a, ...updates } : a)) })),

  createUser: (vars) =>
    new Promise<User>((resolve, reject) => {
      set({ isCreatingUser: true, errorMessage: null });
      commitMutation(environment as any, {
        mutation: createUserMutation as any,
        variables: vars as any,
        onCompleted: (response: any) => {
          const created = response?.createUser;
          if (created?.id) {
            set((s) => ({ user: { ...s.user, id: created.id }, isCreatingUser: false }));
            resolve(created);
          } else {
            const message = 'Unexpected response from server. Please try again.';
            set({ errorMessage: message, isCreatingUser: false });
            reject(new Error(message));
          }
        },
        onError: (err: any) => {
          let message = 'Something went wrong. Please try again.';
          if (err?.message) {
            const match = err.message.match(/Abort\.\d+:\s*(.+)/);
            message = match ? match[1] : err.message;
          }
          set({ errorMessage: message, isCreatingUser: false });
          reject(new Error(message));
        },
      });
    }),

  purchaseHorse: (vars) =>
    new Promise<HorseSelection>((resolve, reject) => {
      commitMutation(environment as any, {
        mutation: purchaseHorseMutation as any,
        variables: vars as any,
        onCompleted: (response: any) => {
          const horse = response?.purchaseHorse;
          if (horse?.id) {
            const selection: HorseSelection = { roundId: vars.roundId, laneId: vars.laneId, horseName: vars.horseName, ownershipLabel: vars.ownershipLabel, horseId: horse.id };
            set((s) => ({ horseSelections: [...s.horseSelections, selection] }));
            resolve(selection);
          } else {
            reject(new Error('Could not place horse.'));
          }
        },
        onError: (err: any) => {
          let message = 'Something went wrong placing horse.';
          if (err?.message) {
            const match = err.message.match(/Abort\.\d+:\s*(.+)/);
            message = match ? match[1] : err.message;
          }
          reject(new Error(message));
        },
      });
    }),

  totalTickets: () => 1 + get().attendees.length,
  totalHorseCount: () => get().horseSelections.length,
  ticketsTotal: () => (1 + get().attendees.length) * TICKET_PRICE,
  horsesTotal: () => get().horseSelections.length * HORSE_PRICE,
  grandTotal: () => ((1 + get().attendees.length) * TICKET_PRICE) + (get().horseSelections.length * HORSE_PRICE),
}));
