import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'

type FormState = {
  firstName: string
  lastName: string
  email: string
}

const initialState: FormState = { firstName: '', lastName: '', email: '' }

const TicketFlow: React.FC = () => {
  const [values, setValues] = useState<FormState>(initialState)
  const [touched, setTouched] = useState<Record<keyof FormState, boolean>>({ firstName: false, lastName: false, email: false })
  const navigate = useNavigate()

  const onChange: React.ChangeEventHandler<HTMLInputElement> = (e) => {
    const { name, value } = e.target
    setValues((v) => ({ ...v, [name]: value }))
  }

  const onBlur: React.FocusEventHandler<HTMLInputElement> = (e) => {
    const { name } = e.target
    setTouched((t) => ({ ...t, [name]: true }))
  }

  const emailValid = /.+@.+\..+/.test(values.email)
  const firstValid = values.firstName.trim().length > 1
  const lastValid = values.lastName.trim().length > 1
  const formValid = emailValid && firstValid && lastValid

  const handleSubmit: React.FormEventHandler<HTMLFormElement> = (e) => {
    e.preventDefault()
    setTouched({ firstName: true, lastName: true, email: true })
    if (!formValid) return
    // Placeholder for next step navigation
    navigate('/')
  }

  return (
    <div className="min-h-screen bg-noahbrave-50 font-body">
      <div className="checker-top h-3" style={{ backgroundColor: 'var(--brand)' }} />
      <div className="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="mb-8 text-center">
          <h1 className="font-heading text-4xl md:text-5xl text-gray-900">Buy Tickets</h1>
          <p className="text-gray-600 mt-2">Step 1 of 3 — Your details</p>
        </div>

        <form onSubmit={handleSubmit} className="bg-white rounded-2xl shadow-xl border border-noahbrave-200 p-8">
          <div className="grid md:grid-cols-2 gap-6">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1" htmlFor="firstName">First name</label>
              <input id="firstName" name="firstName" value={values.firstName} onChange={onChange} onBlur={onBlur}
                     className={`w-full rounded-lg border px-4 py-3 focus:outline-none focus:ring-2 focus:ring-noahbrave-600 ${touched.firstName && !firstValid ? 'border-red-500' : 'border-gray-300'}`} />
              {touched.firstName && !firstValid && <p className="text-sm text-red-600 mt-1">Please enter your first name</p>}
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1" htmlFor="lastName">Last name</label>
              <input id="lastName" name="lastName" value={values.lastName} onChange={onChange} onBlur={onBlur}
                     className={`w-full rounded-lg border px-4 py-3 focus:outline-none focus:ring-2 focus:ring-noahbrave-600 ${touched.lastName && !lastValid ? 'border-red-500' : 'border-gray-300'}`} />
              {touched.lastName && !lastValid && <p className="text-sm text-red-600 mt-1">Please enter your last name</p>}
            </div>
          </div>

          <div className="mt-6">
            <label className="block text-sm font-medium text-gray-700 mb-1" htmlFor="email">Email</label>
            <input id="email" name="email" type="email" value={values.email} onChange={onChange} onBlur={onBlur}
                   className={`w-full rounded-lg border px-4 py-3 focus:outline-none focus:ring-2 focus:ring-noahbrave-600 ${touched.email && !emailValid ? 'border-red-500' : 'border-gray-300'}`} />
            {touched.email && !emailValid && <p className="text-sm text-red-600 mt-1">Please enter a valid email</p>}
          </div>

          <div className="flex items-center justify-between mt-8">
            <button type="button" onClick={() => navigate('/')} className="px-5 py-3 rounded-lg border text-gray-700 hover:bg-gray-50">Cancel</button>
            <button type="submit" disabled={!formValid} className="cta px-6 py-3 rounded-lg font-semibold disabled:opacity-50">Continue</button>
          </div>
        </form>
      </div>
    </div>
  )
}

export default TicketFlow


