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
                <div className="space-y-4">
                  <div className="flex items-center">
                    <div className="w-12 h-12 bg-noahbrave-600 rounded-full flex items-center justify-center mr-4">
                      <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 8l7.89 4.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                      </svg>
                    </div>
                    <div>
                      <p className="font-semibold text-gray-900">Email</p>
                      <p className="text-gray-600">info@noahbrave.org</p>
                    </div>
                  </div>
                  <div className="flex items-center">
                    <div className="w-12 h-12 bg-noahbrave-600 rounded-full flex items-center justify-center mr-4">
                      <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9v-9m0-9v9" />
                      </svg>
                    </div>
                    <div>
                      <p className="font-semibold text-gray-900">Website</p>
                      <a href="https://noahbrave.org" className="text-noahbrave-600 hover:text-noahbrave-700">noahbrave.org</a>
                    </div>
                  </div>
                </div>
              </div>
              <div>
                <h3 className="font-heading text-2xl text-gray-900 mb-6">Online Ticket Purchase</h3>
                <p className="text-gray-700 mb-6">Purchase your tickets online for the fastest and most convenient experience.</p>
                <a href="/tickets" className="inline-block cta px-6 py-3 rounded-lg font-semibold hover:brightness-95 transition-colors duration-200">Buy Tickets</a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}

export default Contact


