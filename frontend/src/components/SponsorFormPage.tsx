import { type FormEvent, useState } from 'react'
import Header from './Header'
import Footer from './Footer'

const SponsorFormPage = () => {
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [companyInfo, setCompanyInfo] = useState('')
  const [submitting, setSubmitting] = useState(false)
  const [status, setStatus] = useState<'idle' | 'success' | 'error'>('idle')

  const sponsorMutation = `
    mutation SubmitSponsorInterest($name: String!, $email: String!, $companyInfo: String!) {
      submitSponsorInterest(name: $name, email: $email, companyInfo: $companyInfo) {
        id
      }
    }
  `

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    setSubmitting(true)
    setStatus('idle')

    try {
      const response = await fetch('/graphql', {
        method: 'POST',
        credentials: 'include',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          query: sponsorMutation,
          variables: {
            name,
            email,
            companyInfo,
          },
        }),
      })

      if (!response.ok) {
        throw new Error('Failed to submit sponsor request')
      }

      const result = await response.json()

      if (result.errors?.length) {
        throw new Error(result.errors[0]?.message ?? 'Failed to submit sponsor request')
      }

      if (!result.data?.submitSponsorInterest?.id) {
        throw new Error('Failed to submit sponsor request')
      }

      setStatus('success')
      setName('')
      setEmail('')
      setCompanyInfo('')
    } catch (error) {
      console.error(error)
      setStatus('error')
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-noahbrave-50 to-white font-body text-gray-800">
      <div className="checker-top h-3" style={{ backgroundColor: 'var(--brand)' }} />
      <Header />

      <main className="py-16 px-4">
        <div className="max-w-2xl mx-auto bg-white rounded-2xl shadow-xl border border-noahbrave-200 p-8">
          <h1 className="font-heading text-3xl text-gray-900 mb-6">Become a Sponsor</h1>
          <p className="text-gray-700 mb-8">
            Share your information below and we&apos;ll follow up with the next steps to confirm your sponsorship.
          </p>

          <form className="space-y-6" onSubmit={handleSubmit}>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2" htmlFor="name">
                Name
              </label>
              <input
                id="name"
                type="text"
                className="w-full border border-noahbrave-200 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-noahbrave-500"
                value={name}
                onChange={(event) => setName(event.target.value)}
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2" htmlFor="email">
                Email
              </label>
              <input
                id="email"
                type="email"
                className="w-full border border-noahbrave-200 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-noahbrave-500"
                value={email}
                onChange={(event) => setEmail(event.target.value)}
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2" htmlFor="companyInfo">
                Company Sponsor Info
              </label>
              <textarea
                id="companyInfo"
                className="w-full border border-noahbrave-200 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-noahbrave-500"
                rows={4}
                value={companyInfo}
                onChange={(event) => setCompanyInfo(event.target.value)}
              />
            </div>

            <button
              type="submit"
              className="cta px-6 py-3 rounded-lg font-semibold hover:brightness-95 transition-colors duration-200"
              disabled={submitting}
            >
              {submitting ? 'Submitting...' : 'Submit'}
            </button>
          </form>

          {status === 'success' && (
            <p className="mt-6 text-noahbrave-600">Thank you! We&apos;ll be in touch soon.</p>
          )}

          {status === 'error' && (
            <p className="mt-6 text-red-600">Something went wrong. Please try again later.</p>
          )}
        </div>
      </main>

      <Footer />
    </div>
  )
}

export default SponsorFormPage
