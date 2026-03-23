import { StatusBar } from '../components/status-bar';
import { BottomNav } from '../components/bottom-nav';
import { FloatingMic } from '../components/floating-mic';
import { ArrowLeft, Crown } from 'lucide-react';
import { useNavigate } from 'react-router';
import { useState } from 'react';

export function ProfileScreen() {
  const navigate = useNavigate();
  const [activeLanguages, setActiveLanguages] = useState(['Hindi', 'English']);
  const [specialModes, setSpecialModes] = useState({
    navratri: false,
    lowData: true,
    pregnancy: false,
    pcos: false,
  });

  const languages = [
    'हिन्दी',
    'English',
    'Tamil',
    'Bengali',
    'Telugu',
    'Punjabi',
    'Gujarati',
    'Marathi',
  ];

  const devices = [
    { name: 'Galaxy Watch 6', connected: true, live: true },
    { name: 'Apple Watch', connected: false, live: false },
    { name: 'Mi Band', connected: false, live: false },
  ];

  const toggleLanguage = (lang: string) => {
    if (activeLanguages.includes(lang)) {
      if (activeLanguages.length > 1) {
        setActiveLanguages(activeLanguages.filter((l) => l !== lang));
      }
    } else {
      setActiveLanguages([...activeLanguages, lang]);
    }
  };

  return (
    <div className="min-h-screen bg-[#0a0f1e] text-[#f0f6ff] pb-32">
      <StatusBar />

      {/* Header */}
      <div className="px-6 py-4 flex items-center gap-4">
        <button onClick={() => navigate('/')}>
          <ArrowLeft size={24} />
        </button>
        <h2 className="text-xl font-['Baloo_2'] font-bold">Profile & Settings</h2>
      </div>

      <div className="px-6 space-y-6">
        {/* Profile Card */}
        <div className="bg-[#111827] border border-white/[0.07] rounded-2xl p-6">
          <div className="flex flex-col items-center">
            <div className="w-24 h-24 rounded-full bg-gradient-to-br from-[#3b82f6] to-[#8b5cf6] flex items-center justify-center text-3xl font-['Baloo_2'] font-bold mb-4">
              RS
            </div>
            <div className="text-xl font-['Baloo_2'] font-bold mb-1">
              Rahul Sharma
            </div>
            <div className="flex items-center gap-2 text-sm text-[#6b7f9e] mb-4">
              <Crown size={14} className="text-[#eab308]" />
              <span>UniHealth Pro · Jaipur</span>
            </div>
          </div>
        </div>

        {/* Health Metrics */}
        <div>
          <h3 className="text-base font-['Baloo_2'] font-bold mb-3">
            Health Metrics
          </h3>
          <div className="grid grid-cols-2 gap-3">
            {[
              { label: 'BMI', value: '24.2', color: '#3b82f6' },
              { label: 'Weight', value: '72kg', color: '#22c55e' },
              { label: 'Height', value: '5\'10"', color: '#f97316' },
              { label: 'Age', value: '28', color: '#8b5cf6' },
            ].map((metric) => (
              <div
                key={metric.label}
                className="bg-[#111827] border border-white/[0.07] rounded-2xl p-4"
              >
                <div className="text-xs text-[#6b7f9e] mb-1">
                  {metric.label}
                </div>
                <div
                  className="text-2xl font-['Baloo_2'] font-extrabold"
                  style={{ color: metric.color }}
                >
                  {metric.value}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Language Selector */}
        <div>
          <h3 className="text-base font-['Baloo_2'] font-bold mb-3">
            Languages
          </h3>
          <div className="flex flex-wrap gap-2">
            {languages.map((lang) => {
              const isActive =
                activeLanguages.includes(lang) ||
                (lang === 'हिन्दी' && activeLanguages.includes('Hindi')) ||
                (lang === 'English' && activeLanguages.includes('English'));
              return (
                <button
                  key={lang}
                  onClick={() => toggleLanguage(lang)}
                  className={`px-4 py-2 rounded-full text-sm font-semibold transition-all ${
                    isActive
                      ? 'bg-[#3b82f6] text-white'
                      : 'bg-[#111827] text-[#6b7f9e] border border-white/[0.07]'
                  }`}
                >
                  {lang}
                </button>
              );
            })}
          </div>
        </div>

        {/* Connected Devices */}
        <div>
          <h3 className="text-base font-['Baloo_2'] font-bold mb-3">
            Connected Devices
          </h3>
          <div className="space-y-2">
            {devices.map((device) => (
              <div
                key={device.name}
                className="bg-[#111827] border border-white/[0.07] rounded-2xl p-4 flex items-center justify-between"
              >
                <div className="flex items-center gap-3">
                  <div
                    className={`w-10 h-10 rounded-xl flex items-center justify-center ${
                      device.connected ? 'bg-[#3b82f6]/20' : 'bg-[#1a2235]'
                    }`}
                  >
                    <span className="text-xl">⌚</span>
                  </div>
                  <div>
                    <div className="font-semibold">{device.name}</div>
                    <div className="text-xs text-[#6b7f9e]">
                      {device.connected ? 'Connected' : 'Not connected'}
                    </div>
                  </div>
                </div>
                {device.live && (
                  <div className="bg-[#22c55e] text-white text-[10px] font-bold px-3 py-1 rounded-full">
                    LIVE
                  </div>
                )}
              </div>
            ))}
          </div>
        </div>

        {/* Special Modes */}
        <div>
          <h3 className="text-base font-['Baloo_2'] font-bold mb-3">
            Special Modes
          </h3>
          <div className="space-y-2">
            {[
              { key: 'navratri', label: 'Navratri Fast Mode', emoji: '🌙' },
              { key: 'lowData', label: 'Low Data Mode', emoji: '📡' },
              { key: 'pregnancy', label: 'Pregnancy Planning', emoji: '🤰' },
              { key: 'pcos', label: 'PCOS Mode', emoji: '💊' },
            ].map((mode) => (
              <div
                key={mode.key}
                className="bg-[#111827] border border-white/[0.07] rounded-2xl p-4 flex items-center justify-between"
              >
                <div className="flex items-center gap-3">
                  <span className="text-2xl">{mode.emoji}</span>
                  <span className="font-semibold">{mode.label}</span>
                </div>
                <button
                  onClick={() =>
                    setSpecialModes({
                      ...specialModes,
                      [mode.key]: !specialModes[mode.key as keyof typeof specialModes],
                    })
                  }
                  className={`w-12 h-6 rounded-full transition-colors ${
                    specialModes[mode.key as keyof typeof specialModes]
                      ? 'bg-[#3b82f6]'
                      : 'bg-[#1a2235]'
                  }`}
                >
                  <div
                    className={`w-5 h-5 rounded-full bg-white transition-transform ${
                      specialModes[mode.key as keyof typeof specialModes]
                        ? 'translate-x-6'
                        : 'translate-x-0.5'
                    }`}
                  />
                </button>
              </div>
            ))}
          </div>
        </div>

        {/* Plan Badge */}
        <div className="bg-gradient-to-br from-[#eab308] to-[#f97316] rounded-2xl p-5 border border-white/[0.1]">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <Crown size={28} className="text-white" />
              <div>
                <div className="font-['Baloo_2'] font-bold text-lg">
                  UniHealth Pro
                </div>
                <div className="text-sm opacity-90">₹199/month</div>
              </div>
            </div>
            <button className="bg-white text-[#eab308] font-bold px-4 py-2 rounded-full text-sm">
              Manage
            </button>
          </div>
        </div>
      </div>

      <FloatingMic />
      <BottomNav />
    </div>
  );
}
