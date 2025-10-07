import React from 'react'
import SectionHeading from './SectionHeading'

export const Contact: React.FC = () => {
  return (
    <section id="contact" className="py-20 bg-noahbrave-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <SectionHeading title="For Information & Purchasing" />
        <div className="max-w-4xl mx-auto">
          <div className="bg-white rounded-2xl p-12 shadow-xl border border-noahbrave-200">
            <div className="grid md:grid-cols-2 gap-12">
              <div>
                <h3 className="font-heading text-2xl text-gray-900 mb-6">Get in Touch</h3>
                <div className="space-y-6">
                  <div className="flex items-start">
                    <div className="w-12 h-12 bg-noahbrave-600 rounded-full flex items-center justify-center mr-4 flex-shrink-0">
                      <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                      </svg>
                    </div>
                    <div>
                      <p className="font-semibold text-gray-900">Christy Lukasik</p>
                      <a href="mailto:christylukasik@comcast.net" className="text-noahbrave-600 hover:text-noahbrave-700 hover:underline">christylukasik@comcast.net</a>
                      <p className="text-gray-700">(586) 871-5698</p>
                    </div>
                  </div>
                  <div className="flex items-start">
                    <div className="w-12 h-12 bg-noahbrave-600 rounded-full flex items-center justify-center mr-4 flex-shrink-0">
                      <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                      </svg>
                    </div>
                    <div>
                      <p className="font-semibold text-gray-900">Gina Evans</p>
                      <a href="mailto:gina.evans@uticak12.org" className="text-noahbrave-600 hover:text-noahbrave-700 hover:underline">gina.evans@uticak12.org</a>
                      <p className="text-gray-700">(586) 383-1258</p>
                    </div>
                  </div>
                </div>
              </div>
              <div>
                <h3 className="font-heading text-2xl text-gray-900 mb-6">Online Ticket Purchase</h3>
                <p className="text-gray-700 mb-6">Purchase your tickets online for the fastest and most convenient experience.</p>
                <a href="/tickets" className="inline-block cta px-6 py-3 rounded-lg font-semibold hover:brightness-95 transition-colors duration-200">Buy Tickets</a>
                <div className="mt-4">
                  <a href="/sponsor" className="text-noahbrave-600 hover:text-noahbrave-700 hover:underline">
                    Become a Sponsor
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}

export default Contact


