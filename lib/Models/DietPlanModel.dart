import 'package:intl/intl.dart';
import 'Meal.dart';

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

  factory DietPlan.fromJson(Map<String, dynamic> json) {
    return DietPlan(
      planID: json['planID'],
      planName: json['planName'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      dailyCalorieTarget: json['dailyCalorieTarget'],
      dailyProteinTarget: json['dailyProteinTarget'],
      dailyFatTarget: json['dailyFatTarget'],
      dailyCarbohydrateTarget: json['dailyCarbohydrateTarget'],
      meals: (json['meals'] as List)
          .map((meal) => Meal.fromJson(meal))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planID': planID,
      'planName': planName,
      'startDate': DateFormat('yyyy-MM-dd').format(startDate), // DateTime → String
      'endDate': DateFormat('yyyy-MM-dd').format(endDate), // DateTime → String
      'dailyCalorieTarget': dailyCalorieTarget,
      'dailyProteinTarget': dailyProteinTarget,
      'dailyFatTarget': dailyFatTarget,
      'dailyCarbohydrateTarget': dailyCarbohydrateTarget,
      'meals': meals.map((meal) => meal.toJson()).toList(),
    };
  }
}