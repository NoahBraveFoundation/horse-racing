# Horse Racing Frontend

A modern React application built with TypeScript, Vite, and Tailwind CSS for the Horse Racing Fundraiser.

## Features

- **React 18**: Latest React with hooks and modern patterns
- **TypeScript**: Full type safety
- **Vite**: Fast build tool and dev server
- **Tailwind CSS**: Utility-first CSS framework
- **Responsive Design**: Mobile-first approach

## Getting Started

### Prerequisites

- Node.js 18+ 
- npm or yarn

### Installation

1. Navigate to the frontend directory
2. Install dependencies:

```bash
npm install
```

### Development

Start the development server:

```bash
npm run dev
```

The app will be available at `http://localhost:5173`

### Building for Production

```bash
npm run build
```

### Preview Production Build

```bash
npm run preview
```

## Project Structure

```
src/
├── assets/          # Static assets (images, icons)
├── components/      # React components
├── App.tsx         # Main application component
├── index.css       # Global styles with Tailwind
└── main.tsx        # Application entry point
```

## Tailwind CSS

This project uses Tailwind CSS for styling. The configuration is in `tailwind.config.js`.

### Custom Animations

- `animate-spin-slow`: Slow rotation animation (3s)

### Key Features

- Responsive design utilities
- Hover effects and transitions
- Shadow and border utilities
- Color palette system

## Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build
- `npm run lint` - Run ESLint
- `npm run type-check` - Run TypeScript type checking

## Dependencies

- **React**: UI library
- **TypeScript**: Type safety
- **Vite**: Build tool and dev server
- **Tailwind CSS**: Utility-first CSS framework
- **PostCSS**: CSS processing
- **Autoprefixer**: CSS vendor prefixing

## Development Notes

- Hot Module Replacement (HMR) is enabled
- TypeScript strict mode is enabled
- ESLint is configured for code quality
- Tailwind CSS is configured to scan all React components

## Next Steps

- Add routing with React Router
- Integrate with the GraphQL backend
- Add state management (Redux Toolkit, Zustand, etc.)
- Implement authentication
- Add horse racing specific components
- Add betting interface
- Implement real-time updates
