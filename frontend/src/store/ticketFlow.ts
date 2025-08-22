import { create } from 'zustand';
import type { User } from '../types/ticket';
import { commitMutation } from 'react-relay';
import environment from '../relay/environment';
import { createUserMutation } from '../graphql/mutations/createUser';
import { getOrCreateCartMutationGQL } from '../graphql/mutations/getOrCreateCart';
import { addTicketToCartMutation } from '../graphql/mutations/addTicketToCart';
import { removeTicketFromCartMutation } from '../graphql/mutations/removeTicketFromCart';
import { addHorseToCartMutation } from '../graphql/mutations/addHorseToCart';
import { removeHorseFromCartMutation } from '../graphql/mutations/removeHorseFromCart';
import { addGiftBasketToCartMutation } from '../graphql/mutations/addGiftBasketToCart';
import { removeGiftBasketFromCartMutation } from '../graphql/mutations/removeGiftBasketFromCart';
import { addSponsorToCartMutation } from '../graphql/mutations/addSponsorToCart';
import { removeSponsorFromCartMutation } from '../graphql/mutations/removeSponsorFromCart';
import { checkoutCartMutation } from '../graphql/mutations/checkoutCart';

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

  cartRefreshKey: number;
  refreshCart: () => void;

  // actions
  setUser: (updates: Partial<User>) => void;
  nextStep: () => void;
  prevStep: () => void;
  goToStep: (step: number) => void;

  addAttendee: () => void;
  removeAttendee: (index: number) => void;
  updateAttendee: (index: number, updates: Partial<Attendee>) => void;

  createUser: (vars: { firstName: string; lastName: string; email: string }) => Promise<User>;
  ensureCart: () => Promise<void>;

  addTicketToCart: (vars: { attendeeFirst: string; attendeeLast: string }) => Promise<void>;
  removeTicketFromCart: (ticketId: string) => Promise<void>;

  addHorseToCart: (vars: { roundId: string; laneId: string; horseName: string; ownershipLabel: string }) => Promise<void>;
  removeHorseFromCart: (horseId: string) => Promise<void>;

  addGiftBasketToCart: (description: string) => Promise<void>;
  removeGiftBasketFromCart: (giftId: string) => Promise<void>;

  addSponsorToCart: (companyName: string, companyLogoBase64?: string) => Promise<void>;
  removeSponsorFromCart: (sponsorId: string) => Promise<void>;

  checkoutCart: () => Promise<void>;

  // selectors (legacy client subtotal)
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

  cartRefreshKey: 0,
  refreshCart: () => set((s) => ({ cartRefreshKey: s.cartRefreshKey + 1 })),

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
        onCompleted: async (response: any) => {
          const created = response?.createUser;
          if (created?.id) {
            set((s) => ({ user: { ...s.user, id: created.id }, isCreatingUser: false }));
            try {
              await get().ensureCart();
              get().refreshCart();
            } catch {}
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

  ensureCart: () =>
    new Promise<void>((resolve, reject) => {
      commitMutation(environment as any, {
        mutation: getOrCreateCartMutationGQL as any,
        variables: {} as any,
        onCompleted: () => resolve(),
        onError: (err: any) => reject(err),
      });
    }),

  addTicketToCart: (vars) =>
    new Promise<void>((resolve, reject) => {
      commitMutation(environment as any, {
        mutation: addTicketToCartMutation as any,
        variables: vars as any,
        onCompleted: () => { get().refreshCart(); resolve(); },
        onError: (err: any) => reject(err),
      });
    }),

  removeTicketFromCart: (ticketId) =>
    new Promise<void>((resolve, reject) => {
      commitMutation(environment as any, {
        mutation: removeTicketFromCartMutation as any,
        variables: { ticketId } as any,
        onCompleted: () => { get().refreshCart(); resolve(); },
        onError: (err: any) => reject(err),
      });
    }),

  addHorseToCart: (vars) =>
    new Promise<void>((resolve, reject) => {
      commitMutation(environment as any, {
        mutation: addHorseToCartMutation as any,
        variables: vars as any,
        onCompleted: () => { get().refreshCart(); resolve(); },
        onError: (err: any) => reject(err),
      });
    }),

  removeHorseFromCart: (horseId) =>
    new Promise<void>((resolve, reject) => {
      commitMutation(environment as any, {
        mutation: removeHorseFromCartMutation as any,
        variables: { horseId } as any,
        onCompleted: () => { get().refreshCart(); resolve(); },
        onError: (err: any) => reject(err),
      });
    }),

  addGiftBasketToCart: (description) =>
    new Promise<void>((resolve, reject) => {
      commitMutation(environment as any, {
        mutation: addGiftBasketToCartMutation as any,
        variables: { description } as any,
        onCompleted: () => { get().refreshCart(); resolve(); },
        onError: (err: any) => reject(err),
      });
    }),

  removeGiftBasketFromCart: (giftId) =>
    new Promise<void>((resolve, reject) => {
      commitMutation(environment as any, {
        mutation: removeGiftBasketFromCartMutation as any,
        variables: { giftId } as any,
        onCompleted: () => { get().refreshCart(); resolve(); },
        onError: (err: any) => reject(err),
      });
    }),

  addSponsorToCart: (companyName: string, companyLogoBase64?: string) =>
    new Promise<void>((resolve, reject) => {
      commitMutation(environment as any, {
        mutation: addSponsorToCartMutation as any,
        variables: { companyName, companyLogoBase64 } as any,
        onCompleted: () => { get().refreshCart(); resolve(); },
        onError: (err: any) => reject(err),
      });
    }),

  removeSponsorFromCart: (sponsorId) =>
    new Promise<void>((resolve, reject) => {
      commitMutation(environment as any, {
        mutation: removeSponsorFromCartMutation as any,
        variables: { sponsorId } as any,
        onCompleted: () => { get().refreshCart(); resolve(); },
        onError: (err: any) => reject(err),
      });
    }),

  checkoutCart: () =>
    new Promise<void>((resolve, reject) => {
      commitMutation(environment as any, {
        mutation: checkoutCartMutation as any,
        variables: {} as any,
        onCompleted: () => { get().refreshCart(); resolve(); },
        onError: (err: any) => reject(err),
      });
    }),

  totalTickets: () => 1 + get().attendees.length,
  totalHorseCount: () => get().horseSelections.length,
  ticketsTotal: () => (1 + get().attendees.length) * TICKET_PRICE,
  horsesTotal: () => get().horseSelections.length * HORSE_PRICE,
  grandTotal: () => ((1 + get().attendees.length) * TICKET_PRICE) + (get().horseSelections.length * HORSE_PRICE),
}));
