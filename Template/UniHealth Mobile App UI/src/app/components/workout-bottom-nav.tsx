import { Dumbbell, Compass, BarChart3, User } from 'lucide-react';
import { useNavigate, useLocation } from 'react-router';

export function WorkoutBottomNav() {
  const navigate = useNavigate();
  const location = useLocation();

  const navItems = [
    { path: '/training', label: 'Training', icon: Dumbbell },
    { path: '/discover', label: 'Discover', icon: Compass },
    { path: '/report', label: 'Report', icon: BarChart3 },
    { path: '/settings', label: 'Settings', icon: User },
  ];

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 safe-area-inset-bottom">
      <div className="max-w-md mx-auto flex items-center justify-around px-2 py-2">
        {navItems.map((item) => {
          const Icon = item.icon;
          const isActive = location.pathname === item.path;
          return (
            <button
              key={item.path}
              onClick={() => navigate(item.path)}
              className="flex flex-col items-center gap-1 px-4 py-1 min-w-[60px]"
            >
              <Icon
                size={24}
                className={isActive ? 'text-[#0071FF]' : 'text-gray-400'}
                strokeWidth={isActive ? 2.5 : 2}
              />
              <span
                className={`text-xs ${
                  isActive ? 'text-[#0071FF] font-semibold' : 'text-gray-400'
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
