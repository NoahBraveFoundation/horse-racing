import React from 'react'
import { Link } from 'react-router-dom'

export const MobileCTA: React.FC = () => (
  <div className="md:hidden fixed bottom-4 inset-x-4 z-50">
    <Link to="/tickets" className="block text-center cta px-6 py-4 rounded-xl font-bold shadow-xl">Buy Tickets • $75</Link>
  </div>
)

export default MobileCTA


