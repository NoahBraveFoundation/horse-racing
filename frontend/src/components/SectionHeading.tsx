import React from 'react'

export type SectionHeadingProps = {
  title: string
  className?: string
}

export const SectionHeading: React.FC<SectionHeadingProps> = ({ title, className }) => {
  return (
    <div className={`text-center mb-16 ${className ?? ''}`}>
      <h2 className="font-heading text-4xl md:text-5xl text-gray-900 mb-3">{title}</h2>
      <div className="w-28 h-1 bg-noahbrave-600 mx-auto rounded-full" />
    </div>
  )
}

export default SectionHeading


