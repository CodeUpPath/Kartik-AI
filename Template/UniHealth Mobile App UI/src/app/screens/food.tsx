import { StatusBar } from '../components/status-bar';
import { BottomNav } from '../components/bottom-nav';
import { FloatingMic } from '../components/floating-mic';
import { ArrowLeft, Camera, Sparkles } from 'lucide-react';
import { useNavigate } from 'react-router';
import { useState } from 'react';

export function FoodScreen() {
  const navigate = useNavigate();
  const [scanned, setScanned] = useState(false);

  const foodLog = [
    { emoji: '☕', name: 'Chai + Parle-G', time: '7:30 AM', calories: 180 },
    { emoji: '🍛', name: 'Poha', time: '9:00 AM', calories: 320 },
    { emoji: '🍲', name: 'Dal Makhani + Roti', time: '1:30 PM', calories: 520 },
    { emoji: '🍪', name: 'Namkeen', time: '5:00 PM', calories: 150 },
  ];

  const totalCalories = foodLog.reduce((sum, item) => sum + item.calories, 0);
  const targetCalories = 2000;
  const remaining = targetCalories - totalCalories;

  return (
    <div className="min-h-screen bg-[#0a0f1e] text-[#f0f6ff] pb-32">
      <StatusBar />

      {/* Header */}
      <div className="px-6 py-4 flex items-center gap-4">
        <button onClick={() => navigate('/')}>
          <ArrowLeft size={24} />
        </button>
        <h2 className="text-xl font-['Baloo_2'] font-bold">SnapCalorie</h2>
      </div>

      <div className="px-6 space-y-6">
        {/* Camera Scan Area */}
        <div className="relative">
          <button
            onClick={() => setScanned(!scanned)}
            className="w-full bg-[#111827] border-2 border-dashed border-[#3b82f6] rounded-2xl p-12 flex flex-col items-center justify-center gap-4 hover:bg-[#1a2235] transition-colors"
          >
            <Camera size={48} className="text-[#3b82f6]" />
            <div className="text-center">
              <div className="font-semibold mb-1">
                Photo khecho — calories pata karo
              </div>
              <div className="text-sm text-[#6b7f9e]">Tap to scan food</div>
            </div>
            {/* Scan line animation */}
            <div className="absolute top-0 left-0 right-0 h-1 bg-gradient-to-r from-transparent via-[#3b82f6] to-transparent animate-pulse" />
          </button>
        </div>

        {/* AI Result Card (shown after scan) */}
        {scanned && (
          <div className="bg-[#111827] border border-white/[0.07] rounded-2xl p-5 animate-in fade-in slide-in-from-bottom-4 duration-300">
            <div className="flex items-center gap-2 mb-3">
              <Sparkles size={16} className="text-[#8b5cf6]" />
              <span className="text-xs font-bold text-[#8b5cf6]">
                AI DETECTED
              </span>
            </div>
            <div className="font-['Baloo_2'] font-bold text-lg mb-4">
              Dal Makhani + 2 Roti
            </div>
            <div className="grid grid-cols-4 gap-2">
              <div className="bg-[#f97316]/20 rounded-xl p-3 text-center">
                <div className="text-xs text-[#f97316] mb-1">CAL</div>
                <div className="text-lg font-['Baloo_2'] font-extrabold text-[#f97316]">
                  520
                </div>
              </div>
              <div className="bg-[#ec4899]/20 rounded-xl p-3 text-center">
                <div className="text-xs text-[#ec4899] mb-1">PRO</div>
                <div className="text-lg font-['Baloo_2'] font-extrabold text-[#ec4899]">
                  18g
                </div>
              </div>
              <div className="bg-[#eab308]/20 rounded-xl p-3 text-center">
                <div className="text-xs text-[#eab308] mb-1">FAT</div>
                <div className="text-lg font-['Baloo_2'] font-extrabold text-[#eab308]">
                  22g
                </div>
              </div>
              <div className="bg-[#3b82f6]/20 rounded-xl p-3 text-center">
                <div className="text-xs text-[#3b82f6] mb-1">CARB</div>
                <div className="text-lg font-['Baloo_2'] font-extrabold text-[#3b82f6]">
                  58g
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Daily Calorie Progress */}
        <div className="bg-[#111827] border border-white/[0.07] rounded-2xl p-5">
          <div className="flex justify-between items-center mb-3">
            <div>
              <div className="text-sm text-[#6b7f9e]">Calories Today</div>
              <div className="text-2xl font-['Baloo_2'] font-extrabold">
                {totalCalories} / {targetCalories}
              </div>
            </div>
            <div className="text-right">
              <div className="text-sm text-[#6b7f9e]">Remaining</div>
              <div className="text-2xl font-['Baloo_2'] font-extrabold text-[#22c55e]">
                {remaining}
              </div>
            </div>
          </div>
          <div className="h-3 bg-[#1a2235] rounded-full overflow-hidden">
            <div
              className="h-full bg-gradient-to-r from-[#f97316] to-[#ef4444] rounded-full transition-all"
              style={{ width: `${(totalCalories / targetCalories) * 100}%` }}
            />
          </div>
        </div>

        {/* Today's Food Log */}
        <div>
          <h3 className="text-base font-['Baloo_2'] font-bold mb-3">
            Today's Food Log
          </h3>
          <div className="space-y-2">
            {foodLog.map((item, index) => (
              <div
                key={index}
                className="bg-[#111827] border border-white/[0.07] rounded-2xl p-4 flex items-center justify-between"
              >
                <div className="flex items-center gap-3">
                  <div className="text-3xl">{item.emoji}</div>
                  <div>
                    <div className="font-semibold">{item.name}</div>
                    <div className="text-xs text-[#6b7f9e]">{item.time}</div>
                  </div>
                </div>
                <div className="bg-[#f97316] text-white text-sm font-bold px-3 py-1 rounded-full">
                  {item.calories} cal
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Festive Mode Banner */}
        <div className="bg-gradient-to-r from-[#ec4899] to-[#8b5cf6] rounded-2xl p-4 border border-white/[0.1]">
          <div className="flex items-center gap-3">
            <span className="text-3xl">🌙</span>
            <div>
              <div className="font-['Baloo_2'] font-bold mb-1">
                Navratri Fast Mode
              </div>
              <div className="text-sm opacity-90">
                Special meal tracking for fasting
              </div>
            </div>
          </div>
        </div>
      </div>

      <FloatingMic />
      <BottomNav />
    </div>
  );
}
