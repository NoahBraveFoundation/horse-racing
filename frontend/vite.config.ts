import { defineConfig, loadEnv } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

// https://vite.dev/config/
export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, '.', '')
  
  return {
    plugins: [
      react({
        babel: {
          plugins: [['babel-plugin-relay', { artifactDirectory: './src/__generated__' }]],
        },
      }),
      tailwindcss(),
    ],
    server: {
      proxy: mode === 'development' ? {
        '/graphql': {
          target: env.VITE_API_URL || 'http://localhost:8080',
          changeOrigin: true,
          secure: false,
        },
      } : undefined,
    },
  }
})
