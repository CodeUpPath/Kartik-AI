import { useNavigate } from 'react-router';
import { useState } from 'react';
import { ArrowLeft } from 'lucide-react';
import img3 from 'figma:asset/42f81ea4858497f5ddcac0383d954010f2fb213b.png';

export function GoalsScreen() {
  const navigate = useNavigate();
  const [selected, setSelected] = useState<string | null>(null);

  const goals = [
    { id: 'lose', label: 'Lose Weight', image: img3 },
    { id: 'build', label: 'Build Muscle', image: img3 },
    { id: 'fit', label: 'Keep Fit', image: img3 },
  ];

  return (
    <div className="min-h-screen bg-white flex flex-col">
      {/* Header */}
      <div className="px-6 pt-3">
        <div className="text-sm mb-2">10:41</div>
        <div className="flex items-center justify-between py-2">
          <button onClick={() => navigate('/focus')}>
            <ArrowLeft size={24} />
          </button>
          <div className="flex-1 mx-4">
            <div className="h-1 bg-gray-200 rounded-full overflow-hidden">
              <div className="h-full bg-[#0071FF] w-[42%]" />
            </div>
          </div>
          <button onClick={() => navigate('/level')} className="text-gray-400 text-sm">
            Skip
          </button>
        </div>
      </div>

      {/* Content */}
      <div className="flex-1 px-6">
        <h1 className="text-3xl font-bold mb-8 text-center">
          What are your main goals?
        </h1>

        {/* Goal Cards */}
        <div className="space-y-4">
          {goals.map((goal) => (
            <button
              key={goal.id}
              onClick={() => setSelected(goal.id)}
              className={`w-full rounded-3xl border-2 overflow-hidden transition-all ${
                selected === goal.id
                  ? 'border-[#0071FF] bg-[#0071FF]/5'
                  : 'border-gray-200 bg-white'
              }`}
            >
              <div className="flex items-center p-5">
                <span className="text-2xl font-bold flex-1 text-left">
                  {goal.label}
                </span>
                <div className="w-24 h-24">
                  <img
                    src={goal.image}
                    alt={goal.label}
                    className="w-full h-full object-cover rounded-xl"
                  />
                </div>
              </div>
            </button>
          ))}
        </div>
      </div>

      {/* Bottom Button */}
      <div className="px-6 pb-8">
        <button
          onClick={() => navigate('/level')}
          disabled={!selected}
          className={`w-full font-semibold py-4 rounded-full text-lg transition-colors ${
            selected
              ? 'bg-[#0071FF] text-white'
              : 'bg-gray-200 text-gray-400'
          }`}
        >
          NEXT
        </button>
      </div>
    </div>
  );
}
