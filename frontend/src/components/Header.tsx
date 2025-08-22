import React, { useState } from 'react'
import { Link } from 'react-router-dom'
import Logo from './common/Logo'

export const Header: React.FC = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false)

  return (
    <header className="bg-white/95 backdrop-blur border-b-4 border-noahbrave-600 sticky top-0 z-40">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center py-4">
          <div className="flex items-center">
            <Logo size="md" showBackground={true} className="shadow-md" clickable={true} />
            <div className="ml-3">
              <h1 className="font-heading text-2xl tracking-wide text-gray-900">A Night at the Races</h1>
              <p className="text-xs text-gray-600">NoahBRAVE Foundation</p>
            </div>
          </div>
          
          <div className="md:hidden">
            <button
              onClick={() => setIsMenuOpen(!isMenuOpen)}
              className="text-gray-700 hover:text-noahbrave-600 focus:outline-none"
              aria-label="Toggle navigation"
            >
              <svg className="h-7 w-7" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 6h16M4 12h16M4 18h16" />
              </svg>
            </button>
          </div>

          <nav className="hidden md:flex items-center space-x-8 text-sm">
            <a href="#schedule" className="text-gray-700 hover:text-noahbrave-600 font-medium">Schedule</a>
            <a href="#about" className="text-gray-700 hover:text-noahbrave-600 font-medium">About</a>
            <a href="#location" className="text-gray-700 hover:text-noahbrave-600 font-medium">Location</a>
            <a href="#contact" className="text-gray-700 hover:text-noahbrave-600 font-medium">Contact</a>
            <Link to="/tickets" className="hidden lg:inline-flex items-center cta px-4 py-2 rounded-lg font-semibold shadow-md">Buy Tickets</Link>
          </nav>
        </div>
      </div>

      {isMenuOpen && (
        <div className="md:hidden bg-white border-t border-gray-200 shadow">
          <div className="px-2 pt-2 pb-3 space-y-1">
            <a href="#about" className="block px-3 py-2 text-gray-700 hover:text-noahbrave-600 font-medium">About</a>
            <a href="#schedule" className="block px-3 py-2 text-gray-700 hover:text-noahbrave-600 font-medium">Schedule</a>
            <a href="#contact" className="block px-3 py-2 text-gray-700 hover:text-noahbrave-600 font-medium">Contact</a>
            <Link to="/tickets" className="block px-3 py-2 text-gray-700 hover:text-noahbrave-600 font-medium">Tickets</Link>
          </div>
        </div>
      )}
    </header>
  )
}

export default Header


