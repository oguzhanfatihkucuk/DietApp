import 'MealModel.dart';

class DietPlan {
  String planID;
  String planName;
  DateTime startDate;
  DateTime endDate;
  int dailyCalorieTarget;
  int dailyProteinTarget;
  int dailyFatTarget;
  int dailyCarbohydrateTarget;
  List<Meal> meals;

  DietPlan({
    required this.planID,
    required this.planName,
    required this.startDate,
    required this.endDate,
    required this.dailyCalorieTarget,
    required this.dailyProteinTarget,
    required this.dailyFatTarget,
    required this.dailyCarbohydrateTarget,
    required this.meals,
  });
}