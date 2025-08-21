export interface User {
  id?: string;
  firstName: string;
  lastName: string;
  email: string;
}

export interface TicketFlowState {
  currentStep: number;
  user: User;
  tickets: Ticket[];
}

export interface Ticket {
  id?: string;
  type: string;
  quantity: number;
  price: number;
}

export interface CreateUserInput {
  firstName: string;
  lastName: string;
  email: string;
}

export interface CreateUserResponse {
  createUser: {
    user: User;
    success: boolean;
    message?: string;
  };
}
