import { StatusBar } from '../components/status-bar';
import { BottomNav } from '../components/bottom-nav';
import { FloatingMic } from '../components/floating-mic';
import { ArrowLeft, Play, Pause, RotateCcw } from 'lucide-react';
import { useNavigate } from 'react-router';
import { useState, useEffect } from 'react';

export function WorkoutScreen() {
  const navigate = useNavigate();
  const [isRunning, setIsRunning] = useState(false);
  const [time, setTime] = useState(0);
  const [activeWorkout, setActiveWorkout] = useState('Running');

  const workoutTypes = ['Running', 'Strength', 'Yoga', 'HIIT', 'Cycling', 'Walk'];

  useEffect(() => {
    let interval: number | undefined;
    if (isRunning) {
      interval = window.setInterval(() => {
        setTime((prevTime) => prevTime + 1);
      }, 1000);
    }
    return () => {
      if (interval) clearInterval(interval);
    };
  }, [isRunning]);

  const formatTime = (seconds: number) => {
    const hrs = Math.floor(seconds / 3600);
    const mins = Math.floor((seconds % 3600) / 60);
    const secs = seconds % 60;
    return `${hrs.toString().padStart(2, '0')}:${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  };

  const aiWorkouts = [
    { emoji: '🏃', name: 'Morning Run', duration: '30 min', color: '#3b82f6' },
    { emoji: '💪', name: 'Home Strength', duration: '25 min', color: '#f97316' },
    { emoji: '🧘', name: 'Evening Yoga', duration: '20 min', color: '#8b5cf6' },
    { emoji: '🔥', name: 'HIIT Blast', duration: '15 min', color: '#ef4444' },
    { emoji: '🚴', name: 'Cycling', duration: '45 min', color: '#0db9a8' },
    { emoji: '🚶', name: 'Walk', duration: '40 min', color: '#22c55e' },
  ];

  return (
    <div className="min-h-screen bg-[#0a0f1e] text-[#f0f6ff] pb-32">
      <StatusBar />

      {/* Header */}
      <div className="px-6 py-4 flex items-center gap-4">
        <button onClick={() => navigate('/')}>
          <ArrowLeft size={24} />
        </button>
        <h2 className="text-xl font-['Baloo_2'] font-bold">Workout & Fitness</h2>
      </div>

      <div className="px-6 space-y-6">
        {/* Stopwatch Display */}
        <div className="bg-[#111827] border border-white/[0.07] rounded-2xl p-6">
          <div className="text-center mb-4">
            <div className="text-6xl font-['Baloo_2'] font-extrabold tracking-wider mb-2">
              {formatTime(time)}
            </div>
            <div className="text-sm text-[#6b7f9e]">Active Workout</div>
          </div>

          {/* Workout Type Chips */}
          <div className="flex flex-wrap gap-2 justify-center mb-4">
            {workoutTypes.map((type) => (
              <button
                key={type}
                onClick={() => setActiveWorkout(type)}
                className={`px-4 py-2 rounded-full text-sm font-semibold transition-all ${
                  activeWorkout === type
                    ? 'bg-[#3b82f6] text-white'
                    : 'bg-[#1a2235] text-[#6b7f9e]'
                }`}
              >
                {type}
              </button>
            ))}
          </div>

          {/* Control Buttons */}
          <div className="flex gap-3 justify-center">
            <button
              onClick={() => setIsRunning(!isRunning)}
              className="bg-[#3b82f6] hover:bg-[#2563eb] text-white px-8 py-3 rounded-full font-semibold flex items-center gap-2 transition-colors"
            >
              {isRunning ? (
                <>
                  <Pause size={20} /> Pause
                </>
              ) : (
                <>
                  <Play size={20} /> Start
                </>
              )}
            </button>
            <button
              onClick={() => {
                setIsRunning(false);
                setTime(0);
              }}
              className="bg-[#1a2235] hover:bg-[#111827] text-[#f0f6ff] px-8 py-3 rounded-full font-semibold flex items-center gap-2 transition-colors"
            >
              <RotateCcw size={20} /> Reset
            </button>
          </div>
        </div>

        {/* Run Tracker Stats */}
        <div>
          <h3 className="text-base font-['Baloo_2'] font-bold mb-3">Run Tracker</h3>
          <div className="grid grid-cols-3 gap-3">
            <div className="bg-[#111827] border border-white/[0.07] rounded-2xl p-4">
              <div className="text-xs text-[#6b7f9e] mb-1">DISTANCE</div>
              <div className="text-2xl font-['Baloo_2'] font-extrabold text-[#22c55e]">
                4.82
              </div>
              <div className="text-xs text-[#6b7f9e]">KM</div>
            </div>
            <div className="bg-[#111827] border border-white/[0.07] rounded-2xl p-4">
              <div className="text-xs text-[#6b7f9e] mb-1">PACE</div>
              <div className="text-2xl font-['Baloo_2'] font-extrabold text-[#0db9a8]">
                5:42
              </div>
              <div className="text-xs text-[#6b7f9e]">/KM</div>
            </div>
            <div className="bg-[#111827] border border-white/[0.07] rounded-2xl p-4">
              <div className="text-xs text-[#6b7f9e] mb-1">BURNED</div>
              <div className="text-2xl font-['Baloo_2'] font-extrabold text-[#f97316]">
                298
              </div>
              <div className="text-xs text-[#6b7f9e]">KCAL</div>
            </div>
          </div>
        </div>

        {/* Map Placeholder */}
        <div className="bg-[#111827] border border-white/[0.07] rounded-2xl p-6 h-48 flex items-center justify-center relative overflow-hidden">
          <div className="absolute inset-0 opacity-20">
            <svg width="100%" height="100%" viewBox="0 0 300 200">
              <path
                d="M 50 150 Q 100 50, 150 100 T 250 50"
                stroke="#3b82f6"
                strokeWidth="3"
                fill="none"
              />
            </svg>
          </div>
          <div className="text-center z-10">
            <div className="text-4xl mb-2">🗺️</div>
            <div className="text-sm text-[#6b7f9e]">GPS Route Map</div>
          </div>
        </div>

        {/* AI Workout Plans */}
        <div>
          <h3 className="text-base font-['Baloo_2'] font-bold mb-3">
            AI Workout Plans
          </h3>
          <div className="grid grid-cols-2 gap-3">
            {aiWorkouts.map((workout) => (
              <div
                key={workout.name}
                className="bg-[#111827] border border-white/[0.07] rounded-2xl p-4 hover:bg-[#1a2235] transition-colors cursor-pointer"
              >
                <div className="text-3xl mb-2">{workout.emoji}</div>
                <div className="font-semibold mb-1">{workout.name}</div>
                <div className="text-sm" style={{ color: workout.color }}>
                  {workout.duration}
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
