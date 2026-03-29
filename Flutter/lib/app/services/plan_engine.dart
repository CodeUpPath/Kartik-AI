import '../models.dart';

const Map<String, double> _activityMultipliers = <String, double>{
  ActivityLevelValue.sedentary: 1.2,
  ActivityLevelValue.light: 1.375,
  ActivityLevelValue.moderate: 1.55,
  ActivityLevelValue.active: 1.725,
  ActivityLevelValue.veryActive: 1.9,
};

const Map<String, String> _legacyGoalMap = <String, String>{
  'lose': FitnessGoalValue.loseWeight,
  'gain': FitnessGoalValue.gainMuscle,
  'endurance': FitnessGoalValue.improveEndurance,
  'flexibility': FitnessGoalValue.maintain,
};

Exercise _e(
  String id,
  String name,
  int sets,
  String reps,
  String rest,
  String muscle,
  String category,
  String difficulty, [
  int? duration,
]) {
  return Exercise(
    id: id,
    name: name,
    sets: sets,
    reps: reps,
    rest: rest,
    duration: duration,
    muscle: muscle,
    category: category,
    difficulty: difficulty,
  );
}

final Map<String, List<Exercise>> _exerciseLibrary = <String, List<Exercise>>{
  'push_beginner': <Exercise>[
    _e(
      'pb1',
      'Push Ups',
      2,
      '10',
      '60s',
      'Chest',
      'Strength',
      DifficultyValue.easy,
    ),
    _e(
      'pb2',
      'Wall Push Ups',
      2,
      '12',
      '45s',
      'Chest',
      'Strength',
      DifficultyValue.easy,
    ),
    _e(
      'pb3',
      'Pike Push Ups',
      2,
      '8',
      '60s',
      'Shoulders',
      'Strength',
      DifficultyValue.easy,
    ),
    _e(
      'pb4',
      'Lateral Raises',
      2,
      '12',
      '45s',
      'Shoulders',
      'Strength',
      DifficultyValue.easy,
    ),
    _e(
      'pb5',
      'Tricep Dips',
      2,
      '10',
      '45s',
      'Triceps',
      'Strength',
      DifficultyValue.easy,
    ),
    _e(
      'pb6',
      'Arm Circles',
      2,
      '20 each',
      '30s',
      'Shoulders',
      'Strength',
      DifficultyValue.easy,
    ),
  ],
  'push_intermediate': <Exercise>[
    _e(
      'pi1',
      'Bench Press',
      3,
      '10',
      '90s',
      'Chest',
      'Strength',
      DifficultyValue.intermediate,
    ),
    _e(
      'pi2',
      'Shoulder Press',
      3,
      '12',
      '75s',
      'Shoulders',
      'Strength',
      DifficultyValue.intermediate,
    ),
    _e(
      'pi3',
      'Lateral Raises',
      3,
      '15',
      '45s',
      'Shoulders',
      'Strength',
      DifficultyValue.intermediate,
    ),
    _e(
      'pi4',
      'Tricep Dips',
      3,
      '12',
      '60s',
      'Triceps',
      'Strength',
      DifficultyValue.intermediate,
    ),
    _e(
      'pi5',
      'Incline Push Ups',
      3,
      '12',
      '60s',
      'Chest',
      'Strength',
      DifficultyValue.intermediate,
    ),
    _e(
      'pi6',
      'Front Raises',
      3,
      '12',
      '45s',
      'Shoulders',
      'Strength',
      DifficultyValue.intermediate,
    ),
  ],
  'push_advanced': <Exercise>[
    _e(
      'pa1',
      'Incline Bench Press',
      4,
      '8',
      '90s',
      'Chest',
      'Strength',
      DifficultyValue.hard,
    ),
    _e(
      'pa2',
      'Arnold Press',
      4,
      '10',
      '75s',
      'Shoulders',
      'Strength',
      DifficultyValue.hard,
    ),
    _e(
      'pa3',
      'Weighted Tricep Dips',
      4,
      '8',
      '90s',
      'Triceps',
      'Strength',
      DifficultyValue.hard,
    ),
    _e(
      'pa4',
      'Close-Grip Bench Press',
      4,
      '8',
      '90s',
      'Triceps',
      'Strength',
      DifficultyValue.hard,
    ),
    _e(
      'pa5',
      'Overhead Tricep Extension',
      3,
      '10',
      '60s',
      'Triceps',
      'Strength',
      DifficultyValue.hard,
    ),
    _e(
      'pa6',
      'Weighted Lateral Raises',
      3,
      '12',
      '60s',
      'Shoulders',
      'Strength',
      DifficultyValue.hard,
    ),
  ],
  'pull_beginner': <Exercise>[
    _e(
      'plb1',
      'Inverted Rows',
      2,
      '8',
      '60s',
      'Back',
      'Strength',
      DifficultyValue.easy,
    ),
    _e(
      'plb2',
      'Superman Hold',
      3,
      '10',
      '30s',
      'Back',
      'Strength',
      DifficultyValue.easy,
    ),
    _e(
      'plb3',
      'Bicep Curls',
      2,
      '12',
      '45s',
      'Biceps',
      'Strength',
      DifficultyValue.easy,
    ),
    _e(
      'plb4',
      'Band Pull-Aparts',
      3,
      '15',
      '30s',
      'Back',
      'Strength',
      DifficultyValue.easy,
    ),
    _e(
      'plb5',
      'Face Pulls',
      2,
      '15',
      '45s',
      'Back',
      'Strength',
      DifficultyValue.easy,
    ),
    _e(
      'plb6',
      'Hammer Curls',
      2,
      '10',
      '45s',
      'Biceps',
      'Strength',
      DifficultyValue.easy,
    ),
  ],
  'pull_intermediate': <Exercise>[
    _e(
      'pli1',
      'Dumbbell Rows',
      3,
      '10',
      '75s',
      'Back',
      'Strength',
      DifficultyValue.intermediate,
    ),
    _e(
      'pli2',
      'Pull Ups',
      3,
      '8',
      '90s',
      'Back',
      'Strength',
      DifficultyValue.intermediate,
    ),
    _e(
      'pli3',
      'Lat Pulldown',
      3,
      '12',
      '75s',
      'Back',
      'Strength',
      DifficultyValue.intermediate,
    ),
    _e(
      'pli4',
      'Bicep Curls',
      3,
      '12',
      '60s',
      'Biceps',
      'Strength',
      DifficultyValue.intermediate,
    ),
    _e(
      'pli5',
      'Hammer Curls',
      3,
      '12',
      '45s',
      'Biceps',
      'Strength',
      DifficultyValue.intermediate,
    ),
    _e(
      'pli6',
      'Seated Cable Row',
      3,
      '12',
      '75s',
      'Back',
      'Strength',
      DifficultyValue.intermediate,
    ),
  ],
  'pull_advanced': <Exercise>[
    _e(
      'pla1',
      'Weighted Pull Ups',
      4,
      '6',
      '120s',
      'Back',
      'Strength',
      DifficultyValue.hard,
    ),
    _e(
      'pla2',
      'Deadlift',
      4,
      '6',
      '120s',
      'Back',
      'Strength',
      DifficultyValue.hard,
    ),
    _e(
      'pla3',
      'Bent Over Barbell Row',
      4,
      '8',
      '90s',
      'Back',
      'Strength',
      DifficultyValue.hard,
    ),
    _e(
      'pla4',
      'Single Arm Cable Row',
      3,
      '10',
      '75s',
      'Back',
      'Strength',
      DifficultyValue.hard,
    ),
    _e(
      'pla5',
      'Rack Pull',
      3,
      '6',
      '120s',
      'Back',
      'Strength',
      DifficultyValue.hard,
    ),
    _e(
      'pla6',
      'EZ Bar Curls',
      4,
      '10',
      '60s',
      'Biceps',
      'Strength',
      DifficultyValue.hard,
    ),
  ],
  'legs_beginner': <Exercise>[
    _e(
      'lgb1',
      'Bodyweight Squats',
      2,
      '15',
      '60s',
      'Legs',
      'Strength',
      DifficultyValue.easy,
    ),
    _e(
      'lgb2',
      'Glute Bridges',
      3,
      '15',
      '45s',
      'Glutes',
      'Strength',
      DifficultyValue.easy,
    ),
    _e(
      'lgb3',
      'Step Ups',
      2,
      '10 each',
      '45s',
      'Legs',
      'Strength',
      DifficultyValue.easy,
    ),
    _e(
      'lgb4',
      'Wall Sit',
      3,
      '30s',
      '45s',
      'Legs',
      'Strength',
      DifficultyValue.easy,
    ),
    _e(
      'lgb5',
      'Calf Raises',
      3,
      '20',
      '30s',
      'Calves',
      'Strength',
      DifficultyValue.easy,
    ),
    _e(
      'lgb6',
      'Lying Leg Raises',
      2,
      '12',
      '30s',
      'Core',
      'Strength',
      DifficultyValue.easy,
    ),
  ],
  'legs_intermediate': <Exercise>[
    _e(
      'lgi1',
      'Squats',
      3,
      '12',
      '90s',
      'Legs',
      'Strength',
      DifficultyValue.intermediate,
    ),
    _e(
      'lgi2',
      'Lunges',
      3,
      '10 each',
      '75s',
      'Legs',
      'Strength',
      DifficultyValue.intermediate,
    ),
    _e(
      'lgi3',
      'Romanian Deadlift',
      3,
      '12',
      '90s',
      'Hamstrings',
      'Strength',
      DifficultyValue.intermediate,
    ),
    _e(
      'lgi4',
      'Sumo Squats',
      3,
      '12',
      '75s',
      'Legs',
      'Strength',
      DifficultyValue.intermediate,
    ),
    _e(
      'lgi5',
      'Hip Thrusts',
      3,
      '15',
      '60s',
      'Glutes',
      'Strength',
      DifficultyValue.intermediate,
    ),
    _e(
      'lgi6',
      'Leg Press',
      3,
      '12',
      '90s',
      'Legs',
      'Strength',
      DifficultyValue.intermediate,
    ),
  ],
  'legs_advanced': <Exercise>[
    _e(
      'lga1',
      'Barbell Squat',
      4,
      '6',
      '120s',
      'Legs',
      'Strength',
      DifficultyValue.hard,
    ),
    _e(
      'lga2',
      'Deadlift',
      4,
      '5',
      '120s',
      'Legs',
      'Strength',
      DifficultyValue.hard,
    ),
    _e(
      'lga3',
      'Bulgarian Split Squat',
      3,
      '8 each',
      '90s',
      'Legs',
      'Strength',
      DifficultyValue.hard,
    ),
    _e(
      'lga4',
      'Romanian Deadlift',
      4,
      '8',
      '90s',
      'Hamstrings',
      'Strength',
      DifficultyValue.hard,
    ),
    _e(
      'lga5',
      'Box Jumps',
      4,
      '10',
      '90s',
      'Legs',
      'Strength',
      DifficultyValue.hard,
    ),
    _e(
      'lga6',
      'Plyometric Lunges',
      3,
      '10 each',
      '75s',
      'Legs',
      'Cardio',
      DifficultyValue.hard,
    ),
  ],
  'core_beginner': <Exercise>[
    _e(
      'cb1',
      'Plank',
      2,
      '20s',
      '45s',
      'Core',
      'Core',
      DifficultyValue.easy,
      20,
    ),
    _e(
      'cb2',
      'Dead Bug',
      2,
      '8 each',
      '30s',
      'Core',
      'Core',
      DifficultyValue.easy,
    ),
    _e(
      'cb3',
      'Bird Dog',
      2,
      '10 each',
      '30s',
      'Core',
      'Core',
      DifficultyValue.easy,
    ),
    _e(
      'cb4',
      'Bicycle Crunches',
      2,
      '15',
      '30s',
      'Core',
      'Core',
      DifficultyValue.easy,
    ),
    _e(
      'cb5',
      'Lying Leg Raises',
      2,
      '12',
      '45s',
      'Core',
      'Core',
      DifficultyValue.easy,
    ),
    _e(
      'cb6',
      'Mountain Climbers',
      2,
      '20s',
      '30s',
      'Core',
      'Core',
      DifficultyValue.easy,
      20,
    ),
  ],
  'core_intermediate': <Exercise>[
    _e(
      'ci1',
      'Plank',
      3,
      '30s',
      '45s',
      'Core',
      'Core',
      DifficultyValue.intermediate,
      30,
    ),
    _e(
      'ci2',
      'Russian Twists',
      3,
      '15',
      '45s',
      'Core',
      'Core',
      DifficultyValue.intermediate,
    ),
    _e(
      'ci3',
      'Hanging Knee Raises',
      3,
      '12',
      '60s',
      'Core',
      'Core',
      DifficultyValue.intermediate,
    ),
    _e(
      'ci4',
      'Side Plank',
      3,
      '25s each',
      '45s',
      'Core',
      'Core',
      DifficultyValue.intermediate,
      25,
    ),
    _e(
      'ci5',
      'V-Ups',
      3,
      '12',
      '45s',
      'Core',
      'Core',
      DifficultyValue.intermediate,
    ),
    _e(
      'ci6',
      'Cable Crunches',
      3,
      '15',
      '45s',
      'Core',
      'Core',
      DifficultyValue.intermediate,
    ),
  ],
  'core_advanced': <Exercise>[
    _e(
      'ca1',
      'Hanging Leg Raises',
      4,
      '10',
      '75s',
      'Core',
      'Core',
      DifficultyValue.hard,
    ),
    _e(
      'ca2',
      'Ab Wheel Rollout',
      3,
      '10',
      '75s',
      'Core',
      'Core',
      DifficultyValue.hard,
    ),
    _e(
      'ca3',
      'Dragon Flag',
      3,
      '6',
      '90s',
      'Core',
      'Core',
      DifficultyValue.hard,
    ),
    _e(
      'ca4',
      'L-Sit Hold',
      3,
      '15s',
      '75s',
      'Core',
      'Core',
      DifficultyValue.hard,
      15,
    ),
    _e(
      'ca5',
      'Windshield Wipers',
      3,
      '8 each',
      '75s',
      'Core',
      'Core',
      DifficultyValue.hard,
    ),
    _e(
      'ca6',
      'Weighted Plank',
      3,
      '30s',
      '60s',
      'Core',
      'Core',
      DifficultyValue.hard,
      30,
    ),
  ],
  'hiit_beginner': <Exercise>[
    _e(
      'hb1',
      'Jumping Jacks',
      3,
      '30s',
      '30s',
      'Full Body',
      'Cardio',
      DifficultyValue.easy,
      30,
    ),
    _e(
      'hb2',
      'High Knees',
      3,
      '20s',
      '30s',
      'Legs',
      'Cardio',
      DifficultyValue.easy,
      20,
    ),
    _e(
      'hb3',
      'Mountain Climbers',
      3,
      '20s',
      '30s',
      'Core',
      'Cardio',
      DifficultyValue.easy,
      20,
    ),
    _e(
      'hb4',
      'Butt Kicks',
      3,
      '20s',
      '20s',
      'Hamstrings',
      'Cardio',
      DifficultyValue.easy,
      20,
    ),
    _e(
      'hb5',
      'Step Jacks',
      3,
      '30s',
      '20s',
      'Full Body',
      'Cardio',
      DifficultyValue.easy,
      30,
    ),
    _e(
      'hb6',
      'Bear Crawl',
      3,
      '20s',
      '30s',
      'Full Body',
      'Cardio',
      DifficultyValue.easy,
      20,
    ),
    _e(
      'hb7',
      'Squat to Kick',
      3,
      '10 each',
      '25s',
      'Legs',
      'Cardio',
      DifficultyValue.easy,
    ),
  ],
  'hiit_intermediate': <Exercise>[
    _e(
      'hi1',
      'Burpees',
      4,
      '10',
      '45s',
      'Full Body',
      'Cardio',
      DifficultyValue.intermediate,
    ),
    _e(
      'hi2',
      'Jump Squats',
      4,
      '12',
      '45s',
      'Legs',
      'Cardio',
      DifficultyValue.intermediate,
    ),
    _e(
      'hi3',
      'Sprint Intervals',
      6,
      '20s',
      '40s',
      'Full Body',
      'Cardio',
      DifficultyValue.intermediate,
      20,
    ),
    _e(
      'hi4',
      'Box Jumps',
      4,
      '10',
      '60s',
      'Legs',
      'Cardio',
      DifficultyValue.intermediate,
    ),
    _e(
      'hi5',
      'Jump Rope',
      4,
      '45s',
      '30s',
      'Full Body',
      'Cardio',
      DifficultyValue.intermediate,
      45,
    ),
    _e(
      'hi6',
      'Lateral Jumps',
      4,
      '12 each',
      '40s',
      'Legs',
      'Cardio',
      DifficultyValue.intermediate,
    ),
    _e(
      'hi7',
      'Power Jacks',
      4,
      '15',
      '35s',
      'Full Body',
      'Cardio',
      DifficultyValue.intermediate,
    ),
  ],
  'hiit_advanced': <Exercise>[
    _e(
      'ha1',
      'HIIT Sprint Intervals',
      8,
      '30s',
      '20s',
      'Full Body',
      'Cardio',
      DifficultyValue.hard,
      30,
    ),
    _e(
      'ha2',
      'Burpees',
      5,
      '12',
      '30s',
      'Full Body',
      'Cardio',
      DifficultyValue.hard,
    ),
    _e(
      'ha3',
      'Tuck Jumps',
      4,
      '15',
      '45s',
      'Full Body',
      'Cardio',
      DifficultyValue.hard,
    ),
    _e(
      'ha4',
      'Battle Ropes',
      5,
      '30s',
      '30s',
      'Full Body',
      'Cardio',
      DifficultyValue.hard,
      30,
    ),
    _e(
      'ha5',
      'Plyometric Lunges',
      4,
      '12 each',
      '45s',
      'Legs',
      'Cardio',
      DifficultyValue.hard,
    ),
    _e(
      'ha6',
      'Burpee to Broad Jump',
      5,
      '8',
      '40s',
      'Full Body',
      'Cardio',
      DifficultyValue.hard,
    ),
    _e(
      'ha7',
      'Triple Jump Squat',
      4,
      '10',
      '45s',
      'Legs',
      'Cardio',
      DifficultyValue.hard,
    ),
  ],
  'cardio_beginner': <Exercise>[
    _e(
      'crb1',
      'Marching In Place',
      3,
      '45s',
      '30s',
      'Full Body',
      'Cardio',
      DifficultyValue.easy,
      45,
    ),
    _e(
      'crb2',
      'Standing Side Steps',
      3,
      '20 each',
      '25s',
      'Full Body',
      'Cardio',
      DifficultyValue.easy,
    ),
    _e(
      'crb3',
      'Low-Impact Mountain Climbers',
      3,
      '20s',
      '30s',
      'Core',
      'Cardio',
      DifficultyValue.easy,
      20,
    ),
    _e(
      'crb4',
      'Butt Kicks',
      3,
      '20s',
      '20s',
      'Hamstrings',
      'Cardio',
      DifficultyValue.easy,
      20,
    ),
    _e(
      'crb5',
      'Step Touches',
      3,
      '30s',
      '20s',
      'Full Body',
      'Cardio',
      DifficultyValue.easy,
      30,
    ),
    _e(
      'crb6',
      'Walking Lunges',
      3,
      '10 each',
      '30s',
      'Legs',
      'Cardio',
      DifficultyValue.easy,
    ),
    _e(
      'crb7',
      'Seated Leg Raises',
      3,
      '12',
      '20s',
      'Core',
      'Cardio',
      DifficultyValue.easy,
    ),
  ],
  'cardio_intermediate': <Exercise>[
    _e(
      'cri1',
      'Jump Rope',
      4,
      '45s',
      '30s',
      'Full Body',
      'Cardio',
      DifficultyValue.intermediate,
      45,
    ),
    _e(
      'cri2',
      'Sprint Intervals',
      6,
      '20s',
      '40s',
      'Full Body',
      'Cardio',
      DifficultyValue.intermediate,
      20,
    ),
    _e(
      'cri3',
      'Skater Hops',
      4,
      '12 each',
      '35s',
      'Full Body',
      'Cardio',
      DifficultyValue.intermediate,
    ),
    _e(
      'cri4',
      'High Knees',
      4,
      '30s',
      '30s',
      'Legs',
      'Cardio',
      DifficultyValue.intermediate,
      30,
    ),
    _e(
      'cri5',
      'Jump Squats',
      4,
      '12',
      '45s',
      'Legs',
      'Cardio',
      DifficultyValue.intermediate,
    ),
    _e(
      'cri6',
      'Lateral Shuffle',
      4,
      '30s',
      '30s',
      'Full Body',
      'Cardio',
      DifficultyValue.intermediate,
      30,
    ),
    _e(
      'cri7',
      'Box Step Ups',
      4,
      '12 each',
      '40s',
      'Legs',
      'Cardio',
      DifficultyValue.intermediate,
    ),
  ],
  'cardio_advanced': <Exercise>[
    _e(
      'cra1',
      'HIIT Sprint Intervals',
      8,
      '30s',
      '20s',
      'Full Body',
      'Cardio',
      DifficultyValue.hard,
      30,
    ),
    _e(
      'cra2',
      'Battle Ropes',
      5,
      '30s',
      '30s',
      'Full Body',
      'Cardio',
      DifficultyValue.hard,
      30,
    ),
    _e(
      'cra3',
      'Plyometric Lunges',
      4,
      '12 each',
      '45s',
      'Legs',
      'Cardio',
      DifficultyValue.hard,
    ),
    _e(
      'cra4',
      'Tuck Jumps',
      4,
      '15',
      '45s',
      'Full Body',
      'Cardio',
      DifficultyValue.hard,
    ),
    _e(
      'cra5',
      'Burpees',
      5,
      '12',
      '30s',
      'Full Body',
      'Cardio',
      DifficultyValue.hard,
    ),
    _e(
      'cra6',
      'Sled Sprints',
      6,
      '20s',
      '30s',
      'Full Body',
      'Cardio',
      DifficultyValue.hard,
      20,
    ),
    _e(
      'cra7',
      'Depth Jumps',
      4,
      '8',
      '45s',
      'Legs',
      'Cardio',
      DifficultyValue.hard,
    ),
  ],
  'active_recovery': <Exercise>[
    _e(
      'ar1',
      'Downward Dog',
      3,
      '30s',
      '15s',
      'Full Body',
      'Flexibility',
      DifficultyValue.easy,
    ),
    _e(
      'ar2',
      "Child's Pose",
      3,
      '45s',
      '15s',
      'Back',
      'Flexibility',
      DifficultyValue.easy,
    ),
    _e(
      'ar3',
      'Hip Flexor Stretch',
      3,
      '30s each',
      '15s',
      'Hips',
      'Flexibility',
      DifficultyValue.easy,
    ),
    _e(
      'ar4',
      'Cat-Cow Stretch',
      3,
      '10 each',
      '15s',
      'Back',
      'Flexibility',
      DifficultyValue.easy,
    ),
    _e(
      'ar5',
      'Thoracic Rotations',
      3,
      '10 each',
      '20s',
      'Back',
      'Flexibility',
      DifficultyValue.easy,
    ),
    _e(
      'ar6',
      'Seated Forward Fold',
      3,
      '30s',
      '15s',
      'Hamstrings',
      'Flexibility',
      DifficultyValue.easy,
    ),
  ],
  'flexibility': <Exercise>[
    _e(
      'f1',
      'Downward Dog',
      3,
      '30s',
      '15s',
      'Full Body',
      'Flexibility',
      DifficultyValue.easy,
    ),
    _e(
      'f2',
      "Child's Pose",
      3,
      '45s',
      '15s',
      'Back',
      'Flexibility',
      DifficultyValue.easy,
    ),
    _e(
      'f3',
      'Hip Flexor Stretch',
      3,
      '30s each',
      '15s',
      'Hips',
      'Flexibility',
      DifficultyValue.easy,
    ),
    _e(
      'f4',
      'Seated Forward Fold',
      3,
      '30s',
      '15s',
      'Hamstrings',
      'Flexibility',
      DifficultyValue.easy,
    ),
    _e(
      'f5',
      'Pigeon Pose',
      2,
      '45s each',
      '20s',
      'Hips',
      'Flexibility',
      DifficultyValue.easy,
    ),
    _e(
      'f6',
      'Thoracic Rotations',
      3,
      '10 each',
      '20s',
      'Back',
      'Flexibility',
      DifficultyValue.easy,
    ),
  ],
};

