import { useNavigate } from 'react-router';
import { useState } from 'react';
import { ArrowLeft } from 'lucide-react';

export function LevelScreen() {
  const navigate = useNavigate();
  const [selected, setSelected] = useState<string | null>(null);

  const levels = [
    { id: 'beginner', emoji: '✌️', label: 'Beginner', description: '3-5 push-ups' },
    { id: 'intermediate', emoji: '✌️', label: 'Intermediate', description: '5-10 push-ups' },
    { id: 'advanced', emoji: '💪', label: 'Advanced', description: 'At least 10' },
  ];

  return (
    <div className="min-h-screen bg-white flex flex-col">
      {/* Header */}
      <div className="px-6 pt-3">
        <div className="text-sm mb-2">10:41</div>
        <div className="flex items-center justify-between py-2">
          <button onClick={() => navigate('/goals')}>
            <ArrowLeft size={24} />
          </button>
          <div className="flex-1 mx-4">
            <div className="h-1 bg-gray-200 rounded-full overflow-hidden">
              <div className="h-full bg-[#0071FF] w-[56%]" />
            </div>
          </div>
          <button onClick={() => navigate('/weekly')} className="text-gray-400 text-sm">
            Skip
          </button>
        </div>
      </div>

      {/* Content */}
      <div className="flex-1 px-6">
        <h1 className="text-2xl font-bold mb-2">
          How many push-ups can you do at one time?
        </h1>

        <div className="space-y-3 mt-8">
          {levels.map((level) => (
            <button
              key={level.id}
              onClick={() => setSelected(level.id)}
              className={`w-full rounded-3xl border-2 p-5 transition-all ${
                selected === level.id
                  ? 'border-[#0071FF] bg-[#0071FF]/5'
                  : 'border-gray-200 bg-white'
              }`}
            >
              <div className="flex items-center gap-4">
                <span className="text-3xl">{level.emoji}</span>
                <div className="text-left">
                  <div className="font-bold text-lg">{level.label}</div>
                  <div className="text-sm text-gray-500">{level.description}</div>
                </div>
              </div>
            </button>
          ))}
        </div>
      </div>

      {/* Bottom Button */}
      <div className="px-6 pb-8">
        <button
          onClick={() => navigate('/weekly')}
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
