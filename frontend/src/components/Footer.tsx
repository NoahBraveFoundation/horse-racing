import React from 'react'
import nbf from '../assets/nbf.webp'

export const Footer: React.FC = () => {
  return (
    <footer className="bg-noahbrave-800py-12 mt-16">
      <div className="border-t border-noahbrave-700 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center">
          <div className="mb-8">
            <div className="w-16 h-16 bg-white rounded-full flex items-center justify-center mx-auto shadow">
              <img src={nbf} alt="NoahBRAVE Foundation" className="w-full h-full object-contain" />
            </div>
          </div>
        </div>
      </div>
    </footer>
  )
}

export default Footer


