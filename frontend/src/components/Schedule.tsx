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
        <div className="grid md:grid-cols-3 gap-8">
          <Item
            time="6:00 PM"
            title="Event Opens"
            subtitle="Doors open, registration & welcome drinks"
            icon={(
              <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            )}
          />
          <Item
            time="6:45 PM"
            title="Dinner"
            subtitle="Delicious meal included with your ticket"
            icon={(
              <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 3h2l.4 2M7 13h10l4-8H5.4m0 0L7 13m0 0l-2.5 5M7 13l2.5 5m6-5v6a2 2 0 01-2 2H9a2 2 0 01-2-2v-6m6 0V9a2 2 0 00-2-2H9a2 2 0 00-2 2v4.01" />
              </svg>
            )}
          />
          <Item
            time="8:00 PM"
            title="Races Begin"
            subtitle="The main event - exciting horse racing action!"
            icon={(
              <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 10V3L4 14h7v7l9-11h-7z" />
              </svg>
            )}
          />
        </div>
      </div>
    </section>
  )
}

export default Schedule


