import { WorkoutBottomNav } from '../../components/workout-bottom-nav';

export function DiscoverScreen() {
  return (
    <div className="min-h-screen bg-white pb-20">
      <div className="px-6 pt-6">
        <h1 className="text-3xl font-bold mb-6">DISCOVER</h1>
        <div className="flex items-center justify-center h-96">
          <div className="text-center text-gray-400">
            <div className="text-6xl mb-4">🔍</div>
            <p className="text-lg">Discover new workouts</p>
          </div>
        </div>
      </div>
      <WorkoutBottomNav />
    </div>
  );
}