const List<String> _gainMuscleSplits = <String>['push', 'pull', 'legs', 'core'];
const List<String> _loseWeightRotations = <String>[
  'cardio',
  'hiit',
  'active_recovery',
];
const List<String> _enduranceRotations = <String>[
  'cardio',
  'hiit',
  'active_recovery',
];
const List<String> _maintainRotations = <String>[
  'push',
  'cardio',
  'core',
  'flexibility',
];

const Map<String, List<String>> _workoutNames = <String, List<String>>{
  FitnessGoalValue.gainMuscle: <String>[
    'Push Day',
    'Pull Day',
    'Leg Day',
    'Core & Abs',
  ],
  FitnessGoalValue.loseWeight: <String>[
    'Fat Burn Cardio',
    'HIIT Blast',
    'Active Recovery',
    'Cardio Circuit',
    'Full Body Burn',
  ],
  FitnessGoalValue.improveEndurance: <String>[
    'Tempo Run',
    'Threshold HIIT',
    'Recovery Day',
  ],
  FitnessGoalValue.maintain: <String>[
    'Full Body Push',
    'Cardio Mix',
    'Core & Abs',
    'Flexibility Flow',
  ],
};

const Map<String, List<String>> _workoutCategories = <String, List<String>>{
  FitnessGoalValue.gainMuscle: <String>[
    'Strength',
    'Strength',
    'Strength',
    'Core',
  ],
  FitnessGoalValue.loseWeight: <String>['Cardio', 'HIIT', 'Recovery'],
  FitnessGoalValue.improveEndurance: <String>['Tempo', 'Threshold', 'Recovery'],
  FitnessGoalValue.maintain: <String>[
    'Strength',
    'Cardio',
    'Core',
    'Flexibility',
  ],
};

