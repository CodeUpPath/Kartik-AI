import { StatusBar } from '../components/status-bar';
import { BottomNav } from '../components/bottom-nav';
import { FloatingMic } from '../components/floating-mic';
import { ArrowLeft, Sparkles } from 'lucide-react';
import { useNavigate } from 'react-router';

export function PeriodScreen() {
  const navigate = useNavigate();

  const statusCards = [
    { label: '3 days until period', value: '3', color: '#ec4899' },
    { label: 'Day 24 cycle', value: '24', color: '#8b5cf6' },
    { label: 'Ovulation +8 days', value: '+8', color: '#0db9a8' },
    { label: '28 day avg', value: '28', color: '#3b82f6' },
  ];

  const healthTips = [
    {
      emoji: '🥑',
      title: 'Magnesium Foods',
      description: 'Eat nuts, seeds, and leafy greens',
    },
    {
      emoji: '🚶‍♀️',
      title: 'Gentle Walk',
      description: 'Light exercise helps with cramps',
    },
    {
      emoji: '💧',
      title: 'Stay Hydrated',
      description: 'Drink plenty of water today',
    },
  ];

  // Calendar data - 28 day cycle starting from day 1
  const currentDay = 24;
  const periodDays = [1, 2, 3, 4, 5];
  const ovulationDay = 14;
  const fertileDays = [12, 13, 14, 15, 16];
  const predictedPeriodDays = [29, 30, 31, 32];

  const calendarDays = Array.from({ length: 28 }, (_, i) => i + 1);

  return (
    <div className="min-h-screen bg-[#0a0f1e] text-[#f0f6ff] pb-32">
      <StatusBar />

      {/* Header */}
      <div className="px-6 py-4 flex items-center gap-4">
        <button onClick={() => navigate('/')}>
          <ArrowLeft size={24} />
        </button>
        <h2 className="text-xl font-['Baloo_2'] font-bold">🌸 Period Tracker</h2>
      </div>

      <div className="px-6 space-y-6">
        {/* Cycle Ring */}
        <div className="flex justify-center py-6">
          <div className="relative">
            {/* Donut chart */}
            <svg width="200" height="200" className="transform -rotate-90">
              {/* Period phase */}
              <circle
                cx="100"
                cy="100"
                r="80"
                fill="none"
                stroke="#ec4899"
                strokeWidth="16"
                strokeDasharray={`${(5 / 28) * 502} 502`}
                opacity="0.8"
              />
              {/* Follicular phase */}
              <circle
                cx="100"
                cy="100"
                r="80"
                fill="none"
                stroke="#8b5cf6"
                strokeWidth="16"
                strokeDasharray={`${(9 / 28) * 502} 502`}
                strokeDashoffset={`${-(5 / 28) * 502}`}
                opacity="0.8"
              />
              {/* Ovulation phase */}
              <circle
                cx="100"
                cy="100"
                r="80"
                fill="none"
                stroke="#0db9a8"
                strokeWidth="16"
                strokeDasharray={`${(4 / 28) * 502} 502`}
                strokeDashoffset={`${-(14 / 28) * 502}`}
                opacity="0.8"
              />
              {/* Luteal phase */}
              <circle
                cx="100"
                cy="100"
                r="80"
                fill="none"
                stroke="#3b82f6"
                strokeWidth="16"
                strokeDasharray={`${(10 / 28) * 502} 502`}
                strokeDashoffset={`${-(18 / 28) * 502}`}
                opacity="0.8"
              />
            </svg>
            {/* Center info */}
            <div className="absolute inset-0 flex flex-col items-center justify-center">
              <div className="text-5xl font-['Baloo_2'] font-extrabold text-[#ec4899]">
                {currentDay}
              </div>
              <div className="text-xs text-[#6b7f9e] font-semibold">
                Luteal Phase
              </div>
            </div>
          </div>
        </div>

        {/* Status Cards */}
        <div className="grid grid-cols-2 gap-3">
          {statusCards.map((card) => (
            <div
              key={card.label}
              className="bg-[#111827] border border-white/[0.07] rounded-2xl p-4"
            >
              <div className="text-xs text-[#6b7f9e] mb-2">{card.label}</div>
              <div
                className="text-3xl font-['Baloo_2'] font-extrabold"
                style={{ color: card.color }}
              >
                {card.value}
              </div>
            </div>
          ))}
        </div>

        {/* Mini Calendar */}
        <div className="bg-[#111827] border border-white/[0.07] rounded-2xl p-5">
          <h3 className="text-base font-['Baloo_2'] font-bold mb-4">
            Cycle Calendar
          </h3>
          <div className="grid grid-cols-7 gap-2">
            {calendarDays.map((day) => {
              const isPeriod = periodDays.includes(day);
              const isOvulation = day === ovulationDay;
              const isFertile = fertileDays.includes(day);
              const isPredicted = predictedPeriodDays.includes(day);
              const isCurrent = day === currentDay;

              let bgColor = 'bg-[#1a2235]';
              let textColor = 'text-[#f0f6ff]';
              let borderColor = 'border-transparent';

              if (isPeriod) {
                bgColor = 'bg-[#ec4899]';
                textColor = 'text-white';
              } else if (isOvulation) {
                bgColor = 'bg-[#8b5cf6]';
                textColor = 'text-white';
              } else if (isFertile) {
                bgColor = 'bg-[#0db9a8]/30';
                textColor = 'text-[#0db9a8]';
              } else if (isPredicted) {
                borderColor = 'border-[#ec4899] border-dashed';
                textColor = 'text-[#ec4899]';
              }

              if (isCurrent) {
                borderColor = 'border-[#3b82f6] border-2';
              }

              return (
                <div
                  key={day}
                  className={`aspect-square rounded-lg flex items-center justify-center text-xs font-semibold border ${bgColor} ${textColor} ${borderColor}`}
                >
                  {day}
                </div>
              );
            })}
          </div>

          {/* Legend */}
          <div className="flex flex-wrap gap-3 mt-4 text-xs">
            <div className="flex items-center gap-1">
              <div className="w-3 h-3 rounded bg-[#ec4899]" />
              <span className="text-[#6b7f9e]">Period</span>
            </div>
            <div className="flex items-center gap-1">
              <div className="w-3 h-3 rounded bg-[#8b5cf6]" />
              <span className="text-[#6b7f9e]">Ovulation</span>
            </div>
            <div className="flex items-center gap-1">
              <div className="w-3 h-3 rounded bg-[#0db9a8]/30" />
              <span className="text-[#6b7f9e]">Fertile</span>
            </div>
            <div className="flex items-center gap-1">
              <div className="w-3 h-3 rounded border border-dashed border-[#ec4899]" />
              <span className="text-[#6b7f9e]">Predicted</span>
            </div>
          </div>
        </div>

        {/* ARIA Insight */}
        <div className="bg-gradient-to-br from-[#8b5cf6] to-[#3b82f6] rounded-2xl p-4 border border-white/[0.1]">
          <div className="flex items-start gap-3">
            <div className="bg-white/20 rounded-full p-2">
              <Sparkles size={20} />
            </div>
            <div className="flex-1">
              <div className="text-sm font-semibold mb-1">ARIA Insight</div>
              <p className="text-sm opacity-90">
                Period 22 March ko expect hai — 95% confidence! Stay prepared 💕
              </p>
            </div>
          </div>
        </div>

        {/* Health Tips */}
        <div>
          <h3 className="text-base font-['Baloo_2'] font-bold mb-3">
            Health Tips
          </h3>
          <div className="space-y-2">
            {healthTips.map((tip) => (
              <div
                key={tip.title}
                className="bg-[#111827] border border-white/[0.07] rounded-2xl p-4 flex items-center gap-3"
              >
                <span className="text-3xl">{tip.emoji}</span>
                <div>
                  <div className="font-semibold mb-1">{tip.title}</div>
                  <div className="text-sm text-[#6b7f9e]">{tip.description}</div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      <FloatingMic />
      <BottomNav />
    </div>
  );
}
