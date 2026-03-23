import { BrowserRouter, Routes, Route, Navigate } from 'react-router';
import { GenderScreen } from './screens/onboarding/gender';
import { FocusScreen } from './screens/onboarding/focus';
import { GoalsScreen } from './screens/onboarding/goals';
import { LevelScreen } from './screens/onboarding/level';
import { WeeklyScreen } from './screens/onboarding/weekly';
import { PersonalScreen } from './screens/onboarding/personal';
import { TrainingScreen } from './screens/workout-app/training';
import { DiscoverScreen } from './screens/workout-app/discover';
import { ReportScreen } from './screens/workout-app/report';
import { SettingsScreen } from './screens/workout-app/settings';

export default function App() {
  return (
    <BrowserRouter>
      <div className="max-w-md mx-auto bg-white min-h-screen relative">
        <Routes>
          {/* Onboarding Flow */}
          <Route path="/" element={<GenderScreen />} />
          <Route path="/gender" element={<GenderScreen />} />
          <Route path="/focus" element={<FocusScreen />} />
          <Route path="/goals" element={<GoalsScreen />} />
          <Route path="/level" element={<LevelScreen />} />
          <Route path="/weekly" element={<WeeklyScreen />} />
          <Route path="/personal" element={<PersonalScreen />} />

          {/* Main App */}
          <Route path="/training" element={<TrainingScreen />} />
          <Route path="/discover" element={<DiscoverScreen />} />
          <Route path="/report" element={<ReportScreen />} />
          <Route path="/settings" element={<SettingsScreen />} />

          <Route path="*" element={<Navigate to="/gender" replace />} />
        </Routes>
      </div>
    </BrowserRouter>
  );
}
