import React from 'react'
import Logo from './common/Logo'

export const Footer: React.FC = () => {
  return (
    <footer className="bg-noahbrave-800 py-12">
      <div className="border-t border-noahbrave-700 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mt-8">
          <div className="mb-8">
            <Logo size="lg" showBackground={true} className="mx-auto" clickable={true} />
          </div>
        </div>
      </div>
    </footer>
  )
}

export default Footer


