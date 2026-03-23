import { useNavigate } from 'react-router';
import { useState } from 'react';
import img1 from 'figma:asset/f5dee15fb1d95e863fc8be72e377d21eaa24d6cf.png';

export function GenderScreen() {
  const navigate = useNavigate();
  const [selected, setSelected] = useState<'male' | 'female' | null>(null);

  return (
    <div className="min-h-screen bg-white flex flex-col">
      {/* Status Bar */}
      <div className="px-6 pt-3 flex items-center justify-between">
        <div className="text-sm">10:41</div>
        <div className="flex items-center gap-2">
          <div className="text-sm">📶 📶</div>
        </div>
      </div>

      {/* Progress Bar */}
      <div className="px-6 py-4 flex items-center justify-between">
        <div className="flex-1 h-1 bg-gray-200 rounded-full overflow-hidden mr-3">
          <div className="h-full bg-[#0071FF] w-[14%]" />
        </div>
        <button onClick={() => navigate('/focus')} className="text-gray-400 text-sm">
          Skip
        </button>
      </div>

      {/* Content */}
      <div className="flex-1 flex flex-col px-6">
        <h1 className="text-3xl font-bold mb-2">What's your gender?</h1>
        <p className="text-gray-500 mb-8">Let us know you better</p>

        {/* Gender Options */}
        <div className="flex-1 flex items-center justify-center pb-32">
          <img
            src={img1}
            alt="Gender selection"
            className="w-full max-w-sm object-contain"
          />
        </div>
      </div>

      {/* Bottom Button */}
      <div className="px-6 pb-8">
        <button
          onClick={() => navigate('/focus')}
          className="w-full bg-[#0071FF] text-white font-semibold py-4 rounded-full text-lg"
        >
          NEXT
        </button>
      </div>
    </div>
  );
}
