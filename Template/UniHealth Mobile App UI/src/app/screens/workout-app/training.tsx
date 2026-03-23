import { Search, Crown, Edit2, X } from 'lucide-react';
import { WorkoutBottomNav } from '../../components/workout-bottom-nav';
import { useState } from 'react';
import img8 from 'figma:asset/343a65b5705986bfb15687d9f33c4d2057990414.png';

export function TrainingScreen() {
  const [showModal, setShowModal] = useState(false);

  const weekDays = [15, 16, 17, 18, 19, 20, 21];
  const bodyFocus = ['Abs', 'Arm', 'Chest', 'Leg', 'Shoulder'];

  return (
    <div className="min-h-screen bg-white pb-20">
      {/* Header */}
      <div className="px-6 pt-3 pb-4 bg-white">
        <div className="flex items-center justify-between mb-4">
          <h1 className="text-2xl font-bold">HOME WORKOUT</h1>
          <div className="flex items-center gap-3">
            <button className="text-red-500">
              <span className="text-2xl">🔥</span>
            </button>
            <button className="bg-[#FFB800] text-white px-3 py-1 rounded-lg flex items-center gap-1">
              <Crown size={16} />
              <span className="text-sm font-bold">PRO+</span>
            </button>
          </div>
        </div>

        {/* Search */}
        <div className="relative">
          <Search
            size={20}
            className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400"
          />
          <input
            type="text"
            placeholder="Search workouts, plans..."
            className="w-full bg-gray-100 rounded-2xl pl-12 pr-4 py-3 text-sm"
          />
        </div>
      </div>

      <div className="px-6 space-y-6">
        {/* Weekly Goal */}
        <div>
          <div className="flex items-center justify-between mb-3">
            <h2 className="text-xl font-bold">Weekly Goal</h2>
            <div className="flex items-center gap-2">
              <span className="text-[#0071FF] font-bold text-lg">0/4</span>
              <button>
                <Edit2 size={18} className="text-gray-400" />
              </button>
            </div>
          </div>

          {/* Week Calendar */}
          <div className="flex gap-2">
            {weekDays.map((day) => (
              <button
                key={day}
                className={`flex-1 py-2 rounded-xl text-center ${
                  day === 21
                    ? 'bg-[#0071FF] text-white'
                    : 'bg-gray-100 text-gray-400'
                }`}
              >
                <div className="text-xs font-medium">{day}</div>
              </button>
            ))}
          </div>
        </div>

        {/* Motivation Card */}
        <div className="bg-gray-100 rounded-2xl p-4 flex items-center gap-3">
          <div className="w-12 h-12 rounded-full bg-white flex items-center justify-center overflow-hidden">
            <img
              src={img8}
              alt="trainer"
              className="w-full h-full object-cover"
            />
          </div>
          <p className="flex-1 text-sm">
            <span className="font-semibold">
              Your workout awaits you! Time to make the first step!
            </span>
          </p>
        </div>

        {/* Challenge Section */}
        <div>
          <h2 className="text-xl font-bold mb-3">Challenge</h2>
          <div className="flex gap-3 overflow-x-auto pb-2">
            {/* Challenge Card 1 */}
            <div className="flex-shrink-0 w-80 bg-[#0071FF] rounded-3xl p-6 text-white relative overflow-hidden">
              <div className="relative z-10">
                <div className="text-sm font-semibold mb-1">28 DAYS</div>
                <h3 className="text-2xl font-bold mb-4">
                  FULL BODY
                  <br />
                  CHALLENGE
                </h3>
                <p className="text-sm opacity-90 mb-6">
                  Start your body-toning journey to target all muscle groups and
                  build your dream body in 4 weeks!
                </p>
                <button className="bg-white text-[#0071FF] font-bold px-8 py-3 rounded-full">
                  START
                </button>
              </div>
              <div className="absolute right-0 top-0 w-48 h-full">
                <img
                  src={img8}
                  alt="challenge"
                  className="w-full h-full object-cover opacity-40"
                />
              </div>
            </div>

            {/* Challenge Card 2 */}
            <div className="flex-shrink-0 w-80 bg-[#FF6838] rounded-3xl p-6 text-white">
              <div className="text-sm font-semibold mb-1">30 DAYS</div>
              <h3 className="text-2xl font-bold mb-4">
                LOSE FAT
                <br />
                CHALLENGE
              </h3>
              <p className="text-sm opacity-90 mb-6">
                Lose maximum fat in a day!
              </p>
              <button className="bg-white text-[#FF6838] font-bold px-8 py-3 rounded-full">
                START
              </button>
            </div>
          </div>
        </div>

        {/* Body Focus */}
        <div>
          <h2 className="text-xl font-bold mb-3">Body Focus</h2>
          <div className="flex gap-2 overflow-x-auto pb-2">
            {bodyFocus.map((focus, idx) => (
              <button
                key={focus}
                className={`flex-shrink-0 px-5 py-2 rounded-full font-semibold ${
                  idx === 0
                    ? 'bg-[#0071FF] text-white border-2 border-[#0071FF]'
                    : 'bg-white text-gray-600 border-2 border-gray-200'
                }`}
              >
                {focus}
              </button>
            ))}
          </div>

          {/* Workout Cards */}
          <div className="grid grid-cols-2 gap-3 mt-4">
            {[1, 2].map((item) => (
              <button
                key={item}
                onClick={() => setShowModal(true)}
                className="aspect-square rounded-2xl overflow-hidden relative"
              >
                <img
                  src={img8}
                  alt={`workout ${item}`}
                  className="w-full h-full object-cover"
                />
                <div className="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/80 to-transparent p-3">
                  <div className="text-white text-left">
                    <div className="font-bold">ABS Workout</div>
                    <div className="text-xs opacity-80">15 exercises</div>
                  </div>
                </div>
              </button>
            ))}
          </div>
        </div>
      </div>

      <WorkoutBottomNav />

      {/* First Workout Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-6">
          <div className="bg-[#0071FF] rounded-3xl p-8 max-w-sm w-full text-white text-center relative">
            <button
              onClick={() => setShowModal(false)}
              className="absolute top-4 left-4 text-white/80"
            >
              <X size={24} />
            </button>

            <div className="mb-6">
              <img
                src={img8}
                alt="first workout"
                className="w-48 h-48 mx-auto object-contain"
              />
            </div>

            <h2 className="text-3xl font-bold mb-3">
              Embark on your first workout!
            </h2>
            <p className="text-sm opacity-90 mb-8">
              Try these top exercises for a FULL-BODY SHRED!
            </p>

            <button
              onClick={() => setShowModal(false)}
              className="w-full bg-white text-[#0071FF] font-bold py-4 rounded-full text-lg"
            >
              Let's Go!
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
