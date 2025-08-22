import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.tsx'
import { createBrowserRouter, RouterProvider, Navigate } from 'react-router-dom'
import TicketFlow from './routes/TicketFlow.tsx'
import Login from './components/Login.tsx'
import Auth from './components/Auth.tsx'
import Dashboard from './components/Dashboard.tsx'
import Account from './components/Account.tsx'
import RelayProvider from './relay/RelayProvider.tsx'

const router = createBrowserRouter([
  { path: '/', element: <App /> },
  { path: '/login', element: <Login /> },
  { path: '/auth', element: <Auth /> },
  { path: '/dashboard', element: <Dashboard /> },
  { path: '/account', element: <Account /> },
  { path: '/tickets', element: <Navigate to="/tickets/1" replace /> },
  { path: '/tickets/:step', element: <TicketFlow /> },
])

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <RelayProvider>
      <RouterProvider router={router} />
    </RelayProvider>
  </StrictMode>,
)
