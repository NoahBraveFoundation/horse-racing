import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.tsx'
import { createBrowserRouter, RouterProvider } from 'react-router-dom'
import TicketFlow from './routes/TicketFlow.tsx'

const router = createBrowserRouter([
  { path: '/', element: <App /> },
  { path: '/tickets', element: <TicketFlow /> },
])

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <RouterProvider router={router} />
  </StrictMode>,
)
