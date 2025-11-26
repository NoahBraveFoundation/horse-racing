import React from "react";
import heroImg from "../assets/dallas-derby.jpg";
import { Link } from "react-router-dom";

export const Hero: React.FC = () => {
  return (
    <section className="relative text-white overflow-hidden min-h-[75vh]">
      {/* Background image */}
      <div
        className="absolute inset-0 bg-center bg-cover"
        style={{ backgroundImage: `url(${heroImg})` }}
        aria-hidden="true"
      />
      {/* Contrast overlays */}
      <div
        className="absolute inset-0 bg-gradient-to-b from-black/40 via-noahbrave-900/40 to-black/60 mix-blend-multiply"
        aria-hidden="true"
      />
      {/* Checkered pattern overlay */}
      <div className="absolute inset-0 opacity-5" aria-hidden="true">
        <div
          className="absolute inset-0"
          style={{
            backgroundImage: `repeating-linear-gradient(45deg, transparent, transparent 10px, white 10px, white 20px)`,
          }}
        />
      </div>

      <div className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex flex-col items-center text-center gap-6 py-20 md:py-32">
          <div>
            <h2 className="font-heading text-5xl md:text-7xl leading-none drop-shadow-md">
              A NIGHT
            </h2>
            <div className="flex items-center justify-center">
              <span className="text-2xl md:text-3xl font-light italic mr-2">
                at the
              </span>
              <span className="font-heading text-5xl md:text-7xl leading-none drop-shadow-md">
                RACES
              </span>
            </div>
          </div>

          <div className="glass rounded-xl px-6 md:px-8 py-4 inline-flex flex-col items-center gap-1">
            <div className="font-heading text-2xl md:text-3xl tracking-wide">
              November 2026
            </div>
            <div className="text-base md:text-lg">Location to be decided</div>
          </div>

          <div className="flex flex-col sm:flex-row gap-3 mt-2">
            <Link
              to="/tickets"
              className="cta px-6 py-3 rounded-lg font-semibold shadow-lg text-center"
            >
              Ticketing Closed — Back in 2026
            </Link>
            <a
              href="#about"
              className="px-6 py-3 rounded-lg font-semibold bg-white/10 hover:bg-white/15 border border-white/30 backdrop-blur text-white shadow-lg"
            >
              Learn More
            </a>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Hero;
