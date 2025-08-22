import React, { useState } from 'react'
import { useMutation } from 'react-relay'
import { loginMutation } from '../graphql/mutations/login'
import type { loginMutation as LoginMutationType } from '../__generated__/loginMutation.graphql'
import Header from './Header'
import Footer from './Footer'

export const Login: React.FC = () => {
  const [email, setEmail] = useState('')
  const [isSubmitted, setIsSubmitted] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState('')

  const [commit] = useMutation<LoginMutationType>(loginMutation)

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsLoading(true)
    setError('')

    commit({
      variables: { email },
      onCompleted: (response, errors) => {
        setIsLoading(false)
        if (errors) {
          setError('An error occurred. Please try again.')
          return
        }
        if (response.login?.success) {
          setIsSubmitted(true)
        } else {
          setError(response.login?.message || 'Login failed. Please try again.')
        }
      },
      onError: (error) => {
        setIsLoading(false)
        setError('An error occurred. Please try again.')
        console.error('Login error:', error)
      }
    })
  }

  if (isSubmitted) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-noahbrave-50 to-white font-body text-gray-800">
        <Header />
        <div className="flex-1 flex items-center justify-center py-20">
          <div className="max-w-md mx-auto text-center">
            <div className="bg-white rounded-2xl p-8 shadow-xl border border-noahbrave-200">
              <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <svg className="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 8l7.89 4.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                </svg>
              </div>
              <h2 className="font-heading text-2xl text-gray-900 mb-4">Check Your Email</h2>
              <p className="text-gray-700 mb-6">
                We've sent a login link to <span className="font-semibold">{email}</span>. 
                Please check your email and click on the link to complete your login.
              </p>
              <p className="text-sm text-gray-500">
                Don't see the email? Check your spam folder.
              </p>
            </div>
          </div>
        </div>
        <Footer />
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-noahbrave-50 to-white font-body text-gray-800">
      <Header />
      <div className="flex-1 flex items-center justify-center py-20">
        <div className="max-w-md mx-auto">
          <div className="bg-white rounded-2xl p-8 shadow-xl border border-noahbrave-200">
            <div className="text-center mb-8">
              <h1 className="font-heading text-3xl text-gray-900 mb-2">Login</h1>
              <p className="text-gray-600">Enter your email to receive a login link</p>
            </div>

            <form onSubmit={handleSubmit} className="space-y-6">
              <div>
                <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-2">
                  Email Address
                </label>
                <input
                  type="email"
                  id="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-noahbrave-500 focus:border-noahbrave-500 transition-colors"
                  placeholder="Enter your email"
                  disabled={isLoading}
                />
              </div>

              {error && (
                <div className="bg-red-50 border border-red-200 rounded-lg p-4">
                  <p className="text-red-700 text-sm">{error}</p>
                </div>
              )}

              <button
                type="submit"
                disabled={isLoading || !email.trim()}
                className="w-full cta px-6 py-3 rounded-lg font-semibold disabled:opacity-50 disabled:cursor-not-allowed hover:brightness-95 transition-all duration-200"
              >
                {isLoading ? 'Sending...' : 'Send Login Link'}
              </button>
            </form>

            <div className="mt-6 text-center">
              <p className="text-sm text-gray-500">
                Don't have an account?{' '}
                <a href="/" className="text-noahbrave-600 hover:text-noahbrave-700 hover:underline">
                  Return to home
                </a>
              </p>
            </div>
          </div>
        </div>
      </div>
      <Footer />
    </div>
  )
}

export default Login
