import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.tsx'
import { createBrowserRouter, RouterProvider } from 'react-router-dom'
import TicketsClosed from './components/TicketsClosed.tsx'
import Login from './components/Login.tsx'
import Auth from './components/Auth.tsx'
import Dashboard from './components/Dashboard.tsx'
import Account from './components/Account.tsx'
import AdminUser from './components/admin/AdminUser'
import SponsorFormPage from './components/SponsorFormPage.tsx'
import RaceSchedule from './components/RaceSchedule.tsx'
import RelayProvider from './relay/RelayProvider.tsx'
import ErrorBoundary from './components/common/ErrorBoundary'
import ErrorFallback from './components/common/ErrorFallback'
import RootErrorBoundary from './components/common/RootErrorBoundary'
import NotFound from './components/common/NotFound'

const router = createBrowserRouter([
  { path: '/', element: <App />, errorElement: <RootErrorBoundary /> },
  { path: '/login', element: <Login />, errorElement: <RootErrorBoundary /> },
  { path: '/auth', element: <Auth />, errorElement: <RootErrorBoundary /> },
  { path: '/dashboard', element: <Dashboard />, errorElement: <RootErrorBoundary /> },
  { path: '/dashboard/user/:userId', element: <AdminUser />, errorElement: <RootErrorBoundary /> },
  { path: '/account', element: <Account />, errorElement: <RootErrorBoundary /> },
  { path: '/schedule', element: <RaceSchedule />, errorElement: <RootErrorBoundary /> },
  { path: '/sponsor', element: <SponsorFormPage />, errorElement: <RootErrorBoundary /> },
  { path: '/tickets', element: <TicketsClosed />, errorElement: <RootErrorBoundary /> },
  { path: '/tickets/*', element: <TicketsClosed />, errorElement: <RootErrorBoundary /> },
  { path: '*', element: <NotFound /> }, // Catch-all for 404s
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
