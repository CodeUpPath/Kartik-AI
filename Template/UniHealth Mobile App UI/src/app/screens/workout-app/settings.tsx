import { WorkoutBottomNav } from '../../components/workout-bottom-nav';
import { ChevronRight } from 'lucide-react';

export function SettingsScreen() {
  const settingsItems = [
    { icon: '👤', label: 'Profile', subtitle: 'Edit your personal information' },
    { icon: '⚙️', label: 'Preferences', subtitle: 'Customize your experience' },
    { icon: '🔔', label: 'Notifications', subtitle: 'Manage notifications' },
    { icon: '💳', label: 'Subscription', subtitle: 'Manage your plan' },
    { icon: '❓', label: 'Help & Support', subtitle: 'Get help' },
  ];

  return (
    <div className="min-h-screen bg-white pb-20">
      <div className="px-6 pt-6">
        <h1 className="text-3xl font-bold mb-6">SETTINGS</h1>

        <div className="space-y-2">
          {settingsItems.map((item) => (
            <button
              key={item.label}
              className="w-full bg-white border-2 border-gray-100 rounded-2xl p-4 flex items-center gap-4 hover:bg-gray-50 transition-colors"
            >
              <div className="text-3xl">{item.icon}</div>
              <div className="flex-1 text-left">
                <div className="font-semibold">{item.label}</div>
                <div className="text-sm text-gray-500">{item.subtitle}</div>
              </div>
              <ChevronRight size={20} className="text-gray-400" />
            </button>
          ))}
        </div>
      </div>
      <WorkoutBottomNav />
    </div>
  );
}
