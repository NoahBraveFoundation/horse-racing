import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.tsx'
import { createBrowserRouter, RouterProvider, Navigate } from 'react-router-dom'
import TicketFlow from './components/ticket-flow/TicketFlow.tsx'
import TicketFlowError from './components/ticket-flow/TicketFlowError.tsx'
import Login from './components/Login.tsx'
import Auth from './components/Auth.tsx'
import Dashboard from './components/Dashboard.tsx'
import Account from './components/Account.tsx'
import AdminUser from './components/admin/AdminUser'
import SponsorFormPage from './components/SponsorFormPage.tsx'
import RelayProvider from './relay/RelayProvider.tsx'
import ErrorBoundary from './components/common/ErrorBoundary'
import ErrorFallback from './components/common/ErrorFallback'

const router = createBrowserRouter([
  { path: '/', element: <App /> },
  { path: '/login', element: <Login /> },
  { path: '/auth', element: <Auth /> },
  { path: '/dashboard', element: <Dashboard /> },
  { path: '/dashboard/user/:userId', element: <AdminUser /> },
  { path: '/account', element: <Account /> },
  { path: '/sponsor', element: <SponsorFormPage /> },
  { path: '/tickets', element: <Navigate to="/tickets/1" replace /> },
  { path: '/tickets/:step', element: <TicketFlow />, errorElement: <TicketFlowError /> },
])

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <RelayProvider>
      <ErrorBoundary fallback={
        <ErrorFallback 
          title="Application Error"
          message="Something went wrong with the application. Please refresh the page or try again later."
          showLogout={false}
          showHome={false}
        />
      }>
        <RouterProvider router={router} />
      </ErrorBoundary>
    </RelayProvider>
  </StrictMode>,
)
