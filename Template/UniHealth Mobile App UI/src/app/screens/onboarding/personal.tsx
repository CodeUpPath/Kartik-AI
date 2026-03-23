import { useNavigate } from 'react-router';
import { useState } from 'react';
import { ArrowLeft } from 'lucide-react';

export function PersonalScreen() {
  const navigate = useNavigate();
  const [weight, setWeight] = useState(165.0);
  const [height, setHeight] = useState({ ft: 5, inch: 9 });
  const [unit, setUnit] = useState<'kg' | 'lbs'>('lbs');
  const [heightUnit, setHeightUnit] = useState<'cm' | 'ft'>('ft');
  const [showModal, setShowModal] = useState(false);

  return (
    <div className="min-h-screen bg-white flex flex-col relative">
      {/* Header */}
      <div className="px-6 pt-3">
        <div className="text-sm mb-2">10:42</div>
        <div className="flex items-center justify-between py-2">
          <button onClick={() => navigate('/weekly')}>
            <ArrowLeft size={24} />
          </button>
          <div className="flex-1 mx-4">
            <div className="h-1 bg-gray-200 rounded-full overflow-hidden">
              <div className="h-full bg-[#0071FF] w-[85%]" />
            </div>
          </div>
          <button onClick={() => navigate('/training')} className="text-gray-400 text-sm">
            Skip
          </button>
        </div>
      </div>

      {/* Content */}
      <div className="flex-1 px-6">
        <h1 className="text-3xl font-bold mb-1">Let us know you better</h1>
        <p className="text-gray-500 mb-8">
          Let us know you better to help boost your workout results
        </p>

        {/* Weight Picker */}
        <div className="mb-8">
          <div className="flex items-center justify-between mb-3">
            <span className="text-xl font-bold">Weight</span>
            <div className="flex gap-2">
              <button
                onClick={() => setUnit('kg')}
                className={`px-4 py-1 rounded-full text-sm font-semibold ${
                  unit === 'kg' ? 'bg-gray-200 text-black' : 'text-gray-400'
                }`}
              >
                kg
              </button>
              <button
                onClick={() => setUnit('lbs')}
                className={`px-4 py-1 rounded-full text-sm font-semibold ${
                  unit === 'lbs' ? 'bg-[#0071FF] text-white' : 'text-gray-400'
                }`}
              >
                lbs
              </button>
            </div>
          </div>

          <div className="relative h-24 flex items-center justify-center">
            <div className="text-6xl font-bold text-[#0071FF]">
              {weight.toFixed(1)}
              <span className="text-2xl ml-2">lbs</span>
            </div>
            {/* Ruler visualization */}
            <div className="absolute bottom-0 left-0 right-0 flex justify-center">
              {[163, 164, 165, 166, 167].map((val) => (
                <div key={val} className="flex-1 flex flex-col items-center">
                  <div
                    className={`w-px ${
                      val === 165 ? 'h-16 bg-[#0071FF]' : 'h-8 bg-gray-300'
                    }`}
                  />
                  <span
                    className={`text-xs mt-1 ${
                      val === 165 ? 'text-black font-semibold' : 'text-gray-400'
                    }`}
                  >
                    {val}
                  </span>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Height Picker */}
        <div className="mb-8">
          <div className="flex items-center justify-between mb-3">
            <span className="text-xl font-bold">Height</span>
            <div className="flex gap-2">
              <button
                onClick={() => setHeightUnit('cm')}
                className={`px-4 py-1 rounded-full text-sm font-semibold ${
                  heightUnit === 'cm' ? 'bg-gray-200 text-black' : 'text-gray-400'
                }`}
              >
                cm
              </button>
              <button
                onClick={() => setHeightUnit('ft')}
                className={`px-4 py-1 rounded-full text-sm font-semibold ${
                  heightUnit === 'ft' ? 'bg-[#0071FF] text-white' : 'text-gray-400'
                }`}
              >
                ft
              </button>
            </div>
          </div>

          <div className="relative h-24 flex items-center justify-center">
            <div className="text-6xl font-bold text-[#0071FF]">
              {height.ft}
              <span className="text-3xl">ft</span> {height.inch}
              <span className="text-3xl">in</span>
            </div>
            {/* Ruler visualization */}
            <div className="absolute bottom-0 left-0 right-0 flex justify-center">
              {[4, 5, 6, 7].map((val) => (
                <div key={val} className="flex-1 flex flex-col items-center">
                  <div
                    className={`w-px ${
                      val === 6 ? 'h-16 bg-[#0071FF]' : 'h-8 bg-gray-300'
                    }`}
                  />
                  <span
                    className={`text-xs mt-1 ${
                      val === 6 ? 'text-black font-semibold' : 'text-gray-400'
                    }`}
                  >
                    {val}
                  </span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Bottom Button */}
      <div className="px-6 pb-8">
        <button
          onClick={() => setShowModal(true)}
          className="w-full bg-[#0071FF] text-white font-semibold py-4 rounded-full text-lg"
        >
          GET MY PLAN
        </button>
      </div>

      {/* Health Connect Modal */}
      {showModal && (
        <div className="absolute inset-0 bg-black/50 flex items-end">
          <div className="w-full bg-white rounded-t-3xl p-6 animate-in slide-in-from-bottom duration-300">
            <h2 className="text-2xl font-bold mb-2 text-center">
              Share data with Health Connect & other apps
            </h2>
            <p className="text-gray-500 text-center mb-6">
              Share your health data with other apps to save your time.
            </p>

            <div className="flex items-center justify-center gap-8 mb-6">
              <div className="w-16 h-16 rounded-2xl bg-white border-2 border-gray-200 flex items-center justify-center">
                <div className="text-3xl">❤️</div>
              </div>
              <div className="text-2xl text-gray-300">=</div>
              <div className="w-16 h-16 rounded-2xl bg-red-500 flex items-center justify-center">
                <div className="text-3xl">💪</div>
              </div>
            </div>

            <button
              onClick={() => navigate('/training')}
              className="w-full bg-[#0071FF] text-white font-semibold py-4 rounded-full text-lg mb-3"
            >
              SET UP HEALTH CONNECT
            </button>
            <button
              onClick={() => navigate('/training')}
              className="w-full bg-white border-2 border-gray-200 text-black font-semibold py-4 rounded-full text-lg"
            >
              NOT NOW
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
