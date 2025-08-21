/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        'noahbrave': {
          50: '#f0fdf4',
          100: '#dcfce7',
          200: '#bbf7d0',
          300: '#86efac',
          400: '#4ade80',
          500: '#22c55e',
          600: '#239F09', // Official color
          700: '#15803d',
          800: '#166534',
          900: '#14532d',
        }
      },
      animation: {
        'spin-slow': 'spin 3s linear infinite',
        'fade-in-up': 'fadeInUp 0.6s ease-out',
        'bounce-slow': 'bounce 2s infinite',
      },
      backgroundImage: {
        'checkered': 'repeating-linear-gradient(45deg, transparent, transparent 10px, white 10px, white 20px)',
      }
    },
  },
  plugins: [],
}
