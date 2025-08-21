import './App.css'
import Header from './components/Header'
import Hero from './components/Hero'
import Schedule from './components/Schedule'
import About from './components/About'
import EventLocation from './components/EventLocation'
import Contact from './components/Contact'
import Footer from './components/Footer'
import MobileCTA from './components/MobileCTA'

function App() {

  return (
    <div className="min-h-screen bg-gradient-to-b from-noahbrave-50 to-white font-body text-gray-800">
      <div className="checker-top h-3" style={{ backgroundColor: 'var(--brand)' }} />
      <Header />
      <Hero />
      <Schedule />
      <About />
      <EventLocation />
      <Contact />
      <MobileCTA />
      <Footer />
    </div>
  )
}

export default App
