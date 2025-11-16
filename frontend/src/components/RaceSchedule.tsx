import React, { useEffect, useState } from 'react';
import { useLazyLoadQuery, graphql } from 'react-relay';
import Header from './Header';
import Footer from './Footer';
import RoundBoard from './horse-board/RoundBoard';
import Schedule from './Schedule';
import ErrorBoundary from './common/ErrorBoundary';
import ErrorFallback from './common/ErrorFallback';
import horseGates from '../assets/horse-gates.jpg';
import nbfLogo from '../assets/nbf-small.png';
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

const engagementHighlights = [
  {
    title: 'Wagering Lounge',
    description: 'Back your favorite horses with on-site wagering available all evening. All bets must be placed in crisp $2 increments.',
  },
  {
    title: 'Signature Raffle Pull',
    description: 'Stock up on raffle tickets at $10 for 12 chances to win curated baskets.',
  },
  {
    title: 'Heads or Tails Showdown',
    description: 'Immediately following Round 5 we launch our crowd-favorite game. Necklaces are $5 each; stay standing as long as your call matches the coin. Final champion takes home 50% of the pot. Please no necklace sharing.',
  },
  {
    title: 'Cooler for a Cause',
    description: 'Purchase one of 52 playing cards for $20 apiece. Once the deck sells out we pull a card and award a fully stocked premium cooler—classic raffle drama with excellent odds.',
  },
  {
    title: 'Neigh-shville Bound Escape',
    description: 'A second 52-card raffle mirrors the format for a Nashville getaway: hotel accommodations, Grand Ole Opry seats, and handpicked attractions for a music-city weekend.',
  },
  {
    title: 'Best Themed Attire Awards',
    description: 'Show off your boldest Derby-inspired fits. Judges will crown standout male and female guests.',
  },
];

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
    <div className="min-h-screen bg-gradient-to-b from-noahbrave-50 to-white font-body text-gray-800 print:bg-white print:text-sm print:leading-tight">
      <div className="print:hidden">
        <Header />
      </div>
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-14 print:py-6">
        <section className="print:break-after-page">
          <div className="grid lg:grid-cols-2 gap-10 items-center">
            <div>
              <p className="uppercase tracking-widest text-noahbrave-600 text-xs font-semibold mb-2 print:text-[11px]">
                Noah Brave Foundation Horse Racing Fundraiser
              </p>
              <h1 className="font-heading text-4xl md:text-5xl text-gray-900 mb-6 print:text-3xl">
                About the Event
              </h1>
              <p className="text-lg text-gray-700 mb-6 leading-relaxed print:text-sm">
                Get ready for an unforgettable evening of excitement, entertainment, and generosity. Our Horse Racing Fundraiser combines the thrill of the track with the power of community, all in support of a meaningful cause.
              </p>
              <p className="text-lg text-gray-700 mb-6 leading-relaxed print:text-sm">
                Proceeds benefit the <a href="https://noahbrave.org" target="_blank" rel="noopener noreferrer" className="text-noahbrave-600 hover:text-noahbrave-700 hover:underline">NoahBRAVE Foundation</a>, which provides personalized support, raises awareness, and funds research for children and families battling terminal brain cancer. By joining us, you help ensure families know they are seen, valued, loved, and never alone in their fight.
              </p>
            </div>
            <div>
              <img
                src={horseGates}
                alt="Horse racing gates"
                className="w-full h-auto rounded-3xl shadow-2xl"
              />
            </div>
          </div>
          <div className="mt-10 flex items-center justify-between gap-4 flex-wrap border-t border-gray-200 pt-6 print:flex-col print:items-start print:gap-2">
            <div className="text-sm text-gray-600 print:text-xs">
              Tina's Tavern · November 22, 2025 · Doors open 6:00 PM · First race 8:00 PM
            </div>
            <img src={nbfLogo} alt="Noah Brave Foundation" className="h-12 w-auto print:h-10" />
          </div>
        </section>

        <section className="mt-12 print:mt-4">
          <Schedule />
        </section>

        <section className="mt-12 print:mt-5">
          <div className="bg-white rounded-2xl border border-noahbrave-200 p-8 shadow-sm print:p-4 print:shadow-none">
            <div className="text-center mb-8 print:mb-4">
              <h2 className="font-heading text-3xl text-gray-900 mb-2 print:text-2xl">
                Evening Experiences
              </h2>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 print:grid-cols-2 print:gap-3">
              {engagementHighlights.map((highlight) => (
                <div
                  key={highlight.title}
                  className="rounded-xl border border-gray-200 bg-noahbrave-50/60 p-5 text-left print:p-3"
                >
                  <h3 className="font-heading text-xl text-gray-900 mb-2 print:text-lg">
                    {highlight.title}
                  </h3>
                  <p className="text-sm text-gray-700 leading-relaxed print:text-xs">
                    {highlight.description}
                  </p>
                </div>
              ))}
            </div>
          </div>
        </section>

        <section className="mt-12 print:mt-5 print:break-before-page">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-5 print:grid-cols-2 print:gap-3">
            {data.rounds.map((round) => (
              <div key={round.id} className="h-full w-full">
                <RoundBoard 
                  roundRef={round} 
                  meId={null}
                  showAdminInfo={false}
                  showTimes={false}
                />
              </div>
            ))}
          </div>
        </section>

        {/* Sponsors Section */}
        {data.sponsorInterests && data.sponsorInterests.length > 0 && (
          <div className="mt-14 print:mt-6 print:break-before-page">
            <h2 className="font-heading text-2xl text-gray-900 mb-6 text-center print:text-xl print:mb-3">
              Our Sponsors
            </h2>
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-5 print:gap-3">
              {data.sponsorInterests.map((sponsor) => (
                <div 
                  key={sponsor.id} 
                  className="bg-white rounded-xl border border-gray-200 p-4 flex flex-col items-center justify-center shadow-sm print:shadow-none print:border-gray-300 print:p-3"
                >
                  {sponsor.companyLogoBase64 ? (
                    <img 
                      src={`${sponsor.companyLogoBase64}`}
                      alt={sponsor.companyName}
                      className="max-h-20 max-w-full object-contain mb-2 print:max-h-14"
                    />
                  ) : (
                    <div className="w-full h-20 flex items-center justify-center print:h-14">
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
      <div className="print:hidden">
        <Footer />
      </div>
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