const List<String> _shortDays = <String>[
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];
const List<String> _workoutColors = <String>[
  '#2ECC71',
  '#3498DB',
  '#E74C3C',
  '#F39C12',
  '#9B59B6',
  '#1ABC9C',
  '#E67E22',
];

class _PhaseTarget {
  const _PhaseTarget(
    this.sets,
    this.numericReps,
    this.timeMultiplier,
    this.phase,
    this.restScale,
  );

  final int sets;
  final int numericReps;
  final double timeMultiplier;
  final String phase;
  final double restScale;
}

class _AdaptationFlags {
  const _AdaptationFlags(this.isHighBmiEarly, this.isOlderUser);

  final bool isHighBmiEarly;
  final bool isOlderUser;
}

String normalizeGoal(String? goal) {
  if (goal == null || goal.isEmpty) return FitnessGoalValue.maintain;
  if (FitnessGoalValue.all.contains(goal)) return goal;
  return _legacyGoalMap[goal] ?? FitnessGoalValue.maintain;
}

String normalizeFitnessLevel(String? level) {
  if (level != null && FitnessLevelValue.all.contains(level)) return level;
  return FitnessLevelValue.beginner;
}

String normalizeActivityLevel(String? level) {
  if (level != null && ActivityLevelValue.all.contains(level)) return level;
  return ActivityLevelValue.moderate;
}

