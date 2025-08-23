/* eslint-disable @typescript-eslint/no-explicit-any */
declare module 'relay-runtime' {
  export interface Environment {
    network: Network;
    store: Store;
  }

  export interface Network {
    execute: (request: any, variables: any) => Promise<any>;
  }

  export interface Store {
    getSource(): RecordSource;
  }

  export interface RecordSource {
    get(recordID: string): any;
    set(recordID: string, record: any): void;
  }

  export function createEnvironment(config: { network: Network; store: Store }): Environment;
  export const Network: {
    create(fetchFn: (operation: any, variables: any) => Promise<any>): Network;
  };
  export function RecordSource(): RecordSource;
  export function Store(source: RecordSource): Store;
  export function RelayEnvironmentProvider(props: { children: React.ReactNode; environment: Environment }): JSX.Element;
  export function useMutation(mutation: any): [any, any];
}
