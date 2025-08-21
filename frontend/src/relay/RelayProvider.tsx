import React from 'react';
import { RelayEnvironmentProvider } from 'react-relay';
import environment from './environment';

interface RelayProviderProps {
  children: React.ReactNode;
}

const RelayProvider: React.FC<RelayProviderProps> = ({ children }) => {
  return (
    <RelayEnvironmentProvider environment={environment}>
      {children}
    </RelayEnvironmentProvider>
  );
};

export default RelayProvider;
