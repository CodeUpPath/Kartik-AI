import { StatusBar } from '../components/status-bar';
import { FloatingMic } from '../components/floating-mic';
import { ArrowLeft, Plus, AlertCircle, Users } from 'lucide-react';
import { useNavigate } from 'react-router';

export function FamilyScreen() {
  const navigate = useNavigate();

  const familyMembers = [
    {
      name: 'Rahul',
      role: 'Admin',
      avatar: 'RS',
      score: 82,
      color: '#3b82f6',
      badge: null,
    },
    {
      name: 'Priya',
      role: 'Wife',
      avatar: 'PS',
      score: 91,
      color: '#ec4899',
      badge: 'Period Tracker',
    },
    {
      name: 'Aarav',
      role: 'Son, 9yr',
      avatar: 'AS',
      score: 74,
      color: '#22c55e',
      badge: 'Child Mode',
    },
    {
      name: 'Papa',
      role: '58yr',
      avatar: 'MS',
      score: 62,
      color: '#ef4444',
      badge: 'BP Alert',
    },
  ];

  return (
    <div className="min-h-screen bg-[#f0f4ff] text-[#0a0f1e] pb-32">
      <StatusBar />

      {/* Header */}
      <div className="px-6 py-4 flex items-center justify-between bg-white border-b border-gray-200">
        <div className="flex items-center gap-4">
          <button onClick={() => navigate('/')}>
            <ArrowLeft size={24} className="text-[#0a0f1e]" />
          </button>
          <div>
            <div className="flex items-center gap-2">
              <Users size={20} className="text-[#3b82f6]" />
              <h2 className="text-xl font-['Baloo_2'] font-bold">
                Family Health Hub
              </h2>
            </div>
            <div className="text-sm text-gray-500">Sharma Family</div>
          </div>
        </div>
        <button className="bg-[#3b82f6] text-white px-4 py-2 rounded-full text-sm font-semibold flex items-center gap-2">
          <Plus size={16} /> Add Member
        </button>
      </div>

      <div className="px-6 py-6 space-y-6">
        {/* Alert Banner */}
        <div className="bg-[#ef4444] text-white rounded-2xl p-4 flex items-start gap-3">
          <AlertCircle size={24} className="flex-shrink-0 mt-0.5" />
          <div>
            <div className="font-semibold mb-1">Health Alert</div>
            <div className="text-sm opacity-90">
              Papa's BP high today — 148/92. Please consult doctor.
            </div>
          </div>
        </div>

        {/* Family Members Grid */}
        <div>
          <h3 className="text-base font-['Baloo_2'] font-bold mb-3 text-[#0a0f1e]">
            Family Members
          </h3>
          <div className="grid grid-cols-2 gap-3">
            {familyMembers.map((member) => (
              <div
                key={member.name}
                className="bg-white rounded-2xl p-5 border-2 shadow-sm"
                style={{ borderColor: member.color }}
              >
                <div className="flex flex-col items-center">
                  {/* Avatar */}
                  <div
                    className="w-16 h-16 rounded-full flex items-center justify-center text-white text-xl font-['Baloo_2'] font-bold mb-3"
                    style={{
                      background: `linear-gradient(135deg, ${member.color}, ${member.color}dd)`,
                    }}
                  >
                    {member.avatar}
                  </div>

                  {/* Name & Role */}
                  <div className="font-['Baloo_2'] font-bold mb-1">
                    {member.name}
                  </div>
                  <div className="text-xs text-gray-500 mb-3">{member.role}</div>

                  {/* Score */}
                  <div className="relative mb-3">
                    <svg width="80" height="80" className="transform -rotate-90">
                      <circle
                        cx="40"
                        cy="40"
                        r="32"
                        fill="none"
                        stroke="#e5e7eb"
                        strokeWidth="6"
                      />
                      <circle
                        cx="40"
                        cy="40"
                        r="32"
                        fill="none"
                        stroke={member.color}
                        strokeWidth="6"
                        strokeDasharray={`${(member.score / 100) * 201} 201`}
                      />
                    </svg>
                    <div className="absolute inset-0 flex items-center justify-center">
                      <div
                        className="text-2xl font-['Baloo_2'] font-extrabold"
                        style={{ color: member.color }}
                      >
                        {member.score}
                      </div>
                    </div>
                  </div>

                  {/* Badge */}
                  {member.badge && (
                    <div
                      className="text-xs font-bold px-3 py-1 rounded-full"
                      style={{
                        backgroundColor: `${member.color}20`,
                        color: member.color,
                      }}
                    >
                      {member.badge}
                    </div>
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Family UniScore Leaderboard */}
        <div className="bg-white rounded-2xl p-5 border border-gray-200">
          <h3 className="text-base font-['Baloo_2'] font-bold mb-4 text-[#0a0f1e]">
            Family Leaderboard
          </h3>
          <div className="space-y-3">
            {familyMembers
              .sort((a, b) => b.score - a.score)
              .map((member, index) => (
                <div key={member.name} className="flex items-center gap-3">
                  <div
                    className="w-8 h-8 rounded-full flex items-center justify-center font-bold text-white"
                    style={{ backgroundColor: member.color }}
                  >
                    {index + 1}
                  </div>
                  <div className="flex-1">
                    <div className="font-semibold">{member.name}</div>
                    <div className="h-2 bg-gray-100 rounded-full overflow-hidden mt-1">
                      <div
                        className="h-full rounded-full"
                        style={{
                          width: `${member.score}%`,
                          backgroundColor: member.color,
                        }}
                      />
                    </div>
                  </div>
                  <div
                    className="text-xl font-['Baloo_2'] font-extrabold"
                    style={{ color: member.color }}
                  >
                    {member.score}
                  </div>
                </div>
              ))}
          </div>
        </div>

        {/* Family Stats */}
        <div className="bg-white rounded-2xl p-5 border border-gray-200">
          <h3 className="text-base font-['Baloo_2'] font-bold mb-4 text-[#0a0f1e]">
            Family Stats
          </h3>
          <div className="grid grid-cols-2 gap-3">
            <div className="bg-[#3b82f6]/10 rounded-xl p-3">
              <div className="text-xs text-gray-500 mb-1">Avg Score</div>
              <div className="text-2xl font-['Baloo_2'] font-extrabold text-[#3b82f6]">
                77.3
              </div>
            </div>
            <div className="bg-[#22c55e]/10 rounded-xl p-3">
              <div className="text-xs text-gray-500 mb-1">Total Steps</div>
              <div className="text-2xl font-['Baloo_2'] font-extrabold text-[#22c55e]">
                24.5K
              </div>
            </div>
            <div className="bg-[#f97316]/10 rounded-xl p-3">
              <div className="text-xs text-gray-500 mb-1">Workouts</div>
              <div className="text-2xl font-['Baloo_2'] font-extrabold text-[#f97316]">
                12
              </div>
            </div>
            <div className="bg-[#8b5cf6]/10 rounded-xl p-3">
              <div className="text-xs text-gray-500 mb-1">Members</div>
              <div className="text-2xl font-['Baloo_2'] font-extrabold text-[#8b5cf6]">
                4
              </div>
            </div>
          </div>
        </div>

        {/* Quick Actions */}
        <div className="bg-gradient-to-br from-[#3b82f6] to-[#8b5cf6] rounded-2xl p-5 text-white">
          <h3 className="text-base font-['Baloo_2'] font-bold mb-3">
            Family Goals
          </h3>
          <div className="space-y-2">
            <div className="bg-white/20 rounded-xl p-3 flex items-center justify-between">
              <span className="text-sm">Weekly Steps Goal</span>
              <span className="font-bold">85%</span>
            </div>
            <div className="bg-white/20 rounded-xl p-3 flex items-center justify-between">
              <span className="text-sm">Healthy Meals Together</span>
              <span className="font-bold">12/21</span>
            </div>
          </div>
        </div>
      </div>

      <FloatingMic />
    </div>
  );
}
