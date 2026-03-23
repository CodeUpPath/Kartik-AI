import { useNavigate } from 'react-router';
import { useState } from 'react';
import { ArrowLeft } from 'lucide-react';
import img2 from 'figma:asset/42acdc323215cd7bde16f9e980b5d4723c8a3200.png';

export function FocusScreen() {
  const navigate = useNavigate();
  const [selected, setSelected] = useState<string[]>([]);

  const areas = ['Full Body', 'Arm', 'Chest', 'Abs', 'Leg'];

  const toggleArea = (area: string) => {
    if (selected.includes(area)) {
      setSelected(selected.filter((a) => a !== area));
    } else {
      setSelected([...selected, area]);
    }
  };

  return (
    <div className="min-h-screen bg-white flex flex-col">
      {/* Header */}
      <div className="px-6 pt-3">
        <div className="text-sm mb-2">10:41</div>
        <div className="flex items-center justify-between py-2">
          <button onClick={() => navigate('/gender')}>
            <ArrowLeft size={24} />
          </button>
          <div className="flex-1 mx-4">
            <div className="h-1 bg-gray-200 rounded-full overflow-hidden">
              <div className="h-full bg-[#0071FF] w-[28%]" />
            </div>
          </div>
          <button onClick={() => navigate('/goals')} className="text-gray-400 text-sm">
            Skip
          </button>
        </div>
      </div>

      {/* Content */}
      <div className="flex-1 px-6 flex">
        <div className="flex-1">
          <h1 className="text-2xl font-bold mb-8">Please choose your focus area</h1>

          {/* Options List */}
          <div className="space-y-3">
            {areas.map((area) => (
              <button
                key={area}
                onClick={() => toggleArea(area)}
                className={`w-full text-left px-5 py-4 rounded-2xl border-2 font-semibold transition-all ${
                  selected.includes(area)
                    ? 'border-[#0071FF] bg-[#0071FF]/5'
                    : 'border-gray-200 bg-white'
                }`}
              >
                {area}
              </button>
            ))}
          </div>
        </div>

        {/* Image on right */}
        <div className="flex items-center justify-end ml-4">
          <img src={img2} alt="Focus areas" className="w-48 object-contain" />
        </div>
      </div>

      {/* Bottom Button */}
      <div className="px-6 pb-8">
        <button
          onClick={() => navigate('/goals')}
          disabled={selected.length === 0}
          className={`w-full font-semibold py-4 rounded-full text-lg transition-colors ${
            selected.length > 0
              ? 'bg-[#0071FF] text-white'
              : 'bg-gray-200 text-gray-400'
          }`}
        >
          NEXT
        </button>
      </div>
    </div>
  );
}
