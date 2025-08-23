import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import Header from './Header'
import Footer from './Footer'
import { useLogout } from '../utils/auth'

interface User {
  id: string
  email: string
  firstName: string
  lastName: string
  isAdmin: boolean
}

export const Dashboard: React.FC = () => {
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
      if (!userObj.isAdmin) {
        navigate('/account', { replace: true })
        return
      }
      setUser(userObj)
    } catch (error) {
      navigate('/login', { replace: true })
    }
  }, [navigate])

  const handleLogout = () => {
    logout('/login?redirectTo=/dashboard')
  }

  if (!user) {
    return null
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-noahbrave-50 to-white font-body text-gray-800">
      <Header />
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-20">
        <div className="text-center mb-12">
          <h1 className="font-heading text-4xl md:text-5xl text-gray-900 mb-4">Admin Dashboard</h1>
          <p className="text-lg text-gray-700">Welcome back, {user.firstName}!</p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6">
          {/* Event Overview Card */}
          <div className="bg-white rounded-2xl p-6 shadow-xl border border-noahbrave-200">
            <div className="w-14 h-14 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <svg className="w-7 h-7 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
              </svg>
            </div>
            <h3 className="font-heading text-lg text-gray-900 mb-3">Event Overview</h3>
            <p className="text-gray-700 mb-4 text-sm">Monitor ticket sales and horse racing information.</p>
            <button className="w-full bg-blue-600 text-white px-3 py-2 rounded-lg hover:bg-blue-700 transition-colors text-sm">
              View Details
            </button>
          </div>

          {/* User Management Card */}
          <div className="bg-white rounded-2xl p-6 shadow-xl border border-noahbrave-200">
            <div className="w-14 h-14 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <svg className="w-7 h-7 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z" />
              </svg>
            </div>
            <h3 className="font-heading text-lg text-gray-900 mb-3">User Management</h3>
            <p className="text-gray-700 mb-4 text-sm">Manage user accounts, permissions, and access controls.</p>
            <button className="w-full bg-green-600 text-white px-3 py-2 rounded-lg hover:bg-green-700 transition-colors text-sm">
              Manage Users
            </button>
          </div>

          {/* Payment Management Card */}
          <div className="bg-white rounded-2xl p-6 shadow-xl border border-noahbrave-200">
            <div className="w-14 h-14 bg-yellow-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <svg className="w-7 h-7 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z" />
              </svg>
            </div>
            <h3 className="font-heading text-lg text-gray-900 mb-3">Payment Management</h3>
            <p className="text-gray-700 mb-4 text-sm">Mark bills as paid, track payments, and manage financial records.</p>
            <button className="w-full bg-yellow-600 text-white px-3 py-2 rounded-lg hover:bg-yellow-700 transition-colors text-sm">
              Manage Payments
            </button>
          </div>

          {/* Reports Card */}
          <div className="bg-white rounded-2xl p-6 shadow-xl border border-noahbrave-200">
            <div className="w-14 h-14 bg-purple-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <svg className="w-7 h-7 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2zm0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
              </svg>
            </div>
            <h3 className="font-heading text-lg text-gray-900 mb-3">Reports & Analytics</h3>
            <p className="text-gray-700 mb-4 text-sm">Generate reports, view analytics, and export data.</p>
            <button className="w-full bg-purple-600 text-white px-3 py-2 rounded-lg hover:bg-purple-700 transition-colors text-sm">
              View Reports
            </button>
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

export default Dashboard
