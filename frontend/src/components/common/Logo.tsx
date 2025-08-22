import React from 'react'
import nbf from '../../assets/nbf.webp'

interface LogoProps {
  size?: 'sm' | 'md' | 'lg'
  showBackground?: boolean
  className?: string
  clickable?: boolean
}

export const Logo: React.FC<LogoProps> = ({ 
  size = 'md', 
  showBackground = true, 
  className = '', 
  clickable = false 
}) => {
  const sizeClasses = {
    sm: 'w-8 h-8',
    md: 'w-12 h-12',
    lg: 'w-16 h-16'
  }

  const backgroundClasses = showBackground 
    ? 'bg-white rounded-full flex items-center justify-center shadow overflow-hidden'
    : ''

  const logoElement = (
    <div className={`${sizeClasses[size]} ${backgroundClasses} ${className}`}>
      <img 
        src={nbf} 
        alt="NoahBRAVE Foundation" 
        className="w-full h-full object-contain" 
      />
    </div>
  )

  if (clickable) {
    return (
      <a 
        href="https://noahbrave.org" 
        target="_blank" 
        rel="noopener noreferrer"
        className="hover:opacity-80 transition-opacity duration-200"
      >
        {logoElement}
      </a>
    )
  }

  return logoElement
}

export default Logo
