import { Home, Dumbbell, Utensils, CheckSquare, User } from 'lucide-react';
import { useLocation, useNavigate } from 'react-router';

export function BottomNav() {
  const location = useLocation();
  const navigate = useNavigate();

  const navItems = [
    { icon: Home, label: 'Home', path: '/' },
    { icon: Dumbbell, label: 'Workout', path: '/workout' },
    { icon: Utensils, label: 'Food', path: '/food' },
    { icon: CheckSquare, label: 'To-Do', path: '/todo' },
    { icon: User, label: 'Profile', path: '/profile' },
  ];

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-[#111827] border-t border-white/[0.07] px-2 pb-6 pt-2">
      <div className="flex justify-around items-center max-w-md mx-auto">
        {navItems.map((item) => {
          const isActive = location.pathname === item.path;
          const Icon = item.icon;
          return (
            <button
              key={item.path}
              onClick={() => navigate(item.path)}
              className="flex flex-col items-center gap-1 px-4 py-2"
            >
              <div
                className={`p-2 rounded-full transition-all ${
                  isActive ? 'bg-[#3b82f6]' : 'bg-transparent'
                }`}
              >
                <Icon
                  size={22}
                  strokeWidth={2}
                  className={isActive ? 'text-white' : 'text-[#6b7f9e]'}
                />
              </div>
              <span
                className={`text-[10px] font-semibold ${
                  isActive ? 'text-[#f0f6ff]' : 'text-[#6b7f9e]'
                }`}
              >
                {item.label}
              </span>
            </button>
          );
        })}
      </div>
    </div>
  );
}
