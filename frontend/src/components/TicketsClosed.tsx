import React from "react";
import { Link } from "react-router-dom";

const TicketsClosed: React.FC = () => (
  <main className="min-h-screen bg-gradient-to-b from-noahbrave-50 to-white flex items-center justify-center px-4">
    <div className="max-w-3xl w-full text-center bg-white shadow-2xl rounded-3xl p-10 md:p-14 border border-noahbrave-200">
      <div className="inline-flex items-center justify-center w-16 h-16 rounded-full bg-noahbrave-100 text-noahbrave-700 mb-6">
        <svg
          className="w-8 h-8"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
          strokeWidth="2"
        >
          <path
            strokeLinecap="round"
            strokeLinejoin="round"
            d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
          />
        </svg>
      </div>
      <p className="uppercase tracking-[0.3em] text-xs font-semibold text-noahbrave-600">
        Ticketing Closed
      </p>
      <h1 className="mt-3 font-heading text-3xl md:text-4xl text-gray-900">
        Thanks for a wonderful event
      </h1>
      <p className="mt-4 text-lg text-gray-700 leading-relaxed">
        Our 2025 event has wrapped up and ticket sales are now closed.
        We&rsquo;ll be back in 2026—stay tuned for updates on the next Night at
        the Races.
      </p>
      <div className="mt-8 flex flex-col sm:flex-row items-center justify-center gap-3">
        <a
          href="mailto:info@noahbrave.org"
          className="cta px-6 py-3 rounded-lg font-semibold shadow-md w-full sm:w-auto text-center"
        >
          Contact the team
        </a>
        <Link
          to="/"
          className="px-6 py-3 rounded-lg font-semibold border-2 border-noahbrave-600 text-noahbrave-600 hover:bg-noahbrave-50 transition-colors duration-200 w-full sm:w-auto text-center"
        >
          Return home
        </Link>
      </div>
    </div>
  </main>
);

export default TicketsClosed;
