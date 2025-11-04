import { Network, RecordSource, Store } from 'relay-runtime';
import type { RequestParameters, Variables } from 'relay-runtime';
import * as RelayRuntime from 'relay-runtime';
import { getApiUrl } from '../utils/api';

function fetchQuery(operation: RequestParameters, variables: Variables) {
  const url = getApiUrl();
  
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

const environment = new (RelayRuntime as any).Environment({
  network: Network.create(fetchQuery),
  store: new (Store as any)(new (RecordSource as any)()),
});

export default environment;
