import React, { useEffect, useState } from 'react';
import { useLazyLoadQuery, graphql } from 'react-relay';
import Header from './Header';
import Footer from './Footer';
import RoundBoard from './horse-board/RoundBoard';
import ErrorBoundary from './common/ErrorBoundary';
import ErrorFallback from './common/ErrorFallback';
import type { RaceScheduleQuery as RaceScheduleQueryType } from '../__generated__/RaceScheduleQuery.graphql';

const RaceScheduleQuery = graphql`
  query RaceScheduleQuery {
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
          owner {
            id
            firstName
            lastName
          }
        }
      }
      ...RoundBoardFragment
    }
    sponsorInterests {
      id
      companyName
      companyLogoBase64
      costCents
    }
  }
`;

const RaceSchedule: React.FC = () => {
  // Auto-refresh every 5 seconds to show latest race information
  const [refreshKey, setRefreshKey] = useState(0);
  
  useEffect(() => {
    const id = setInterval(() => setRefreshKey(k => k + 1), 5000);
    return () => clearInterval(id);
  }, []);

  const data = useLazyLoadQuery<RaceScheduleQueryType>(
    RaceScheduleQuery, 
    {}, 
    { fetchKey: refreshKey, fetchPolicy: 'network-only' }
  );

  return (
    <div className="min-h-screen bg-gradient-to-b from-noahbrave-50 to-white font-body text-gray-800 print:bg-white">
      <Header />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20 print:py-8">
        <div className="text-center mb-12 print:mb-6">
          <h1 className="font-heading text-4xl md:text-5xl text-gray-900 mb-4 print:text-3xl">
            Race Day Schedule
          </h1>
          <p className="text-lg text-gray-700 print:text-base">
            Horse Racing Board
          </p>
        </div>

        {/* Horse Board */}
        <div className="space-y-6 print:space-y-4">
          {data.rounds.map((round) => (
            <RoundBoard 
              key={round.id} 
              roundRef={round} 
              meId={null}
              showAdminInfo={false}
            />
          ))}
        </div>

        {/* Sponsors Section */}
        {data.sponsorInterests && data.sponsorInterests.length > 0 && (
          <div className="mt-16 print:mt-8 print:break-before-page">
            <h2 className="font-heading text-3xl text-gray-900 mb-8 text-center print:text-2xl print:mb-4">
              Our Sponsors
            </h2>
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-6 print:gap-4">
              {data.sponsorInterests.map((sponsor) => (
                <div 
                  key={sponsor.id} 
                  className="bg-white rounded-xl border border-gray-200 p-4 flex flex-col items-center justify-center shadow-sm print:shadow-none print:border-gray-300"
                >
                  {sponsor.companyLogoBase64 ? (
                    <img 
                      src={`data:image/png;base64,${sponsor.companyLogoBase64}`}
                      alt={sponsor.companyName}
                      className="max-h-20 max-w-full object-contain mb-2 print:max-h-16"
                    />
                  ) : (
                    <div className="w-full h-20 flex items-center justify-center print:h-16">
                      <span className="text-gray-900 font-semibold text-center text-sm print:text-xs">
                        {sponsor.companyName}
                      </span>
                    </div>
                  )}
                  <p className="text-xs text-gray-600 text-center mt-2 print:text-[10px]">
                    {sponsor.companyName}
                  </p>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>
      <Footer />
      
      {/* Print-specific styles */}
      <style>{`
        @media print {
          .checker-top,
          nav,
          footer,
          button {
            display: none !important;
          }
          
          body {
            print-color-adjust: exact;
            -webkit-print-color-adjust: exact;
          }
          
          .print\\:break-before-page {
            break-before: page;
          }
          
          @page {
            margin: 1cm;
          }
        }
      `}</style>
    </div>
  );
};

const RaceScheduleWithErrorBoundary: React.FC = () => (
  <ErrorBoundary fallback={
    <ErrorFallback 
      title="Schedule Error"
      message="Unable to load the schedule. Please refresh the page or try again later."
      showLogout={false}
      showHome={true}
    />
  }>
    <RaceSchedule />
  </ErrorBoundary>
);

export default RaceScheduleWithErrorBoundary;