String normalizeDietType(String? dietType) {
  if (dietType != null && DietTypeValue.all.contains(dietType)) return dietType;
  return DietTypeValue.nonVeg;
}

double _safeDouble(String? value, double fallback) =>
    double.tryParse(value ?? '') ?? fallback;

Map<String, dynamic> calculateBmi(AppUser user) {
  final double weight = _safeDouble(user.weight, 70);
  final double heightMeters = _safeDouble(user.height, 170) / 100;
  final double bmi = weight / (heightMeters * heightMeters);
  final double rounded = double.parse(bmi.toStringAsFixed(1));
  String status = 'Normal';
  if (rounded < 18.5) {
    status = 'Underweight';
  } else if (rounded < 25) {
    status = 'Normal';
  } else if (rounded < 30) {
    status = 'Overweight';
  } else {
    status = 'Obese';
  }
  return <String, dynamic>{'bmi': rounded, 'status': status};
}

int calculateTdee(AppUser user) {
  final double weight = _safeDouble(user.weight, 70);
  final double height = _safeDouble(user.height, 170);
  final double age = _safeDouble(user.age, 25);
  final String gender = user.gender ?? GenderValue.male;
  final String activityLevel = normalizeActivityLevel(user.activityLevel);
  final double bmr = gender == GenderValue.male
      ? 10 * weight + 6.25 * height - 5 * age + 5
      : 10 * weight + 6.25 * height - 5 * age - 161;
  return (bmr * (_activityMultipliers[activityLevel] ?? 1.55)).round();
}

