import { StatusBar } from '../components/status-bar';
import { BottomNav } from '../components/bottom-nav';
import { FloatingMic } from '../components/floating-mic';
import { ArrowLeft, Plus, Sparkles } from 'lucide-react';
import { useNavigate } from 'react-router';
import { useState } from 'react';

interface TodoItem {
  id: number;
  text: string;
  category: string;
  categoryColor: string;
  completed: boolean;
}

export function TodoScreen() {
  const navigate = useNavigate();
  const [newTask, setNewTask] = useState('');
  const [todos, setTodos] = useState<TodoItem[]>([
    {
      id: 1,
      text: '10,000 steps today',
      category: 'health',
      categoryColor: '#22c55e',
      completed: true,
    },
    {
      id: 2,
      text: 'Drink 8 glasses of water',
      category: 'health',
      categoryColor: '#3b82f6',
      completed: true,
    },
    {
      id: 3,
      text: 'Morning yoga session',
      category: 'workout',
      categoryColor: '#8b5cf6',
      completed: true,
    },
    {
      id: 4,
      text: 'Log lunch calories',
      category: 'food',
      categoryColor: '#f97316',
      completed: false,
    },
    {
      id: 5,
      text: 'Evening run 5km',
      category: 'workout',
      categoryColor: '#0db9a8',
      completed: false,
    },
  ]);

  const completedCount = todos.filter((t) => t.completed).length;

  const toggleTodo = (id: number) => {
    setTodos(
      todos.map((todo) =>
        todo.id === id ? { ...todo, completed: !todo.completed } : todo
      )
    );
  };

  const addTodo = () => {
    if (newTask.trim()) {
      setTodos([
        ...todos,
        {
          id: Date.now(),
          text: newTask,
          category: 'health',
          categoryColor: '#22c55e',
          completed: false,
        },
      ]);
      setNewTask('');
    }
  };

  const weeklyData = [
    { day: 'Mon', value: 4 },
    { day: 'Tue', value: 5 },
    { day: 'Wed', value: 3 },
    { day: 'Thu', value: 5 },
    { day: 'Fri', value: 4 },
    { day: 'Sat', value: 3 },
    { day: 'Sun', value: 5 },
  ];

  return (
    <div className="min-h-screen bg-[#0a0f1e] text-[#f0f6ff] pb-32">
      <StatusBar />

      {/* Header */}
      <div className="px-6 py-4 flex items-center justify-between">
        <div className="flex items-center gap-4">
          <button onClick={() => navigate('/')}>
            <ArrowLeft size={24} />
          </button>
          <h2 className="text-xl font-['Baloo_2'] font-bold">Health To-Do</h2>
        </div>
        <div className="bg-[#22c55e] text-white text-xs font-bold px-3 py-1 rounded-full">
          {completedCount}/{todos.length} done
        </div>
      </div>

      <div className="px-6 space-y-6">
        {/* Add Task Input */}
        <div className="flex gap-2">
          <input
            type="text"
            value={newTask}
            onChange={(e) => setNewTask(e.target.value)}
            onKeyPress={(e) => e.key === 'Enter' && addTodo()}
            placeholder="Add a health goal..."
            className="flex-1 bg-[#111827] border border-white/[0.07] rounded-xl px-4 py-3 text-[#f0f6ff] placeholder:text-[#6b7f9e] focus:outline-none focus:border-[#3b82f6]"
          />
          <button
            onClick={addTodo}
            className="bg-[#3b82f6] hover:bg-[#2563eb] text-white px-6 rounded-xl font-semibold flex items-center gap-2 transition-colors"
          >
            <Plus size={20} /> Add
          </button>
        </div>

        {/* Todo List */}
        <div className="space-y-2">
          {todos.map((todo) => (
            <div
              key={todo.id}
              className="bg-[#111827] border border-white/[0.07] rounded-2xl p-4 flex items-center gap-3"
            >
              <button
                onClick={() => toggleTodo(todo.id)}
                className={`w-6 h-6 rounded-full border-2 flex items-center justify-center transition-all ${
                  todo.completed
                    ? 'bg-[#22c55e] border-[#22c55e]'
                    : 'border-[#6b7f9e]'
                }`}
              >
                {todo.completed && (
                  <svg
                    width="12"
                    height="10"
                    viewBox="0 0 12 10"
                    fill="none"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <path
                      d="M1 5L4.5 8.5L11 1.5"
                      stroke="white"
                      strokeWidth="2"
                      strokeLinecap="round"
                      strokeLinejoin="round"
                    />
                  </svg>
                )}
              </button>
              <div className="flex-1">
                <div
                  className={`font-semibold ${
                    todo.completed ? 'line-through text-[#6b7f9e]' : ''
                  }`}
                >
                  {todo.text}
                </div>
              </div>
              <div
                className="text-xs font-bold px-3 py-1 rounded-full"
                style={{
                  backgroundColor: `${todo.categoryColor}20`,
                  color: todo.categoryColor,
                }}
              >
                {todo.category}
              </div>
            </div>
          ))}
        </div>

        {/* ARIA Suggestions */}
        <div>
          <div className="flex items-center gap-2 mb-3">
            <Sparkles size={16} className="text-[#8b5cf6]" />
            <h3 className="text-base font-['Baloo_2'] font-bold">
              ARIA Suggestions
            </h3>
          </div>
          <div className="flex flex-wrap gap-2">
            {['Steps goal', 'Sleep 8hrs', 'Healthy lunch', 'Meditation'].map(
              (suggestion) => (
                <button
                  key={suggestion}
                  onClick={() => setNewTask(suggestion)}
                  className="bg-[#8b5cf6]/20 text-[#8b5cf6] px-4 py-2 rounded-full text-sm font-semibold hover:bg-[#8b5cf6]/30 transition-colors"
                >
                  + {suggestion}
                </button>
              )
            )}
          </div>
        </div>

        {/* Weekly Completion Chart */}
        <div className="bg-[#111827] border border-white/[0.07] rounded-2xl p-5">
          <h3 className="text-base font-['Baloo_2'] font-bold mb-4">
            Weekly Completion
          </h3>
          <div className="flex items-end justify-between gap-2 h-32">
            {weeklyData.map((day) => (
              <div key={day.day} className="flex-1 flex flex-col items-center">
                <div className="w-full flex items-end justify-center flex-1 mb-2">
                  <div
                    className="w-full bg-gradient-to-t from-[#3b82f6] to-[#8b5cf6] rounded-t-lg"
                    style={{ height: `${(day.value / 5) * 100}%` }}
                  />
                </div>
                <div className="text-xs text-[#6b7f9e]">{day.day}</div>
              </div>
            ))}
          </div>
        </div>
      </div>

      <FloatingMic />
      <BottomNav />
    </div>
  );
}
