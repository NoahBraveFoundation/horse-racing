declare module 'relay-runtime' {
  import { ReactNode } from 'react';

  export interface Environment {
    network: Network;
    store: Store;
  }

  export interface Network {
    execute: (request: RequestParameters, variables: Variables) => Promise<GraphQLResponse>;
  }

  export interface Store {
    getSource(): RecordSource;
  }

  export interface RecordSource {
    get(recordID: string): Record | null;
    set(recordID: string, record: Record): void;
  }

  export interface RequestParameters {
    text: string;
    name: string;
    operationKind: 'query' | 'mutation' | 'subscription';
  }

  export type Variables = { [key: string]: any };

  export interface GraphQLResponse {
    data?: any;
    errors?: Array<{
      message: string;
      locations?: Array<{ line: number; column: number }>;
      path?: Array<string | number>;
    }>;
  }

  export interface Record {
    [key: string]: any;
  }

  export function createEnvironment(config: { network: Network; store: Store }): Environment;
  
  export const Network: {
    create(fetchFn: (operation: RequestParameters, variables: Variables) => Promise<GraphQLResponse>): Network;
  };
  
  export function RecordSource(): RecordSource;
  export function Store(source: RecordSource): Store;
  
  export function RelayEnvironmentProvider(props: { 
    children: ReactNode; 
    environment: Environment 
  }): JSX.Element;
  
  export function useMutation<TMutation extends { response: any; variables: any }>(
    mutation: any
  ): [(config: {
    variables: TMutation['variables'];
    onCompleted?: (response: TMutation['response']) => void;
    onError?: (error: Error) => void;
  }) => void, boolean];
}
