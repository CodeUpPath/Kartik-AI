import { StatusBar } from '../components/status-bar';
import { X } from 'lucide-react';
import { useNavigate } from 'react-router';
import { useState } from 'react';

export function AriaScreen() {
  const navigate = useNavigate();
  const [isListening, setIsListening] = useState(true);

  const chatHistory = [
    {
      type: 'user',
      text: 'Kitne steps ho gaye aaj?',
    },
    {
      type: 'aria',
      text: 'Aaj 7,842 steps ho gaye, Rahul! 🎉 Bas 2,158 steps aur chaliye to 10,000 complete ho jayega!',
    },
    {
      type: 'user',
      text: 'Breakfast mein kya khaya tha?',
    },
    {
      type: 'aria',
      text: 'Aapne 9 baje Poha khaya tha — 320 calories. Very healthy choice! 👍',
    },
  ];

  const quickCommands = ['Kitne steps?', 'Workout start', 'Food scan', 'Health score?'];

  return (
    <div className="min-h-screen bg-[#0a0f1e] text-[#f0f6ff] flex flex-col">
      <StatusBar />

      {/* Header */}
      <div className="px-6 py-4 flex justify-between items-center">
        <div className="bg-[#8b5cf6]/20 text-[#8b5cf6] text-xs font-bold px-3 py-1 rounded-full">
          हिन्दी + English
        </div>
        <button onClick={() => navigate('/')}>
          <X size={24} />
        </button>
      </div>

      {/* Main Content */}
      <div className="flex-1 flex flex-col items-center justify-center px-6">
        {/* ARIA Avatar */}
        <div className="relative mb-8">
          {/* Animated rings */}
          <div className="absolute inset-0 flex items-center justify-center">
            <div className="w-48 h-48 rounded-full bg-gradient-to-br from-[#8b5cf6]/20 to-[#3b82f6]/20 animate-pulse" />
          </div>
          <div className="absolute inset-0 flex items-center justify-center">
            <div className="w-40 h-40 rounded-full bg-gradient-to-br from-[#8b5cf6]/30 to-[#3b82f6]/30 animate-pulse delay-75" />
          </div>
          {/* Avatar */}
          <div className="relative w-32 h-32 mx-auto rounded-full bg-gradient-to-br from-[#8b5cf6] to-[#3b82f6] flex items-center justify-center">
            <span className="text-6xl">🤖</span>
          </div>
        </div>

        {/* Listening State */}
        <div className="text-center mb-8">
          <div className="text-lg font-semibold mb-4">
            {isListening
              ? 'Suno raha hoon... Hindi ya English mein bolo'
              : 'Tap to speak'}
          </div>

          {/* Audio Wave Visualization */}
          {isListening && (
            <div className="flex items-center justify-center gap-1 mb-6">
              {[1, 2, 3, 4].map((i) => (
                <div
                  key={i}
                  className="w-1 bg-gradient-to-t from-[#3b82f6] to-[#8b5cf6] rounded-full animate-pulse"
                  style={{
                    height: `${Math.random() * 40 + 20}px`,
                    animationDelay: `${i * 0.1}s`,
                  }}
                />
              ))}
            </div>
          )}
        </div>

        {/* Quick Commands */}
        <div className="w-full mb-8">
          <div className="text-sm text-[#6b7f9e] mb-3 text-center">
            Quick Commands
          </div>
          <div className="flex flex-wrap gap-2 justify-center">
            {quickCommands.map((command) => (
              <button
                key={command}
                className="bg-[#111827] border border-white/[0.07] text-sm px-4 py-2 rounded-full hover:bg-[#1a2235] transition-colors"
              >
                "{command}"
              </button>
            ))}
          </div>
        </div>

        {/* Chat History */}
        <div className="w-full max-w-md space-y-4 max-h-64 overflow-y-auto">
          <div className="text-xs text-[#6b7f9e] mb-2 text-center">
            Recent Conversation
          </div>
          {chatHistory.map((message, index) => (
            <div
              key={index}
              className={`flex ${
                message.type === 'user' ? 'justify-end' : 'justify-start'
              }`}
            >
              <div
                className={`max-w-[80%] px-4 py-3 rounded-2xl ${
                  message.type === 'user'
                    ? 'bg-[#3b82f6] text-white'
                    : 'bg-gradient-to-br from-[#8b5cf6] to-[#3b82f6] text-white'
                }`}
              >
                <p className="text-sm">{message.text}</p>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Bottom Mic Button */}
      <div className="pb-8 flex justify-center">
        <button
          onClick={() => setIsListening(!isListening)}
          className="w-20 h-20 rounded-full bg-gradient-to-br from-[#8b5cf6] to-[#3b82f6] shadow-lg shadow-purple-500/50 flex items-center justify-center"
        >
          <svg
            width="32"
            height="32"
            viewBox="0 0 24 24"
            fill="none"
            stroke="white"
            strokeWidth="2"
            strokeLinecap="round"
            strokeLinejoin="round"
          >
            <path d="M12 2a3 3 0 0 0-3 3v7a3 3 0 0 0 6 0V5a3 3 0 0 0-3-3z" />
            <path d="M19 10v2a7 7 0 0 1-14 0v-2" />
            <line x1="12" y1="19" x2="12" y2="22" />
          </svg>
        </button>
      </div>
    </div>
  );
}
