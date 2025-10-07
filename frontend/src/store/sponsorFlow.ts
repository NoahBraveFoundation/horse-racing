import { create } from 'zustand';
import type { User } from '../types/ticket';
import { commitMutation } from 'react-relay';
import environment from '../relay/environment';
import { createUserMutation } from '../graphql/mutations/createUser';
import { getOrCreateCartMutationGQL } from '../graphql/mutations/getOrCreateCart';
import { addSponsorToCartMutation } from '../graphql/mutations/addSponsorToCart';
import { removeSponsorFromCartMutation } from '../graphql/mutations/removeSponsorFromCart';
import { checkoutCartMutation } from '../graphql/mutations/checkoutCart';

import type { createUserMutation as CreateUserMutation } from '../__generated__/createUserMutation.graphql';
import type { addSponsorToCartMutation as AddSponsorToCartMutation } from '../__generated__/addSponsorToCartMutation.graphql';
import type { removeSponsorFromCartMutation as RemoveSponsorFromCartMutation } from '../__generated__/removeSponsorFromCartMutation.graphql';
import type { checkoutCartMutation as CheckoutCartMutation } from '../__generated__/checkoutCartMutation.graphql';
import type { getOrCreateCartMutation as GetOrCreateCartMutation } from '../__generated__/getOrCreateCartMutation.graphql';

interface SponsorFlowState {
  currentStep: number;
  user: User;
  isCreatingUser: boolean;
  errorMessage: string | null;
  cartRefreshKey: number;
  refreshCart: () => void;

  setUser: (updates: Partial<User>) => void;
  nextStep: () => void;
  prevStep: () => void;
  goToStep: (step: number) => void;

  createUser: (vars: { firstName: string; lastName: string; email: string }) => Promise<User>;
  ensureCart: () => Promise<void>;
  addSponsorToCart: (companyName: string, amountDollars: number, companyLogoBase64?: string) => Promise<void>;
  removeSponsorFromCart: (sponsorId: string) => Promise<void>;
  checkoutCart: () => Promise<void>;
}

export const useSponsorFlowStore = create<SponsorFlowState>((set, get) => ({
  currentStep: 1,
  user: { firstName: '', lastName: '', email: '' },
  isCreatingUser: false,
  errorMessage: null,
  cartRefreshKey: 0,
  refreshCart: () => set((s) => ({ cartRefreshKey: s.cartRefreshKey + 1 })),

  setUser: (updates) => set((s) => ({ user: { ...s.user, ...updates } })),
  nextStep: () => set((s) => ({ currentStep: s.currentStep + 1 })),
  prevStep: () => set((s) => ({ currentStep: Math.max(1, s.currentStep - 1) })),
  goToStep: (step) => set(() => ({ currentStep: Math.max(1, step) })),

  createUser: (vars) =>
    new Promise<User>((resolve, reject) => {
      set({ isCreatingUser: true, errorMessage: null });
      commitMutation<CreateUserMutation>(environment, {
        mutation: createUserMutation,
        variables: vars,
        onCompleted: async (response: CreateUserMutation['response']) => {
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
        onError: (err: Error) => {
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
      commitMutation<GetOrCreateCartMutation>(environment, {
        mutation: getOrCreateCartMutationGQL,
        variables: {},
        onCompleted: () => resolve(),
        onError: (err: Error) => reject(err),
      });
    }),

  addSponsorToCart: (companyName, amountDollars, companyLogoBase64) =>
    new Promise<void>((resolve, reject) => {
      commitMutation<AddSponsorToCartMutation>(environment, {
        mutation: addSponsorToCartMutation,
        variables: { companyName, amountCents: Math.round(amountDollars * 100), companyLogoBase64 },
        onCompleted: () => { get().refreshCart(); resolve(); },
        onError: (err: Error) => reject(err),
      });
    }),

  removeSponsorFromCart: (sponsorId) =>
    new Promise<void>((resolve, reject) => {
      commitMutation<RemoveSponsorFromCartMutation>(environment, {
        mutation: removeSponsorFromCartMutation,
        variables: { sponsorId },
        onCompleted: () => { get().refreshCart(); resolve(); },
        onError: (err: Error) => reject(err),
      });
    }),

  checkoutCart: () =>
    new Promise<void>((resolve, reject) => {
      commitMutation<CheckoutCartMutation>(environment, {
        mutation: checkoutCartMutation,
        variables: {},
        onCompleted: () => { get().refreshCart(); resolve(); },
        onError: (err: Error) => reject(err),
      });
    }),
}));