bool isProfileComplete(AppUser user) {
  return user.height != null &&
      user.weight != null &&
      user.age != null &&
      user.goal != null &&
      user.fitnessLevel != null &&
      user.activityLevel != null &&
      user.workoutDaysPerWeek != null;
}

DateTime _mostRecentSunday(DateTime date) {
  final DateTime copy = DateTime(date.year, date.month, date.day);
  return copy.subtract(Duration(days: copy.weekday % 7));
}

int computeCalendarWeek(String weekStartIso) {
  final DateTime startSunday = _mostRecentSunday(DateTime.parse(weekStartIso));
  final DateTime todaySunday = _mostRecentSunday(DateTime.now());
  final int sundays = todaySunday.difference(startSunday).inDays ~/ 7;
  return sundays + 1 < 1 ? 1 : sundays + 1;
}

int getCalorieTarget(int tdee, String goal) {
  switch (goal) {
    case FitnessGoalValue.loseWeight:
      return tdee - 500;
    case FitnessGoalValue.gainMuscle:
      return tdee + 300;
    case FitnessGoalValue.improveEndurance:
      return tdee + 100;
    default:
      return tdee;
  }
}

Map<String, int> _getMacros(int calories, String goal) {
  double proteinPct = 0.25;
  double carbsPct = 0.45;
  double fatPct = 0.30;
  switch (goal) {
    case FitnessGoalValue.gainMuscle:
      proteinPct = 0.30;
      carbsPct = 0.45;
      fatPct = 0.25;
      break;
    case FitnessGoalValue.loseWeight:
      proteinPct = 0.35;
      carbsPct = 0.35;
      fatPct = 0.30;
      break;
    case FitnessGoalValue.improveEndurance:
      proteinPct = 0.20;
      carbsPct = 0.55;
      fatPct = 0.25;
      break;
  }
  return <String, int>{
    'proteinGoal': ((calories * proteinPct) / 4).round(),
    'carbsGoal': ((calories * carbsPct) / 4).round(),
    'fatGoal': ((calories * fatPct) / 9).round(),
  };
}

_PhaseTarget _getPhaseTarget(int week) {
  if (week <= 2) return const _PhaseTarget(3, 10, 1, 'easy', 1);
  if (week <= 4) return const _PhaseTarget(4, 12, 1.2, 'medium', 0.9);
  return const _PhaseTarget(5, 15, 1.5, 'hard', 0.7);
}

String _normalizeReps(String reps, _PhaseTarget target) {
  if (reps.endsWith('s each')) {
    final int base = int.tryParse(reps.split('s').first) ?? 30;
    return '${((base * target.timeMultiplier).round()).clamp(0, 120)}s each';
  }
  if (reps.endsWith('s')) {
    final int base = int.tryParse(reps.split('s').first) ?? 30;
    return '${((base * target.timeMultiplier).round()).clamp(0, 120)}s';
  }
  if (reps.endsWith(' each')) return '${target.numericReps} each';
  if (int.tryParse(reps) != null) return '${target.numericReps}';
  return reps;
}

String _scaleRest(String rest, double scale) {
  final int? seconds = int.tryParse(rest.replaceAll(RegExp(r'[^0-9]'), ''));
  if (seconds == null) return rest;
  return '${(seconds * scale).round().clamp(15, 999)}s';
}

List<Exercise> _applyProgression(
  List<Exercise> exercises,
  _PhaseTarget target,
) {
  return exercises
      .map(
        (Exercise exercise) => exercise.copyWith(
          sets: target.sets,
          reps: _normalizeReps(exercise.reps, target),
          rest: target.restScale < 1
              ? _scaleRest(exercise.rest, target.restScale)
              : exercise.rest,
        ),
      )
      .toList();
}

_AdaptationFlags _getUserAdaptationFlags(AppUser user, int week) {
  final double weight = _safeDouble(user.weight, 70);
  final double heightMeters = _safeDouble(user.height, 170) / 100;
  final double bmi = weight / (heightMeters * heightMeters);
  final double age = _safeDouble(user.age, 25);
  return _AdaptationFlags(bmi > 28 && week <= 2, age > 45);
}

String _getSafeExerciseKey(String baseKey, _AdaptationFlags flags) {
  if (baseKey.startsWith('hiit_')) {
    if (flags.isOlderUser) {
      return 'active_recovery';
    }
    if (flags.isHighBmiEarly) {
      return 'cardio_beginner';
    }
  }
  if ((baseKey == 'cardio_advanced' || baseKey == 'cardio_intermediate') &&
      flags.isHighBmiEarly) {
    return 'cardio_beginner';
  }
  if (baseKey == 'legs_advanced' &&
      (flags.isOlderUser || flags.isHighBmiEarly)) {
    return 'legs_beginner';
  }
  if (flags.isOlderUser) {
    if (baseKey == 'push_advanced') return 'push_intermediate';
    if (baseKey == 'pull_advanced') return 'pull_intermediate';
    if (baseKey == 'core_advanced') return 'core_intermediate';
  }
  return baseKey;
}

