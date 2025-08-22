import React from 'react'
import horseGates from '../assets/horse-gates.jpg'
import auctionRace from '../assets/dust.jpg'
import wagering from '../assets/two-racers.jpg'
import whyItMatters from '../assets/yes-and-2024.jpg'

export const About: React.FC = () => {
  return (
    <section id="about" className="py-20 bg-noahbrave-50 section-edge">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid lg:grid-cols-2 gap-12 items-center">
          <div>
            <h2 className="font-heading text-4xl md:text-5xl text-gray-900 mb-6">About the Event</h2>
            <p className="text-lg text-gray-700 mb-6">
              Get ready for an unforgettable evening of excitement, entertainment, and generosity. Our Horse Racing Fundraiser combines the thrill of the track with the power of community, all in support of a meaningful cause.
            </p>
            <p className="text-lg text-gray-700 mb-6">
              Proceeds benefit the <a href="https://noahbrave.org" target="_blank" rel="noopener noreferrer" className="text-noahbrave-600 hover:text-noahbrave-700 hover:underline">NoahBRAVE Foundation</a>, which provides personalized support, raises awareness, and funds research for children and families battling terminal brain cancer. By joining us, you help ensure families know they are seen, valued, loved, and never alone in their fight.
            </p>
          </div>
          <div>
            <img 
              src={horseGates} 
              alt="Horse racing gates" 
              className="w-full h-auto rounded-2xl shadow-xl"
            />
          </div>
        </div>
      </div>

      {/* The Races */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mt-20">
        <div className="grid lg:grid-cols-2 gap-12 items-center">
        <div>
            <img 
              src={auctionRace} 
              alt="Auction race excitement" 
              className="w-full h-auto rounded-2xl shadow-xl"
            />
          </div>
          <div>
            <h2 className="font-heading text-4xl md:text-5xl text-gray-900 mb-6">The Races</h2>
            <p className="text-lg text-gray-700 mb-6">
              The heart-pounding action of thoroughbred horse racing will be brought to life through professional race video, hosted and emceed live by Kyle Simmons.
            </p>
            <p className="text-lg text-gray-700 mb-6">
              <strong>Races 1–10:</strong> Each of the first ten races will feature a 10-horse field. Every horse has been purchased and named by an owner in advance, with owners recognized in the official program. A <span className="font-semibold">$60 prize</span> will be awarded to the owner of each winning horse.
            </p>
            <p className="text-lg text-gray-700 mb-6">
              <strong>Race 11: The Auction Race</strong> – In the grand finale, 10 horses will be auctioned off live to the highest bidders. The winning bidder(s) for each horse will become its official owner, representing one of the ten post positions. The owner(s) of the winning horse in Race #11 will receive <span className="font-semibold">half of the total auction proceeds</span> raised that evening!
            </p>
            <p className="text-lg text-gray-700 italic">
              ✨ Pro Tip: Pool your money with friends or your table to bid big on your favorite horse.
            </p>
          </div>
          
        </div>
      </div>

      {/* Wagering */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mt-20">
        <div className="grid lg:grid-cols-2 gap-12 items-center">
          <div>
            <h2 className="font-heading text-4xl md:text-5xl text-gray-900 mb-6">Wagering</h2>
            <p className="text-lg text-gray-700 mb-6">
              Cheer on your favorites and place wagers throughout the night:
            </p>
            <ul className="list-disc list-inside text-lg text-gray-700 mb-6 space-y-2">
              <li>Wagers are available <strong>to WIN only</strong> (no Place or Show betting).</li>
              <li>All wagers must be in <strong>$2 increments</strong> ($2, $4, $6, $8, $10, etc).</li>
            </ul>
          </div>
          <div>
            <img 
              src={wagering} 
              alt="Guests wagering on races" 
              className="w-full h-auto rounded-2xl shadow-xl"
            />
          </div>
        </div>
      </div>

      {/* Why It Matters */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 mt-20">
        <div className="grid lg:grid-cols-2 gap-12 items-center">
        <div>
            <img 
              src={whyItMatters} 
              alt="Family supported by the foundation" 
              className="w-full h-auto rounded-2xl shadow-xl"
            />
          </div>
          <div>
            <h2 className="font-heading text-4xl md:text-5xl text-gray-900 mb-6">Why It Matters</h2>
            <p className="text-lg text-gray-700 mb-6">
              This event is more than just a night at the races—it's a chance to rally together, celebrate, and give hope. With every wager, every bid, and every cheer, you’re helping the NoahBRAVE Foundation continue its mission of standing beside families in their most difficult fight.
            </p>
          </div>
          
        </div>
      </div>
    </section>
  )
}

export default About