import { WorkoutBottomNav } from '../../components/workout-bottom-nav';

export function ReportScreen() {
  const weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  const dates = [15, 16, 17, 18, 19, 20, 21];

  return (
    <div className="min-h-screen bg-white pb-20">
      {/* Header */}
      <div className="px-6 pt-6 pb-4">
        <h1 className="text-3xl font-bold">REPORT</h1>
      </div>

      <div className="px-6 space-y-6">
        {/* Stats */}
        <div className="grid grid-cols-3 gap-4">
          <div className="text-center">
            <div className="text-3xl mb-2">🏅</div>
            <div className="text-4xl font-bold mb-1">0</div>
            <div className="text-sm text-gray-500">Workout</div>
          </div>
          <div className="text-center">
            <div className="text-3xl mb-2">💧</div>
            <div className="text-4xl font-bold mb-1">0</div>
            <div className="text-sm text-gray-500">Kcal</div>
          </div>
          <div className="text-center">
            <div className="text-3xl mb-2">⏱️</div>
            <div className="text-4xl font-bold mb-1">0</div>
            <div className="text-sm text-gray-500">Minute</div>
          </div>
        </div>

        {/* History */}
        <div>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-xl font-bold">History</h2>
            <button className="text-[#0071FF] text-sm font-semibold">
              All records
            </button>
          </div>

          {/* Week Calendar */}
          <div className="flex justify-between mb-4">
            {weekDays.map((day, idx) => (
              <div key={idx} className="text-center">
                <div className="text-sm text-gray-500 mb-2">{day}</div>
                <div
                  className={`w-10 h-10 rounded-full flex items-center justify-center ${
                    idx === 6
                      ? 'bg-[#0071FF] text-white'
                      : 'bg-gray-100 text-gray-600'
                  }`}
                >
                  {dates[idx]}
                </div>
              </div>
            ))}
          </div>

          {/* Day Streak */}
          <div className="bg-gray-50 rounded-2xl p-4">
            <div className="flex items-center gap-2">
              <span className="text-2xl">🔥</span>
              <span className="font-semibold">Day Streak</span>
            </div>
            <div className="text-3xl font-bold mt-2">0</div>
          </div>
        </div>

        {/* Weight */}
        <div>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-xl font-bold">Weight</h2>
            <button className="bg-[#0071FF] text-white text-sm font-semibold px-6 py-2 rounded-full">
              Log
            </button>
          </div>

          <div className="grid grid-cols-2 gap-4 mb-4">
            <div>
              <div className="text-sm text-gray-500 mb-1">Current</div>
              <div className="text-2xl font-bold">--</div>
            </div>
            <div className="text-right">
              <div className="text-sm text-gray-500 mb-1">Heaviest</div>
              <div className="text-2xl font-bold">--</div>
              <div className="text-sm text-gray-500 mt-2">Lightest</div>
              <div className="text-2xl font-bold">--</div>
            </div>
          </div>

          {/* Weight Chart */}
          <div className="bg-gray-50 rounded-2xl p-6 h-48 flex items-end">
            <div className="flex items-end justify-between w-full">
              {[700, 600, 500, 400].map((val, idx) => (
                <div key={idx} className="flex flex-col items-start">
                  <div className="text-xs text-gray-400 mb-2">{val}</div>
                  <div className="w-px h-32 bg-gray-200" />
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Ad Banner */}
        <div className="bg-[#00C896] text-white rounded-2xl p-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="text-2xl">💼</div>
            <div>
              <div className="font-bold">Part-Time Jobs - Apply Now</div>
              <div className="text-sm opacity-90">Get started today</div>
            </div>
          </div>
          <button className="text-xl">→</button>
        </div>
      </div>

      <WorkoutBottomNav />
    </div>
  );
}