String _getEffectiveLevel(AppUser user, String baseLevel, int week) {
  if (week <= 2) return FitnessLevelValue.beginner;
  final String activityLevel = normalizeActivityLevel(user.activityLevel);
  if (activityLevel == ActivityLevelValue.sedentary && week <= 4) {
    return FitnessLevelValue.beginner;
  }
  if (baseLevel == FitnessLevelValue.beginner) {
    if (week <= 6) return FitnessLevelValue.beginner;
    if (week <= 10) return FitnessLevelValue.intermediate;
    return FitnessLevelValue.advanced;
  }
  if (baseLevel == FitnessLevelValue.intermediate) {
    return week <= 4
        ? FitnessLevelValue.intermediate
        : FitnessLevelValue.advanced;
  }
  return FitnessLevelValue.advanced;
}

List<Exercise> _resolveKey(String key) {
  return _exerciseLibrary[key] ??
      _exerciseLibrary['${key.split('_').first}_beginner'] ??
      _exerciseLibrary['active_recovery']!;
}

List<Exercise> _getExercisesForDay(
  String goal,
  String level,
  int dayIndex,
  AppUser user,
  int week,
  _PhaseTarget target,
) {
  final String effectiveLevel = _getEffectiveLevel(user, level, week);
  final _AdaptationFlags flags = _getUserAdaptationFlags(user, week);
  late final String rawKey;

  switch (goal) {
    case FitnessGoalValue.gainMuscle:
      final String split =
          _gainMuscleSplits[dayIndex % _gainMuscleSplits.length];
      rawKey = flags.isOlderUser && split == 'core'
          ? 'active_recovery'
          : '${split}_$effectiveLevel';
      break;
    case FitnessGoalValue.loseWeight:
      final String rotation =
          _loseWeightRotations[dayIndex % _loseWeightRotations.length];
      rawKey = rotation == 'active_recovery'
          ? rotation
          : '${rotation}_$effectiveLevel';
      break;
    case FitnessGoalValue.improveEndurance:
      final String rotation =
          _enduranceRotations[dayIndex % _enduranceRotations.length];
      rawKey = rotation == 'active_recovery'
          ? rotation
          : '${rotation}_$effectiveLevel';
      break;
    default:
      final String rotation =
          _maintainRotations[dayIndex % _maintainRotations.length];
      rawKey = rotation == 'flexibility'
          ? rotation
          : rotation == 'cardio'
          ? 'cardio_$effectiveLevel'
          : '${rotation}_$effectiveLevel';
  }

  return _applyProgression(
    _resolveKey(_getSafeExerciseKey(rawKey, flags)),
    target,
  );
}

String _getWorkoutName(String goal, int index) {
  final List<String> names =
      _workoutNames[goal] ?? _workoutNames[FitnessGoalValue.maintain]!;
  return names[index % names.length];
}

String _getWorkoutCategory(String goal, int index) {
  final List<String> categories =
      _workoutCategories[goal] ??
      _workoutCategories[FitnessGoalValue.maintain]!;
  return categories[index % categories.length];
}

String _getWorkoutDifficulty(String level, String phase) {
  if (phase == 'easy') {
    return level == FitnessLevelValue.advanced
        ? DifficultyValue.intermediate
        : DifficultyValue.easy;
  }
  if (phase == 'medium') {
    if (level == FitnessLevelValue.beginner) return DifficultyValue.easy;
    if (level == FitnessLevelValue.advanced) return DifficultyValue.hard;
    return DifficultyValue.intermediate;
  }
  return level == FitnessLevelValue.beginner
      ? DifficultyValue.intermediate
      : DifficultyValue.hard;
}

List<int> _selectWorkoutDays(int daysPerWeek) {
  const Map<int, List<int>> patterns = <int, List<int>>{
    2: <int>[0, 3],
    3: <int>[0, 2, 4],
    4: <int>[0, 1, 3, 4],
    5: <int>[0, 1, 2, 3, 4],
    6: <int>[0, 1, 2, 3, 4, 5],
    7: <int>[0, 1, 2, 3, 4, 5, 6],
  };
  return patterns[daysPerWeek.clamp(2, 7)] ?? const <int>[0, 2, 4];
}

int _getTotalDuration(List<Exercise> exercises, String level) {
  final double base = exercises.length * 4;
  final double multiplier = level == FitnessLevelValue.advanced
      ? 1.5
      : level == FitnessLevelValue.intermediate
      ? 1.25
      : 1;
  return (base * multiplier).round();
}

int _getCaloriesBurned(
  String goal,
  String level,
  double weight,
  _PhaseTarget target,
) {
  final int base = goal == FitnessGoalValue.loseWeight
      ? 400
      : goal == FitnessGoalValue.gainMuscle
      ? 300
      : 250;
  final double levelBonus = level == FitnessLevelValue.advanced
      ? 1.3
      : level == FitnessLevelValue.intermediate
      ? 1.15
      : 1;
  final double weightFactor = weight / 70;
  final double weekBonus = target.phase == 'hard'
      ? 1.15
      : target.phase == 'medium'
      ? 1.07
      : 1;
  return (base * levelBonus * weightFactor * weekBonus).round();
}

List<WorkoutDay> generateWeeklyPlan(AppUser user, int currentWeek) {
  final String goal = normalizeGoal(user.goal);
  final String level = normalizeFitnessLevel(user.fitnessLevel);
  final int daysPerWeek = user.workoutDaysPerWeek ?? 3;
  final _PhaseTarget target = _getPhaseTarget(currentWeek);
  final List<int> workoutDayIndices = _selectWorkoutDays(daysPerWeek);
  final double weight = _safeDouble(user.weight, 70);

  return List<WorkoutDay>.generate(7, (int index) {
    final bool isRest = !workoutDayIndices.contains(index);
    if (isRest) {
      return WorkoutDay(
        day: _shortDays[index],
        dayNumber: index + 1,
        name: 'Rest & Recovery',
        category: 'Rest',
        duration: '0 min',
        difficulty: DifficultyValue.easy,
        calories: 0,
        color: '#AAAAAA',
        exercises: _exerciseLibrary['flexibility']!.take(3).toList(),
        isRestDay: true,
      );
    }

    final int workoutIndex = workoutDayIndices.indexOf(index);
    final List<Exercise> exercises = _getExercisesForDay(
      goal,
      level,
      workoutIndex,
      user,
      currentWeek,
      target,
    );
    return WorkoutDay(
      day: _shortDays[index],
      dayNumber: index + 1,
      name: _getWorkoutName(goal, workoutIndex),
      category: _getWorkoutCategory(goal, workoutIndex),
      duration: '${_getTotalDuration(exercises, level)} min',
      difficulty: _getWorkoutDifficulty(level, target.phase),
      calories: _getCaloriesBurned(goal, level, weight, target),
      color: _workoutColors[workoutIndex % _workoutColors.length],
      exercises: exercises,
      isRestDay: false,
    );
  });
}

