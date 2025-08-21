import React from 'react'

export const About: React.FC = () => {
  return (
    <section id="about" className="py-20 bg-noahbrave-50 section-edge">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid lg:grid-cols-2 gap-12 items-start">
          <div>
            <h2 className="font-heading text-4xl md:text-5xl text-gray-900 mb-6">About the Event</h2>
            <p className="text-lg text-gray-700 mb-6">
              The thrill of the track awaits you! Experience the adrenaline of horse racing to raise money for childhood cancer.
            </p>
            <p className="text-lg text-gray-700 mb-6">
              Join us for an unforgettable evening of excitement and entertainment while supporting a great cause. 
              Our horse racing fundraiser brings together the thrill of the track with the joy of giving back.
            </p>
            <p className="text-lg text-gray-700 mb-6">
              All proceeds go directly to the NoahBRAVE Foundation, providing personalized support, raising awareness, and funding research for kids and their families battling terminal brain cancer. Your participation helps families know they are seen, valued, loved, and not alone in their fight.
            </p>
          </div>
          
          <div>
            <div className="bg-white p-8 rounded-2xl shadow-xl border border-noahbrave-200">
              <div className="text-center mb-6">
                <div className="w-16 h-16 bg-noahbrave-600 rounded-full flex items-center justify-center mx-auto mb-4">
                  <svg className="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
                <h3 className="font-heading text-2xl text-gray-900">What's Included</h3>
              </div>
              <ul className="space-y-3 text-gray-700">
                {['Full dinner service','Beverages and refreshments','Racing program and betting slips','Entertainment throughout the evening'].map((text) => (
                  <li key={text} className="flex items-center">
                    <svg className="w-5 h-5 text-noahbrave-600 mr-3" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd" />
                    </svg>
                    {text}
                  </li>
                ))}
              </ul>
            </div>
          </div>
        </div>
      </div>
    </section>
  )
}

export default About


