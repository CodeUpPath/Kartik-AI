import { useNavigate } from 'react-router';
import { useState } from 'react';
import { ArrowLeft } from 'lucide-react';

export function WeeklyScreen() {
  const navigate = useNavigate();
  const [selectedDays, setSelectedDays] = useState(4);
  const [startDay, setStartDay] = useState('SUNDAY');

  const days = [1, 2, 3, 4, 5, 6, 7];
  const weekDays = ['SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY'];

  return (
    <div className="min-h-screen bg-white flex flex-col">
      {/* Header */}
      <div className="px-6 pt-3">
        <div className="text-sm mb-2">10:41</div>
        <div className="flex items-center justify-between py-2">
          <button onClick={() => navigate('/level')}>
            <ArrowLeft size={24} />
          </button>
          <div className="flex-1 mx-4">
            <div className="h-1 bg-gray-200 rounded-full overflow-hidden">
              <div className="h-full bg-[#0071FF] w-[70%]" />
            </div>
          </div>
          <button onClick={() => navigate('/personal')} className="text-gray-400 text-sm">
            Skip
          </button>
        </div>
      </div>

      {/* Content */}
      <div className="flex-1 px-6">
        <h1 className="text-3xl font-bold mb-2">Set your weekly goal</h1>
        <p className="text-gray-500 mb-8">
          We recommend training at least 3 days weekly for a better result.
        </p>

        {/* Weekly Training Days */}
        <div className="mb-8">
          <div className="flex items-center gap-2 mb-4 text-gray-600">
            <span className="text-xl">🎯</span>
            <span className="font-medium">Weekly training days</span>
          </div>

          <div className="grid grid-cols-4 gap-3">
            {days.map((day) => (
              <button
                key={day}
                onClick={() => setSelectedDays(day)}
                className={`aspect-square rounded-2xl text-2xl font-bold transition-all ${
                  selectedDays === day
                    ? 'bg-[#0071FF] text-white'
                    : 'bg-white border-2 border-gray-200 text-black'
                }`}
              >
                {day}
              </button>
            ))}
          </div>
        </div>

        {/* First Day of Week */}
        <div>
          <div className="flex items-center gap-2 mb-4 text-gray-600">
            <span className="text-xl">📅</span>
            <span className="font-medium">First day of week</span>
          </div>

          <div className="relative">
            <select
              value={startDay}
              onChange={(e) => setStartDay(e.target.value)}
              className="w-full appearance-none bg-white border-2 border-gray-200 rounded-2xl px-5 py-4 font-semibold text-lg"
            >
              {weekDays.map((day) => (
                <option key={day} value={day}>
                  {day}
                </option>
              ))}
            </select>
            <div className="absolute right-5 top-1/2 -translate-y-1/2 pointer-events-none">
              <svg width="12" height="8" viewBox="0 0 12 8" fill="none">
                <path
                  d="M1 1L6 6L11 1"
                  stroke="currentColor"
                  strokeWidth="2"
                  strokeLinecap="round"
                />
              </svg>
            </div>
          </div>
        </div>
      </div>

      {/* Bottom Button */}
      <div className="px-6 pb-8">
        <button
          onClick={() => navigate('/personal')}
          className="w-full bg-[#0071FF] text-white font-semibold py-4 rounded-full text-lg"
        >
          NEXT
        </button>
      </div>
    </div>
  );
}