List<MealSuggestion> generateMealPlan(
  int calories,
  String goal,
  String dietType,
) {
  final bool veg = true;
  final bool nonVeg = false;
  final Map<String, Map<String, List<MealSuggestion>>> mealSets =
      <String, Map<String, List<MealSuggestion>>>{
        DietTypeValue.nonVeg: <String, List<MealSuggestion>>{
          FitnessGoalValue.gainMuscle: <MealSuggestion>[
            MealSuggestion(
              id: 'm1',
              type: 'Breakfast',
              time: '7:30 AM',
              name: 'Oatmeal + Eggs + Banana',
              calories: (calories * 0.25).round(),
              protein: 28,
              carbs: 65,
              fat: 10,
              isVeg: nonVeg,
            ),
            MealSuggestion(
              id: 'm2',
              type: 'Lunch',
              time: '1:00 PM',
              name: 'Chicken Rice Bowl + Veggies',
              calories: (calories * 0.35).round(),
              protein: 52,
              carbs: 70,
              fat: 16,
              isVeg: nonVeg,
            ),
            MealSuggestion(
              id: 'm3',
              type: 'Snack',
              time: '4:30 PM',
              name: 'Protein Shake + Peanut Butter Toast',
              calories: (calories * 0.15).round(),
              protein: 30,
              carbs: 28,
              fat: 12,
              isVeg: nonVeg,
            ),
            MealSuggestion(
              id: 'm4',
              type: 'Dinner',
              time: '7:30 PM',
              name: 'Salmon + Quinoa + Broccoli',
              calories: (calories * 0.25).round(),
              protein: 45,
              carbs: 40,
              fat: 18,
              isVeg: nonVeg,
            ),
          ],
          FitnessGoalValue.loseWeight: <MealSuggestion>[
            MealSuggestion(
              id: 'm1',
              type: 'Breakfast',
              time: '7:00 AM',
              name: 'Greek Yogurt Parfait + Berries',
              calories: (calories * 0.22).round(),
              protein: 22,
              carbs: 30,
              fat: 6,
              isVeg: nonVeg,
            ),
            MealSuggestion(
              id: 'm2',
              type: 'Lunch',
              time: '12:30 PM',
              name: 'Grilled Chicken Salad',
              calories: (calories * 0.32).round(),
              protein: 42,
              carbs: 20,
              fat: 14,
              isVeg: nonVeg,
            ),
            MealSuggestion(
              id: 'm3',
              type: 'Snack',
              time: '3:30 PM',
              name: 'Apple + Almond Butter',
              calories: (calories * 0.12).round(),
              protein: 6,
              carbs: 24,
              fat: 10,
              isVeg: veg,
            ),
            MealSuggestion(
              id: 'm4',
              type: 'Dinner',
              time: '7:00 PM',
              name: 'Baked Fish + Steamed Veggies',
              calories: (calories * 0.34).round(),
              protein: 38,
              carbs: 28,
              fat: 12,
              isVeg: nonVeg,
            ),
          ],
          FitnessGoalValue.improveEndurance: <MealSuggestion>[
            MealSuggestion(
              id: 'm1',
              type: 'Breakfast',
              time: '7:00 AM',
              name: 'Whole Grain Toast + Banana + Honey',
              calories: (calories * 0.23).round(),
              protein: 14,
              carbs: 72,
              fat: 6,
              isVeg: veg,
            ),
            MealSuggestion(
              id: 'm2',
              type: 'Lunch',
              time: '12:30 PM',
              name: 'Pasta + Chicken + Marinara',
              calories: (calories * 0.35).round(),
              protein: 38,
              carbs: 80,
              fat: 14,
              isVeg: nonVeg,
            ),
            MealSuggestion(
              id: 'm3',
              type: 'Snack',
              time: '4:00 PM',
              name: 'Energy Balls + Orange Juice',
              calories: (calories * 0.14).round(),
              protein: 8,
              carbs: 40,
              fat: 8,
              isVeg: veg,
            ),
            MealSuggestion(
              id: 'm4',
              type: 'Dinner',
              time: '7:30 PM',
              name: 'Tuna Rice Bowl + Veggies',
              calories: (calories * 0.28).round(),
              protein: 36,
              carbs: 55,
              fat: 12,
              isVeg: nonVeg,
            ),
          ],
          FitnessGoalValue.maintain: <MealSuggestion>[
            MealSuggestion(
              id: 'm1',
              type: 'Breakfast',
              time: '7:30 AM',
              name: 'Scrambled Eggs + Whole Toast',
              calories: (calories * 0.22).round(),
              protein: 24,
              carbs: 38,
              fat: 14,
              isVeg: nonVeg,
            ),
            MealSuggestion(
              id: 'm2',
              type: 'Lunch',
              time: '1:00 PM',
              name: 'Chicken Wrap + Side Salad',
              calories: (calories * 0.32).round(),
              protein: 36,
              carbs: 50,
              fat: 16,
              isVeg: nonVeg,
            ),
            MealSuggestion(
              id: 'm3',
              type: 'Snack',
              time: '4:00 PM',
              name: 'Mixed Nuts + Seasonal Fruit',
              calories: (calories * 0.12).round(),
              protein: 8,
              carbs: 22,
              fat: 14,
              isVeg: veg,
            ),
            MealSuggestion(
              id: 'm4',
              type: 'Dinner',
              time: '7:30 PM',
              name: 'Grilled Chicken + Sweet Potato',
              calories: (calories * 0.34).round(),
              protein: 40,
              carbs: 48,
              fat: 14,
              isVeg: nonVeg,
            ),
          ],
        },
        DietTypeValue.veg: <String, List<MealSuggestion>>{
          FitnessGoalValue.gainMuscle: <MealSuggestion>[
            MealSuggestion(
              id: 'm1',
              type: 'Breakfast',
              time: '7:30 AM',
              name: 'Oatmeal + Peanut Butter + Banana',
              calories: (calories * 0.25).round(),
              protein: 22,
              carbs: 70,
              fat: 12,
              isVeg: veg,
            ),
            MealSuggestion(
              id: 'm2',
              type: 'Lunch',
              time: '1:00 PM',
              name: 'Paneer Rice Bowl + Veggies',
              calories: (calories * 0.35).round(),
              protein: 44,
              carbs: 72,
              fat: 18,
              isVeg: veg,
            ),
            MealSuggestion(
              id: 'm3',
              type: 'Snack',
              time: '4:30 PM',
              name: 'Protein Shake + Whole Grain Toast',
              calories: (calories * 0.15).round(),
              protein: 28,
              carbs: 30,
              fat: 10,
              isVeg: veg,
            ),
            MealSuggestion(
              id: 'm4',
              type: 'Dinner',
              time: '7:30 PM',
              name: 'Tofu Stir Fry + Brown Rice + Broccoli',
              calories: (calories * 0.25).round(),
              protein: 36,
              carbs: 48,
              fat: 14,
              isVeg: veg,
            ),
          ],
          FitnessGoalValue.loseWeight: <MealSuggestion>[
            MealSuggestion(
              id: 'm1',
              type: 'Breakfast',
              time: '7:00 AM',
              name: 'Greek Yogurt Parfait + Berries',
              calories: (calories * 0.22).round(),
              protein: 18,
              carbs: 32,
              fat: 5,
              isVeg: veg,
            ),
            MealSuggestion(
              id: 'm2',
              type: 'Lunch',
              time: '12:30 PM',
              name: 'Paneer Tikka Salad + Lemon Dressing',
              calories: (calories * 0.32).round(),
              protein: 34,
              carbs: 22,
              fat: 14,
              isVeg: veg,
            ),
            MealSuggestion(
              id: 'm3',
              type: 'Snack',
              time: '3:30 PM',
              name: 'Apple + Almond Butter',
              calories: (calories * 0.12).round(),
              protein: 6,
              carbs: 24,
              fat: 10,
              isVeg: veg,
            ),
            MealSuggestion(
              id: 'm4',
              type: 'Dinner',
              time: '7:00 PM',
              name: 'Dal Tadka + Steamed Veggies + Roti',
              calories: (calories * 0.34).round(),
              protein: 28,
              carbs: 40,
              fat: 10,
              isVeg: veg,
            ),
          ],
          FitnessGoalValue.improveEndurance: <MealSuggestion>[
            MealSuggestion(
              id: 'm1',
              type: 'Breakfast',
              time: '7:00 AM',
              name: 'Banana Oat Smoothie + Whole Toast',
              calories: (calories * 0.23).round(),
              protein: 14,
              carbs: 75,
              fat: 6,
              isVeg: veg,
            ),
            MealSuggestion(
              id: 'm2',
              type: 'Lunch',
              time: '12:30 PM',
              name: 'Rajma + Brown Rice + Raita',
              calories: (calories * 0.35).round(),
              protein: 30,
              carbs: 80,
              fat: 10,
              isVeg: veg,
            ),
            MealSuggestion(
              id: 'm3',
              type: 'Snack',
              time: '4:00 PM',
              name: 'Dates + Mixed Nuts + Orange Juice',
              calories: (calories * 0.14).round(),
              protein: 6,
              carbs: 42,
              fat: 8,
              isVeg: veg,
            ),
            MealSuggestion(
              id: 'm4',
              type: 'Dinner',
              time: '7:30 PM',
              name: 'Quinoa Vegetable Bowl + Tofu',
              calories: (calories * 0.28).round(),
              protein: 26,
              carbs: 52,
              fat: 12,
              isVeg: veg,
            ),
          ],
          FitnessGoalValue.maintain: <MealSuggestion>[
            MealSuggestion(
              id: 'm1',
              type: 'Breakfast',
              time: '7:30 AM',
              name: 'Besan Chilla + Mint Chutney + Curd',
              calories: (calories * 0.22).round(),
              protein: 20,
              carbs: 36,
              fat: 10,
              isVeg: veg,
            ),
            MealSuggestion(
              id: 'm2',
              type: 'Lunch',
              time: '1:00 PM',
              name: 'Chhole + Jeera Rice + Salad',
              calories: (calories * 0.32).round(),
              protein: 28,
              carbs: 55,
              fat: 12,
              isVeg: veg,
            ),
            MealSuggestion(
              id: 'm3',
              type: 'Snack',
              time: '4:00 PM',
              name: 'Mixed Nuts + Seasonal Fruit',
              calories: (calories * 0.12).round(),
              protein: 8,
              carbs: 22,
              fat: 14,
              isVeg: veg,
            ),
            MealSuggestion(
              id: 'm4',
              type: 'Dinner',
              time: '7:30 PM',
              name: 'Paneer Bhurji + Roti + Dal',
              calories: (calories * 0.34).round(),
              protein: 32,
              carbs: 44,
              fat: 16,
              isVeg: veg,
            ),
          ],
        },
      };
  return mealSets[dietType]?[goal] ??
      mealSets[DietTypeValue.nonVeg]![FitnessGoalValue.maintain]!;
}

