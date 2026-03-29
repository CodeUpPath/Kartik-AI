import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import '../state/app_model.dart';
import '../ui.dart';

class NutritionTab extends StatelessWidget {
  const NutritionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    final ({
      String planSource,
      NutritionPlan nutritionPlan,
      DayData todayData,
      int tdee,
      int waterGoal,
    })
    nutrition = context
        .select<
          AppModel,
          ({
            String planSource,
            NutritionPlan nutritionPlan,
            DayData todayData,
            int tdee,
            int waterGoal,
          })
        >(
          (AppModel model) => (
            planSource: model.planSource,
            nutritionPlan: model.nutritionPlan,
            todayData: model.todayData,
            tdee: model.tdee,
            waterGoal: model.waterGoal,
          ),
        );
    final String planLabel = nutrition.planSource == 'ai'
        ? 'AI meal plan'
        : nutrition.planSource == 'fallback'
        ? 'Backup meal plan'
        : 'Profile meal plan';
    final int remaining =
        (nutrition.nutritionPlan.calories -
                nutrition.todayData.caloriesConsumed)
            .clamp(0, 100000);
    final double calorieProgress = nutrition.nutritionPlan.calories <= 0
        ? 0
        : nutrition.todayData.caloriesConsumed /
              nutrition.nutritionPlan.calories;

