import { Wifi, Battery, Signal } from 'lucide-react';

export function StatusBar() {
  return (
    <div className="flex justify-between items-center px-6 py-3 text-white">
      <span className="text-sm font-semibold">9:41</span>
      <div className="flex items-center gap-1">
        <Signal size={14} />
        <Wifi size={14} />
        <Battery size={16} />
      </div>
    </div>
  );
}