WorkoutDay? getTodayWorkout(List<WorkoutDay> plan) {
  final int weekday = DateTime.now().weekday;
  final int index = weekday == 7 ? 6 : weekday - 1;
  if (index < 0 || index >= plan.length) return null;
  return plan[index];
}

PlanSnapshot buildPlanSnapshot(AppUser user, int currentWeek) {
  final String goal = normalizeGoal(user.goal);
  final String fitnessLevel = normalizeFitnessLevel(user.fitnessLevel);
  final String activityLevel = normalizeActivityLevel(user.activityLevel);
  final String dietType = normalizeDietType(user.dietType);
  final AppUser normalizedUser = user.copyWith(
    goal: goal,
    fitnessLevel: fitnessLevel,
    activityLevel: activityLevel,
    dietType: dietType,
  );

  final List<WorkoutDay> weekly = generateWeeklyPlan(
    normalizedUser,
    currentWeek,
  );
  final int tdee = calculateTdee(normalizedUser);
  final int calorieTarget = getCalorieTarget(tdee, goal);
  final Map<String, int> macros = _getMacros(calorieTarget, goal);
  final Map<String, dynamic> bmiData = calculateBmi(normalizedUser);

  return PlanSnapshot(
    weekly: weekly,
    nutrition: NutritionPlan(
      calories: (calorieTarget * 0.68).round(),
      proteinGoal: macros['proteinGoal'] ?? 150,
      carbsGoal: macros['carbsGoal'] ?? 220,
      fatGoal: macros['fatGoal'] ?? 65,
      meals: generateMealPlan(calorieTarget, goal, dietType),
    ),
    tdee: tdee,
    bmi: bmiData['bmi'] as double,
    bmiStatus: bmiData['status'] as String,
  );
}

PlanSnapshot defaultPlanSnapshot() {
  return buildPlanSnapshot(
    AppUser(
      id: 'default',
      name: 'User',
      email: '',
      joinedAt: DateTime.now().toIso8601String(),
      height: '170',
      weight: '70',
      age: '25',
      goal: FitnessGoalValue.maintain,
      fitnessLevel: FitnessLevelValue.beginner,
      activityLevel: ActivityLevelValue.moderate,
      workoutDaysPerWeek: 3,
    ),
    1,
  );
}
