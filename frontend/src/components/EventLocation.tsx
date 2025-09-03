import React from 'react'
import { SectionHeading } from './SectionHeading'

export const EventLocation: React.FC = () => {
  // Use production MapKit embed only in production
  const mapkitSrc = import.meta.env.PROD 
    ? "https://embed.apple-mapkit.com/v1/embed?center=42.6905%2C-82.9395&cameraDistance=44221.1716&annotations=%5B%7B%22place%22%3A%22I2740163A10FE522E%22%7D%5D&token=eyJraWQiOiI5WjI2U1RaNDRTIiwidHlwIjoiSldUIiwiYWxnIjoiRVMyNTYifQ.eyJpc3MiOiJWU0s0WUpCN0Q4IiwiaWF0IjoxNzU1NzQxMzQ1LCJvcmlnaW4iOiIqLm5vYWhicmF2ZS5vcmcifQ.hg3kYcY6mfDdu0BNRrn83HByKSmuBcfDzYQPCTXeZd74MyJhtah2OunWDKWdZVFb8J9h7qFw7NeLr-UTg3W2OQ"
    : "https://embed.apple-mapkit.com/v1/embed?center=42.6808%2C-82.817&cameraDistance=27000.853&annotations=%5B%7B%22place%22%3A%22I2740163A10FE522E%22%7D%5D&colorScheme=adaptive&token=eyJraWQiOiIzUjJBVUtZMzhKIiwidHlwIjoiSldUIiwiYWxnIjoiRVMyNTYifQ.eyJpc3MiOiJWU0s0WUpCN0Q4IiwiaWF0IjoxNzU1NzQxMzY0LCJleHAiOjE3NTYzNjQzOTl9.GkPgi2Dw_GDc-4_V9kW4PnFI-mEd3iXULjlovo7bR7jsYDT7DmKA1pYbQdewcQUzo7VCv13Wwpc3PhXWe22n7Q"

  return (
    <section id="location" className="py-20 bg-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <SectionHeading 
          title="Event Location" 
        />
        
        <div className="mt-12">
          <div className="rounded-lg overflow-hidden">
            <iframe 
              src={mapkitSrc}
              className="w-full h-[400px] md:h-[500px] border-0"
              title="Event Location - Tina's Country House & Garden"
              scrolling="no"
              onLoad={(e) => {
                // Prevent scroll capture
                const iframe = e.target as HTMLIFrameElement;
                iframe.contentWindow?.addEventListener('wheel', (e) => {
                  e.preventDefault();
                }, { passive: false });
              }}
            />
          </div>
        </div>
      </div>
    </section>
  )
}

export default EventLocation
