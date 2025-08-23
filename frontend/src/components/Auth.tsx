import React, { useEffect, useState } from 'react'
import { useSearchParams, useNavigate } from 'react-router-dom'
import { useMutation } from 'react-relay'
import { validateTokenMutation } from '../graphql/mutations/validateToken'
import type { validateTokenMutation as ValidateTokenMutationType } from '../__generated__/validateTokenMutation.graphql'
import Header from './Header'
import Footer from './Footer'

export const Auth: React.FC = () => {
  const [searchParams] = useSearchParams()
  const navigate = useNavigate()
  const [isValidating, setIsValidating] = useState(true)
  const [error, setError] = useState('')

  const [commit] = useMutation<ValidateTokenMutationType>(validateTokenMutation)

  useEffect(() => {
    const token = searchParams.get('token')
    
    if (!token) {
      setError('No token provided')
      setIsValidating(false)
      return
    }

    commit({
      variables: { token },
      onCompleted: (response, errors) => {
        setIsValidating(false)
        
        if (errors) {
          setError('Token validation failed. Please try again.')
          return
        }

        if (response.validateToken?.success && response.validateToken?.user) {
          const user = response.validateToken.user
          
          // Store user info in localStorage or state management
          localStorage.setItem('user', JSON.stringify(user))
          
          // Check for redirect parameter
          const redirectTo = searchParams.get('redirectTo')
          
          // Redirect based on redirect parameter or user role
          if (user.isAdmin) {
            navigate('/dashboard', { replace: true })
          } else if (redirectTo) {
            navigate(redirectTo, { replace: true })
          } else {
            navigate('/account', { replace: true })
          }
        } else {
          setError(response.validateToken?.message || 'Invalid token')
        }
      },
      onError: (error) => {
        setIsValidating(false)
        setError('Token validation failed. Please try again.')
        console.error('Token validation error:', error)
      }
    })
  }, [searchParams, commit, navigate])

  if (isValidating) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-noahbrave-50 to-white font-body text-gray-800">
        <Header />
        <div className="flex-1 flex items-center justify-center py-20">
          <div className="max-w-md mx-auto text-center">
            <div className="bg-white rounded-2xl p-8 shadow-xl border border-noahbrave-200">
              <div className="w-16 h-16 bg-noahbrave-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <svg className="w-8 h-8 text-noahbrave-600 animate-spin" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                </svg>
              </div>
              <h2 className="font-heading text-2xl text-gray-900 mb-4">Validating Token</h2>
              <p className="text-gray-700">Please wait while we verify your login...</p>
            </div>
          </div>
        </div>
        <Footer />
      </div>
    )
  }

  if (error) {
    return (
      <div className="min-h-screen bg-gradient-to-b from-noahbrave-50 to-white font-body text-gray-800">
        <Header />
        <div className="flex-1 flex items-center justify-center py-20">
          <div className="max-w-md mx-auto text-center">
            <div className="bg-white rounded-2xl p-8 shadow-xl border border-noahbrave-200">
              <div className="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <svg className="w-8 h-8 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                </svg>
              </div>
              <h2 className="font-heading text-2xl text-gray-900 mb-4">Authentication Failed</h2>
              <p className="text-gray-700 mb-6">{error}</p>
              <a 
                href="/login" 
                className="inline-block cta px-6 py-3 rounded-lg font-semibold hover:brightness-95 transition-colors duration-200"
              >
                Try Again
              </a>
            </div>
          </div>
        </div>
        <Footer />
      </div>
    )
  }

  return null
}

export default Auth
