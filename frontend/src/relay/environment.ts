// @ts-ignore - Bypassing strict typing for Relay setup
import { Environment, Network, RecordSource, Store } from 'relay-runtime';

const API_URL = import.meta.env.VITE_API_URL || '/graphql';

function fetchQuery(operation: any, variables: any) {
  const url = import.meta.env.DEV ? '/graphql' : API_URL;
  
  return fetch(url, {
    method: 'POST',
    credentials: 'include',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      query: operation.text,
      variables,
    }),
  }).then(response => response.json());
}

// @ts-ignore - Using constructor despite type issues
const environment = new (Environment as any)({
  network: Network.create(fetchQuery),
  store: new (Store as any)(new (RecordSource as any)()),
});

export default environment;
