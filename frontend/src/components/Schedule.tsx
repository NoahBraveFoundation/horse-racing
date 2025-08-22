import React from 'react'
import SectionHeading from './SectionHeading'

const Item: React.FC<{ time: string; title: string; subtitle: string; icon: React.ReactNode }>
  = ({ time, title, subtitle, icon }) => (
  <div className="text-center p-8 bg-noahbrave-50 rounded-xl border border-noahbrave-200 shadow-sm transition-transform card-hover">
    <div className="w-16 h-16 bg-noahbrave-600 rounded-full flex items-center justify-center mx-auto mb-4 shadow">
      {icon}
    </div>
    <h3 className="font-heading text-2xl text-gray-900 mb-1">{time}</h3>
    <p className="text-lg text-gray-700">{title}</p>
    <p className="text-sm text-gray-500 mt-2">{subtitle}</p>
  </div>
)

export const Schedule: React.FC = () => {
  return (
    <section id="schedule" className="py-20 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <SectionHeading title="Event Schedule" />
        <div className="grid md:grid-cols-2 lg:grid-cols-5 gap-6">
          <Item
            time="6:00 PM"
            title="Doors Open"
            subtitle="Registration & welcome drinks"
            icon={(
              <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            )}
          />
          <Item
            time="6:45 PM"
            title="Dinner Served"
            subtitle="Delicious meal included with your ticket"
            icon={(
              <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
              </svg>
            )}
          />
          <Item
            time="7:50 PM"
            title="Wagering Opens"
            subtitle="Place your bets on the races"
            icon={(
              <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1" />
              </svg>
            )}
          />
          <Item
            time="8:00 PM"
            title="Race #1"
            subtitle="The excitement begins!"
            icon={(
              <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 10V3L4 14h7v7l9-11h-7z" />
              </svg>
            )}
          />
          <Item
            time="11:00 PM"
            title="Races End"
            subtitle="Final results and celebrations"
            icon={(
              <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            )}
          />
        </div>
      </div>
    </section>
  )
}

export default Schedule


