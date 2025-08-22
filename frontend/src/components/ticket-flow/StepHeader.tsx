import React from 'react';

interface StepHeaderProps {
  title: string;
  subtitle?: string;
}

const StepHeader: React.FC<StepHeaderProps> = ({ title, subtitle }) => {
  return (
    <div className="mb-8 text-center">
      <h1 className="font-heading text-4xl md:text-5xl text-gray-900">{title}</h1>
      {subtitle && <p className="text-gray-600 mt-2">{subtitle}</p>}
    </div>
  );
};

export default StepHeader;
