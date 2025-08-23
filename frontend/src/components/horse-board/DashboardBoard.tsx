import React, { useEffect, useState } from 'react';
import { graphql, useLazyLoadQuery } from 'react-relay';
import RoundBoard from './RoundBoard';
import type { DashboardBoardQuery } from '../../__generated__/DashboardBoardQuery.graphql';

const DashboardBoardQuery = graphql`
  query DashboardBoardQuery {
    rounds {
      id
      name
      startAt
      endAt
      lanes { 
        id 
        number 
        horse { 
          id 
          horseName 
          ownershipLabel 
          state
          owner { id firstName lastName email } 
        } 
      }
      ...RoundBoardFragment
    }
  }
`;

const DashboardBoard: React.FC = () => {
  const [refreshKey, setRefreshKey] = useState(0);
  
  useEffect(() => {
    const id = setInterval(() => setRefreshKey(k => k + 1), 10000); // Refresh every 10 seconds for admin view
    return () => clearInterval(id);
  }, []);

  const data = useLazyLoadQuery<DashboardBoardQuery>(DashboardBoardQuery, {}, { 
    fetchKey: refreshKey, 
    fetchPolicy: 'network-only' 
  });

  if (!data?.rounds) {
    return (
      <div className="text-center py-8">
        <div className="text-gray-500">Loading horse board...</div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="text-center mb-6">
        <h2 className="text-2xl font-semibold text-gray-900 mb-2">Live Horse Board</h2>
        <p className="text-gray-600">Real-time view of all horses across all rounds</p>
      </div>
      
      {data.rounds.map((round: any) => (
        <RoundBoard 
          key={round.id} 
          roundRef={round} 
          meId={null} // No personal ownership highlighting in admin view
          showAdminInfo={true} // Show additional admin information
        />
      ))}
    </div>
  );
};

export default DashboardBoard;
