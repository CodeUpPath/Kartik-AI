import { Mic } from 'lucide-react';
import { useNavigate } from 'react-router';

export function FloatingMic() {
  const navigate = useNavigate();

  return (
    <button
      onClick={() => navigate('/aria')}
      className="fixed bottom-24 right-6 w-14 h-14 rounded-full bg-gradient-to-br from-[#8b5cf6] to-[#3b82f6] shadow-lg shadow-purple-500/50 flex items-center justify-center z-50"
    >
      <Mic size={24} className="text-white" />
    </button>
  );
}
