import React from 'react'
import { Link } from 'react-router-dom'

export const MobileCTA: React.FC = () => (
  <div className="md:hidden sticky bottom-0 z-50 p-4">
    <Link
      to="/tickets"
      className="block w-full text-center cta px-6 py-4 rounded-xl font-bold shadow-xl"
    >
      Buy Tickets • $75
    </Link>
  </div>
)

export default MobileCTA