    return AppBackdrop(
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          children: <Widget>[
            Text(
              'Nutrition',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Track meals, macros, and hydration for today.',
              style: TextStyle(color: palette.textSecondary),
            ),
            const SizedBox(height: 12),
            StatusPill(
              label: planLabel,
              background: palette.primaryLight.withValues(alpha: 0.7),
              foreground: palette.primary,
              icon: nutrition.planSource == 'ai'
                  ? Icons.auto_awesome_rounded
                  : Icons.restaurant_menu_rounded,
            ),
            const SizedBox(height: 20),
            FitnessCard(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _SummaryStat(
                          label: 'TDEE',
                          value: nutrition.tdee.toString(),
                          accent: palette.info,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SummaryStat(
                          label: 'Goal',
                          value: nutrition.nutritionPlan.calories.toString(),
                          accent: palette.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _SummaryStat(
                          label: 'Left',
                          value: remaining.toString(),
                          accent: remaining < 200
                              ? palette.danger
                              : palette.accent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: calorieProgress.clamp(0, 1),
                      minHeight: 10,
                      backgroundColor: palette.surface,
                      color: calorieProgress > 1
                          ? palette.danger
                          : palette.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Text(
                        '${nutrition.todayData.caloriesConsumed} kcal consumed',
                        style: TextStyle(
                          color: palette.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${(calorieProgress * 100).round()}%',
                        style: TextStyle(
                          color: calorieProgress > 1
                              ? palette.danger
                              : palette.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SectionHeader(title: 'Macronutrients'),
            FitnessCard(
              child: Column(
                children: <Widget>[
                  _MacroRow(
                    label: 'Protein',
                    consumed: nutrition.todayData.proteinConsumed,
                    goal: nutrition.nutritionPlan.proteinGoal,
                    color: const Color(0xFFE74C3C),
                  ),
                  const SizedBox(height: 14),
                  _MacroRow(
                    label: 'Carbs',
                    consumed: nutrition.todayData.carbsConsumed,
                    goal: nutrition.nutritionPlan.carbsGoal,
                    color: const Color(0xFFF39C12),
                  ),
                  const SizedBox(height: 14),
                  _MacroRow(
                    label: 'Fat',
                    consumed: nutrition.todayData.fatConsumed,
                    goal: nutrition.nutritionPlan.fatGoal,
                    color: const Color(0xFF9B59B6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SectionHeader(title: 'Hydration'),
            FitnessCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${nutrition.todayData.water}/${nutrition.waterGoal} glasses',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: palette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tap a glass to set today’s intake.',
                    style: TextStyle(color: palette.textSecondary),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List<Widget>.generate(nutrition.waterGoal, (
                      int index,
                    ) {
                      final bool active = index < nutrition.todayData.water;
                      return GestureDetector(
                        onTap: () =>
                            context.read<AppModel>().setWater(index + 1),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: active
                                ? palette.primary.withValues(alpha: 0.18)
                                : palette.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: active ? palette.primary : palette.border,
                            ),
                          ),
                          child: Icon(
                            Icons.water_drop_outlined,
                            color: active ? palette.primary : palette.textLight,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SectionHeader(
              title: "Today's Meals",
              actionLabel: '+ Add',
              onAction: () => showDialog<void>(
                context: context,
                builder: (_) => const _AddMealDialog(),
              ),
            ),
            ...nutrition.nutritionPlan.meals.map((MealSuggestion meal) {
              final bool logged = nutrition.todayData.mealsLogged.contains(
                meal.id,
              );
              final Color typeColor = _mealColor(meal.type);
              return FitnessCard(
                key: ValueKey<String>(meal.id),
                borderColor: logged
                    ? palette.primary.withValues(alpha: 0.16)
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            meal.type,
                            style: TextStyle(
                              color: typeColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          meal.time,
                          style: TextStyle(color: palette.textLight),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      meal.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${meal.calories} kcal • ${meal.protein}P • ${meal.carbs}C • ${meal.fat}F',
                      style: TextStyle(color: palette.textSecondary),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: meal.isVeg
                                ? palette.primary.withValues(alpha: 0.12)
                                : palette.danger.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            meal.isVeg ? 'Veg' : 'Non-Veg',
                            style: TextStyle(
                              color: meal.isVeg
                                  ? palette.primary
                                  : palette.danger,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 112,
                          child: PrimaryButton(
                            label: logged ? 'Logged' : 'Log Meal',
                            small: true,
                            outline: logged,
                            onPressed: () =>
                                context.read<AppModel>().toggleMeal(meal),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            if (nutrition.todayData.customMeals.isNotEmpty) ...<Widget>[
              const SizedBox(height: 8),
              SectionHeader(title: 'Added By You'),
              ...nutrition.todayData.customMeals.map(
                (CustomMeal meal) => FitnessCard(
                  key: ValueKey<String>(meal.id),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: _mealColor(
                            meal.mealType,
                          ).withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.restaurant_menu,
                          color: _mealColor(meal.mealType),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              meal.name,
                              style: TextStyle(
                                color: palette.textPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${meal.mealType} • ${meal.time}',
                              style: TextStyle(color: palette.textSecondary),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${meal.calories} kcal • ${meal.protein}P • ${meal.carbs}C • ${meal.fat}F',
                              style: TextStyle(
                                color: palette.textLight,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () =>
                            context.read<AppModel>().deleteCustomMeal(meal.id),
                        icon: Icon(Icons.delete_outline, color: palette.danger),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _mealColor(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return const Color(0xFFF39C12);
      case 'Lunch':
        return const Color(0xFF2ECC71);
      case 'Snack':
        return const Color(0xFF9B59B6);
      case 'Dinner':
        return const Color(0xFF3498DB);
      default:
        return const Color(0xFF2ECC71);
    }
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: palette.textSecondary)),
        ],
      ),
    );
  }
}

class _MacroRow extends StatelessWidget {
  const _MacroRow({
    required this.label,
    required this.consumed,
    required this.goal,
    required this.color,
  });

  final String label;
  final int consumed;
  final int goal;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    final double progress = goal <= 0 ? 0 : consumed / goal;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: palette.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              '$consumed/$goal g',
              style: TextStyle(color: palette.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: 10,
            backgroundColor: palette.surface,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _AddMealDialog extends StatefulWidget {
  const _AddMealDialog();

  @override
  State<_AddMealDialog> createState() => _AddMealDialogState();
}

class _AddMealDialogState extends State<_AddMealDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  String _mealType = 'Breakfast';
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final int calories = int.tryParse(_caloriesController.text.trim()) ?? 0;
    final int protein = int.tryParse(_proteinController.text.trim()) ?? 0;
    final int carbs = int.tryParse(_carbsController.text.trim()) ?? 0;
    final int fat = int.tryParse(_fatController.text.trim()) ?? 0;
    if (_nameController.text.trim().isEmpty || calories <= 0) return;
    setState(() => _saving = true);
    await context.read<AppModel>().addCustomMeal(
      name: _nameController.text.trim(),
      mealType: _mealType,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return AlertDialog(
      backgroundColor: palette.card,
      title: Text(
        'Add Food',
        style: TextStyle(
          color: palette.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppTextField(
              controller: _nameController,
              label: 'Meal name',
              hint: 'Chicken salad',
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _mealType,
              decoration: const InputDecoration(labelText: 'Meal type'),
              items: const <String>['Breakfast', 'Lunch', 'Snack', 'Dinner']
                  .map(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
              onChanged: (String? value) {
                if (value != null) setState(() => _mealType = value);
              },
            ),
            const SizedBox(height: 14),
            AppTextField(
              controller: _caloriesController,
              label: 'Calories',
              hint: '400',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),
            Row(
              children: <Widget>[
                Expanded(
                  child: AppTextField(
                    controller: _proteinController,
                    label: 'Protein',
                    hint: '25',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppTextField(
                    controller: _carbsController,
                    label: 'Carbs',
                    hint: '30',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            AppTextField(
              controller: _fatController,
              label: 'Fat',
              hint: '12',
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }
}
