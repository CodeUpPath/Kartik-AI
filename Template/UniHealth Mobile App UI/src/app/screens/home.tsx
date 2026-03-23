import { StatusBar } from '../components/status-bar';
import { BottomNav } from '../components/bottom-nav';
import { FloatingMic } from '../components/floating-mic';
import { Bell, Footprints, Flame, Heart, Moon, Dumbbell, Camera, Timer, CheckSquare, Watch } from 'lucide-react';
import { useNavigate } from 'react-router';

export function HomeScreen() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-[#0a0f1e] text-[#f0f6ff] pb-32">
      <StatusBar />

      {/* Header */}
      <div className="px-6 py-4 flex justify-between items-center">
        <div>
          <h1 className="text-xl font-['Baloo_2'] font-bold">
            Namaste, Rahul! 👋
          </h1>
        </div>
        <button className="p-2">
          <Bell size={24} className="text-[#f0f6ff]" />
        </button>
      </div>

      {/* Scrollable Content */}
      <div className="px-6 space-y-6 overflow-y-auto">
        {/* UniScore Ring */}
        <div className="flex justify-center py-6">
          <div className="relative">
            {/* Outer rings */}
            <svg width="200" height="200" className="transform -rotate-90">
              {/* Blue ring - Steps */}
              <circle
                cx="100"
                cy="100"
                r="85"
                fill="none"
                stroke="#3b82f6"
                strokeWidth="8"
                strokeDasharray={`${(7842 / 10000) * 534} 534`}
                opacity="0.8"
              />
              {/* Green ring - Calories */}
              <circle
                cx="100"
                cy="100"
                r="70"
                fill="none"
                stroke="#22c55e"
                strokeWidth="8"
                strokeDasharray={`${(1640 / 2000) * 439} 439`}
                opacity="0.8"
              />
              {/* Orange ring - Activity */}
              <circle
                cx="100"
                cy="100"
                r="55"
                fill="none"
                stroke="#f97316"
                strokeWidth="8"
                strokeDasharray={`${0.75 * 345} 345`}
                opacity="0.8"
              />
            </svg>
            {/* Center Score */}
            <div className="absolute inset-0 flex flex-col items-center justify-center">
              <div className="text-5xl font-['Baloo_2'] font-extrabold">82</div>
              <div className="text-xs text-[#6b7f9e] font-semibold tracking-wider">
                UNISCORE
              </div>
            </div>
          </div>
        </div>

        {/* Stat Chips */}
        <div className="grid grid-cols-4 gap-2">
          <div className="bg-[#111827] border border-white/[0.07] rounded-2xl p-3 flex flex-col items-center gap-1">
            <Footprints size={20} className="text-[#22c55e]" />
            <div className="text-sm font-['Baloo_2'] font-extrabold">7,842</div>
            <div className="text-[10px] text-[#6b7f9e]">Steps</div>
          </div>
          <div className="bg-[#111827] border border-white/[0.07] rounded-2xl p-3 flex flex-col items-center gap-1">
            <Flame size={20} className="text-[#f97316]" />
            <div className="text-sm font-['Baloo_2'] font-extrabold">1,640</div>
            <div className="text-[10px] text-[#6b7f9e]">Calories</div>
          </div>
          <div className="bg-[#111827] border border-white/[0.07] rounded-2xl p-3 flex flex-col items-center gap-1">
            <Heart size={20} className="text-[#ec4899]" />
            <div className="text-sm font-['Baloo_2'] font-extrabold">72</div>
            <div className="text-[10px] text-[#6b7f9e]">BPM</div>
          </div>
          <div className="bg-[#111827] border border-white/[0.07] rounded-2xl p-3 flex flex-col items-center gap-1">
            <Moon size={20} className="text-[#8b5cf6]" />
            <div className="text-sm font-['Baloo_2'] font-extrabold">7.2h</div>
            <div className="text-[10px] text-[#6b7f9e]">Sleep</div>
          </div>
        </div>

        {/* ARIA AI Insight Card */}
        <div className="bg-gradient-to-br from-[#8b5cf6] to-[#3b82f6] rounded-2xl p-4 border border-white/[0.1]">
          <div className="flex items-start gap-3">
            <div className="bg-white/20 rounded-full p-2">
              <span className="text-2xl">🤖</span>
            </div>
            <div className="flex-1">
              <div className="text-sm font-semibold mb-1">ARIA AI Coach</div>
              <p className="text-sm opacity-90">
                Aaj bahut accha progress, Rahul! 💪 Par thoda paani aur pee lo—
                only 4 glasses done!
              </p>
            </div>
          </div>
        </div>

        {/* Quick Actions */}
        <div>
          <h3 className="text-base font-['Baloo_2'] font-bold mb-3">
            Quick Actions
          </h3>
          <div className="grid grid-cols-2 gap-3">
            <button
              onClick={() => navigate('/workout')}
              className="bg-[#111827] border border-white/[0.07] rounded-2xl p-4 flex items-center gap-3 hover:bg-[#1a2235] transition-colors"
            >
              <div className="bg-[#3b82f6]/20 rounded-xl p-3">
                <Dumbbell size={24} className="text-[#3b82f6]" />
              </div>
              <span className="font-semibold">Workout</span>
            </button>
            <button
              onClick={() => navigate('/food')}
              className="bg-[#111827] border border-white/[0.07] rounded-2xl p-4 flex items-center gap-3 hover:bg-[#1a2235] transition-colors"
            >
              <div className="bg-[#f97316]/20 rounded-xl p-3">
                <Camera size={24} className="text-[#f97316]" />
              </div>
              <span className="font-semibold">Food Scan</span>
            </button>
            <button className="bg-[#111827] border border-white/[0.07] rounded-2xl p-4 flex items-center gap-3 hover:bg-[#1a2235] transition-colors">
              <div className="bg-[#0db9a8]/20 rounded-xl p-3">
                <Timer size={24} className="text-[#0db9a8]" />
              </div>
              <span className="font-semibold">Stopwatch</span>
            </button>
            <button
              onClick={() => navigate('/todo')}
              className="bg-[#111827] border border-white/[0.07] rounded-2xl p-4 flex items-center gap-3 hover:bg-[#1a2235] transition-colors"
            >
              <div className="bg-[#22c55e]/20 rounded-xl p-3">
                <CheckSquare size={24} className="text-[#22c55e]" />
              </div>
              <span className="font-semibold">To-Do</span>
            </button>
          </div>
        </div>

        {/* Progress Bars */}
        <div>
          <h3 className="text-base font-['Baloo_2'] font-bold mb-3">
            Today's Progress
          </h3>
          <div className="space-y-3">
            {[
              { label: 'Steps', value: 7842, max: 10000, color: '#22c55e' },
              { label: 'Calories', value: 1640, max: 2000, color: '#f97316' },
              { label: 'Water', value: 4, max: 8, color: '#3b82f6', unit: ' glasses' },
              { label: 'Protein', value: 45, max: 60, color: '#ec4899', unit: 'g' },
            ].map((item) => (
              <div key={item.label}>
                <div className="flex justify-between text-sm mb-1">
                  <span className="text-[#6b7f9e]">{item.label}</span>
                  <span className="font-semibold">
                    {item.value}
                    {item.unit || ''} / {item.max}
                    {item.unit || ''}
                  </span>
                </div>
                <div className="h-2 bg-[#111827] rounded-full overflow-hidden">
                  <div
                    className="h-full rounded-full transition-all"
                    style={{
                      width: `${(item.value / item.max) * 100}%`,
                      backgroundColor: item.color,
                    }}
                  />
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Watch Connection */}
        <div className="bg-[#111827] border border-white/[0.07] rounded-2xl p-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Watch size={24} className="text-[#3b82f6]" />
            <div>
              <div className="font-semibold">Galaxy Watch 6</div>
              <div className="text-xs text-[#6b7f9e]">Connected</div>
            </div>
          </div>
          <div className="bg-[#22c55e] text-white text-[10px] font-bold px-3 py-1 rounded-full">
            LIVE
          </div>
        </div>

        {/* More Features */}
        <div>
          <h3 className="text-base font-['Baloo_2'] font-bold mb-3">More Features</h3>
          <div className="space-y-2">
            <button
              onClick={() => navigate('/family')}
              className="w-full bg-[#111827] border border-white/[0.07] rounded-2xl p-4 flex items-center justify-between hover:bg-[#1a2235] transition-colors"
            >
              <div className="flex items-center gap-3">
                <div className="bg-[#3b82f6]/20 rounded-xl p-3">
                  <span className="text-2xl">👨‍👩‍👧‍👦</span>
                </div>
                <div className="text-left">
                  <div className="font-semibold">Family Health Hub</div>
                  <div className="text-xs text-[#6b7f9e]">Track your family's health</div>
                </div>
              </div>
            </button>
            <button
              onClick={() => navigate('/period')}
              className="w-full bg-[#111827] border border-white/[0.07] rounded-2xl p-4 flex items-center justify-between hover:bg-[#1a2235] transition-colors"
            >
              <div className="flex items-center gap-3">
                <div className="bg-[#ec4899]/20 rounded-xl p-3">
                  <span className="text-2xl">🌸</span>
                </div>
                <div className="text-left">
                  <div className="font-semibold">Period Tracker</div>
                  <div className="text-xs text-[#6b7f9e]">Monitor your cycle</div>
                </div>
              </div>
            </button>
          </div>
        </div>
      </div>

      <FloatingMic />
      <BottomNav />
    </div>
  );
}
