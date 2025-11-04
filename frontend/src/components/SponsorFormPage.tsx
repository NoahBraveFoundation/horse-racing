import { type FormEvent, useMemo, useRef, useState } from 'react'
import Header from './Header'
import Footer from './Footer'
import { getApiUrl } from '../utils/api'

const SponsorFormPage = () => {
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [companyName, setCompanyName] = useState('')
  const [amount, setAmount] = useState('')
  const [logoBase64, setLogoBase64] = useState<string | null>(null)
  const [uploadError, setUploadError] = useState<string | null>(null)
  const [dragActive, setDragActive] = useState(false)
  const fileInputRef = useRef<HTMLInputElement>(null)
  const [submitting, setSubmitting] = useState(false)
  const [status, setStatus] = useState<'idle' | 'success' | 'error'>('idle')
  const [submittedDetails, setSubmittedDetails] = useState<{
    name: string
    companyName: string
    amountUsd: number
  } | null>(null)

  const currencyFormatter = useMemo(
    () =>
      new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD',
        minimumFractionDigits: 2,
      }),
    [],
  )

  const venmoUser = 'Gina-Evans-34'
  const venmoLastFour = '1258'

  const sponsorMutation = `
    mutation SubmitSponsorInterest($name: String!, $email: String!, $companyName: String!, $amountUsd: Float!, $companyLogoBase64: String) {
      submitSponsorInterest(name: $name, email: $email, companyName: $companyName, amountUsd: $amountUsd, companyLogoBase64: $companyLogoBase64) {
        id
      }
    }
  `

  const fileToBase64 = (file: File) =>
    new Promise<string>((resolve, reject) => {
      const reader = new FileReader()
      reader.onload = () => resolve(reader.result as string)
      reader.onerror = reject
      reader.readAsDataURL(file)
    })

  const handleFile = async (file: File) => {
    setUploadError(null)
    if (!file.type.startsWith('image/')) {
      setUploadError('Please upload an image file (PNG, JPG, SVG, etc).')
      return
    }
    if (file.size > 5 * 1024 * 1024) {
      setUploadError('File is too large. Max size is 5MB.')
      return
    }

    try {
      const base64 = await fileToBase64(file)
      setLogoBase64(base64)
    } catch (error) {
      console.error(error)
      setUploadError('Something went wrong while reading that file.')
    }
  }

  const onFileChange: React.ChangeEventHandler<HTMLInputElement> = async (event) => {
    const file = event.target.files?.[0]
    if (!file) return
    await handleFile(file)
  }

  const onDrop: React.DragEventHandler<HTMLDivElement> = async (event) => {
    event.preventDefault()
    event.stopPropagation()
    setDragActive(false)
    if (event.dataTransfer.files && event.dataTransfer.files.length > 0) {
      const file = event.dataTransfer.files[0]
      await handleFile(file)
      event.dataTransfer.clearData()
    }
  }

  const handleSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    setSubmitting(true)
    setStatus('idle')
    setSubmittedDetails(null)

    const trimmedName = name.trim()
    const trimmedEmail = email.trim()
    const trimmedCompany = companyName.trim()
    const parsedAmount = Number.parseFloat(amount)
    const amountUsd = Number.isFinite(parsedAmount) ? Math.max(0, parsedAmount) : 0

    try {
      const response = await fetch(getApiUrl(), {
        method: 'POST',
        credentials: 'include',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          query: sponsorMutation,
          variables: {
            name: trimmedName || name,
            email: trimmedEmail,
            companyName: trimmedCompany || companyName,
            amountUsd,
            companyLogoBase64: logoBase64,
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
      setSubmittedDetails({
        name: trimmedName || name,
        companyName: trimmedCompany || companyName,
        amountUsd,
      })
      setName('')
      setEmail('')
      setCompanyName('')
      setAmount('')
      setLogoBase64(null)
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

          {status !== 'success' ? (
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
              <label className="block text-sm font-medium text-gray-700 mb-2" htmlFor="companyName">
                Company name
              </label>
              <input
                id="companyName"
                type="text"
                className="w-full border border-noahbrave-200 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-noahbrave-500"
                value={companyName}
                onChange={(event) => setCompanyName(event.target.value)}
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2" htmlFor="amount">
                Amount (USD)
              </label>
              <input
                id="amount"
                type="number"
                min={0}
                step="0.01"
                className="w-full border border-noahbrave-200 rounded-lg px-4 py-3 focus:outline-none focus:ring-2 focus:ring-noahbrave-500"
                value={amount}
                onChange={(event) => setAmount(event.target.value)}
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">Company logo</label>
              <div
                onDragOver={(event) => {
                  event.preventDefault()
                  event.stopPropagation()
                  setDragActive(true)
                }}
                onDragEnter={(event) => {
                  event.preventDefault()
                  event.stopPropagation()
                  setDragActive(true)
                }}
                onDragLeave={(event) => {
                  event.preventDefault()
                  event.stopPropagation()
                  setDragActive(false)
                }}
                onDrop={onDrop}
                onClick={() => fileInputRef.current?.click()}
                className={`relative flex flex-col items-center justify-center rounded-xl border-2 border-dashed p-6 text-center cursor-pointer transition ${dragActive ? 'border-noahbrave-500 bg-noahbrave-50' : 'border-noahbrave-200 hover:border-noahbrave-400'}`}
                aria-label="Upload company logo by clicking or dragging a file"
              >
                {!logoBase64 ? (
                  <>
                    <div className="text-gray-700">
                      <div className="text-sm font-medium">Drag & drop your logo here</div>
                      <div className="text-xs text-gray-500 mt-1">or click to browse (PNG, JPG, SVG • up to 5MB)</div>
                    </div>
                  </>
                ) : (
                  <div className="w-full max-w-xs">
                    <img
                      src={logoBase64}
                      alt="Company logo preview"
                      className="h-24 w-auto mx-auto object-contain rounded-md border border-gray-200 bg-white p-2"
                    />
                    <div className="mt-3 flex items-center justify-center gap-3">
                      <button
                        type="button"
                        onClick={(event) => {
                          event.stopPropagation()
                          fileInputRef.current?.click()
                        }}
                        className="px-3 py-1.5 text-sm rounded-md border text-gray-700 hover:bg-gray-50"
                      >
                        Replace logo
                      </button>
                      <button
                        type="button"
                        onClick={(event) => {
                          event.stopPropagation()
                          setLogoBase64(null)
                        }}
                        className="px-3 py-1.5 text-sm rounded-md border text-red-600 hover:bg-red-50"
                      >
                        Remove
                      </button>
                    </div>
                  </div>
                )}

                <input
                  ref={fileInputRef}
                  type="file"
                  accept="image/*"
                  className="hidden"
                  onChange={onFileChange}
                />
              </div>
              {uploadError && <p className="mt-2 text-sm text-red-600">{uploadError}</p>}
            </div>

              <button
                type="submit"
                className="cta px-6 py-3 rounded-lg font-semibold hover:brightness-95 transition-colors duration-200"
                disabled={submitting}
              >
                {submitting ? 'Submitting...' : 'Submit'}
              </button>
            </form>
          ) : (
            <VenmoSuccess
              details={submittedDetails}
              currencyFormatter={currencyFormatter}
              venmoUser={venmoUser}
              venmoLastFour={venmoLastFour}
              onReset={() => {
                setStatus('idle')
                setSubmittedDetails(null)
                setUploadError(null)
              }}
            />
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

type VenmoSuccessProps = {
  details: {
    name: string
    companyName: string
    amountUsd: number
  } | null
  currencyFormatter: Intl.NumberFormat
  venmoUser: string
  venmoLastFour: string
  onReset: () => void
}

const VenmoSuccess = ({ details, currencyFormatter, venmoUser, venmoLastFour, onReset }: VenmoSuccessProps) => {
  const sponsorName = details?.name?.trim() || 'Sponsor'
  const companyName = details?.companyName?.trim() || ''
  const amount = details?.amountUsd ?? 0
  const formattedAmount = currencyFormatter.format(amount)

  const venmoLink = (() => {
    try {
      const baseUrl = new URL(`https://venmo.com/${venmoUser}`)
      baseUrl.searchParams.set('txn', 'pay')
      if (amount > 0) {
        baseUrl.searchParams.set('amount', amount.toFixed(2))
      }
      const noteParts = ['Noah Brave Foundation Sponsor']
      if (companyName) {
        noteParts.push(companyName)
      }
      baseUrl.searchParams.set('note', noteParts.join(' - '))
      return baseUrl.toString()
    } catch (error) {
      console.error('Failed to build Venmo link', error)
      return `https://venmo.com/${venmoUser}`
    }
  })()

  return (
    <div className="text-center space-y-6">
      <h2 className="font-heading text-3xl text-gray-900">Thank you, {sponsorName}!</h2>
      <p className="text-gray-700">
        We&apos;re excited to partner with you{companyName ? ` at ${companyName}` : ''}. To lock in your sponsorship, please send your
        contribution via Venmo below. We&apos;ll reach out shortly with next steps.
      </p>

      <div className="bg-noahbrave-50 border border-noahbrave-200 rounded-xl p-6 space-y-4">
        <div>
          <p className="text-sm uppercase tracking-wide text-noahbrave-500">Amount</p>
          <p className="text-2xl font-semibold text-gray-900">{formattedAmount}</p>
        </div>
        <div className="text-gray-700 space-y-1">
          <p>
            Venmo: <span className="font-medium">@{venmoUser}</span>
          </p>
          <p>Last 4 digits of phone: {venmoLastFour}</p>
          {companyName && <p>Memo suggestion: {companyName}</p>}
        </div>
        <a
          href={venmoLink}
          target="_blank"
          rel="noreferrer"
          className="cta inline-block px-6 py-3 rounded-lg font-semibold hover:brightness-95 transition-colors duration-200"
        >
          Open Venmo
        </a>
        <p className="text-sm text-gray-500">
          Prefer a different payment method? Reply to our confirmation email and we&apos;ll coordinate the best option for you.
        </p>
      </div>

      <button
        type="button"
        onClick={onReset}
        className="px-5 py-2 rounded-lg border text-gray-700 hover:bg-gray-50"
      >
        Submit another sponsorship
      </button>
    </div>
  )
}

export default SponsorFormPage
