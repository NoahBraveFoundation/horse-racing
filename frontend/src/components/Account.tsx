import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useLazyLoadQuery, graphql } from 'react-relay'
import Header from './Header'
import Footer from './Footer'
import AccountBoard from './horse-board/AccountBoard'
import ErrorBoundary from './common/ErrorBoundary'
import { useLogout } from '../utils/auth'

interface User {
  id: string
  email: string
  firstName: string
  lastName: string
  isAdmin: boolean
}

const AccountQuery = graphql`
  query AccountQuery {
    myCart {
      id
      tickets { id attendeeFirst attendeeLast costCents }
      horses { id horseName ownershipLabel costCents }
      cost {
        ticketsCents
        horseCents
        totalCents
      }
    }
  }
`;

const RedirectToLoginFallback: React.FC = () => {
  const navigate = useNavigate()
  useEffect(() => {
    navigate('/login?redirectTo=/account', { replace: true })
  }, [navigate])
  return null
}

export const Account: React.FC = () => {
  const navigate = useNavigate()
  const [user, setUser] = useState<User | null>(null)
  const { logout } = useLogout()

  useEffect(() => {
    const userData = localStorage.getItem('user')
    
    if (!userData) {
      navigate('/login', { replace: true })
      return
    }

    try {
      const userObj = JSON.parse(userData)
      setUser(userObj)
    } catch (error) {
      navigate('/login', { replace: true })
    }
  }, [navigate])

  const handleLogout = () => {
    logout('/login?redirectTo=/account')
  }

  if (!user) {
    return null
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-noahbrave-50 to-white font-body text-gray-800">
      <Header />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
        <div className="text-center mb-12">
          <h1 className="font-heading text-4xl md:text-5xl text-gray-900 mb-4">My Account</h1>
          <p className="text-lg text-gray-700">Welcome back, {user.firstName}!</p>
        </div>

        <div className="grid lg:grid-cols-3 gap-8">
          {/* Profile Information */}
          <div className="lg:col-span-1">
            <div className="bg-white rounded-2xl p-8 shadow-xl border border-noahbrave-200">
              <div className="w-20 h-20 bg-noahbrave-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <svg className="w-10 h-10 text-noahbrave-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                </svg>
              </div>
              <h3 className="font-heading text-xl text-gray-900 mb-4 text-center">Profile Information</h3>
              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">First Name</label>
                  <p className="text-gray-900 font-medium">{user.firstName}</p>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Last Name</label>
                  <p className="text-gray-900 font-medium">{user.lastName}</p>
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
                  <p className="text-gray-900 font-medium">{user.email}</p>
                </div>
              </div>
            </div>

            {/* Tickets Section */}
            <div className="bg-white rounded-2xl p-8 shadow-xl border border-noahbrave-200 mt-6">
              <h3 className="font-heading text-xl text-gray-900 mb-4 text-center">My Tickets</h3>
              <AccountTickets />
            </div>
          </div>

          {/* Horse Board */}
          <div className="lg:col-span-2">
            <ErrorBoundary fallback={<RedirectToLoginFallback />}>
              <AccountBoard />
            </ErrorBoundary>
          </div>
        </div>

        {/* Logout Section */}
        <div className="text-center mt-12">
          <button
            onClick={handleLogout}
            className="inline-flex items-center px-6 py-3 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50 transition-colors"
          >
            <svg className="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
            </svg>
            Logout
          </button>
        </div>
      </div>
      <Footer />
    </div>
  )
}

// Separate component for tickets to use Relay query
const AccountTickets: React.FC = () => {
  const data = useLazyLoadQuery(AccountQuery, {});
  const tickets = data?.myCart?.tickets ?? [];
  const totalCost = (data?.myCart?.cost?.totalCents ?? 0) / 100;

  if (tickets.length === 0) {
    return (
      <div className="text-center py-6">
        <p className="text-gray-500 text-sm">No tickets purchased yet.</p>
        <p className="text-gray-400 text-xs mt-1">Your tickets will appear here after purchase.</p>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      {tickets.map((ticket: any) => (
        <div key={ticket.id} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
          <div>
            <div className="font-medium text-gray-900">
              {ticket.attendeeFirst} {ticket.attendeeLast}
            </div>
            <div className="text-sm text-gray-600">Event Ticket</div>
          </div>
          <div className="text-right">
            <div className="font-semibold text-gray-900">${(ticket.costCents / 100).toFixed(2)}</div>
          </div>
        </div>
      ))}
      <div className="pt-3 border-t border-gray-200">
        <div className="flex justify-between items-center">
          <span className="font-medium text-gray-700">Total</span>
          <span className="font-bold text-lg text-gray-900">${totalCost.toFixed(2)}</span>
        </div>
      </div>
    </div>
  );
};

export default Account
