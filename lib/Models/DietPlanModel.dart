import 'package:intl/intl.dart';

class DietPlanModel {
  String planID;
  late final String planName;
  late final DateTime startDate;
  late final DateTime endDate;
  late final int dailyCalorieTarget;
  late final int dailyProteinTarget;
  late final int dailyFatTarget;
  late final int dailyCarbohydrateTarget;
  late final List<DietPlanMeal> meals;

  DietPlanModel({
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

  factory DietPlanModel.fromJson(Map<dynamic, dynamic> json) {
    final dateFormat = DateFormat('yyyy-MM-dd');

    return DietPlanModel(
      planID: json['planID']?.toString() ?? '',
      planName: json['planName']?.toString() ?? 'Plansız',
      startDate: json['startDate'] != null
          ? dateFormat.parse(json['startDate'] as String)
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? dateFormat.parse(json['endDate'] as String)
          : DateTime.now(),
      dailyCalorieTarget: (json['dailyCalorieTarget'] as num?)?.toInt() ?? 0,
      dailyProteinTarget: (json['dailyProteinTarget'] as num?)?.toInt() ?? 0,
      dailyFatTarget: (json['dailyFatTarget'] as num?)?.toInt() ?? 0,
      dailyCarbohydrateTarget: (json['dailyCarbohydrateTarget'] as num?)?.toInt() ?? 0,
      meals: (json['meals'] as List<dynamic>?) // List<dynamic> olarak oku
          ?.map((meal) => DietPlanMeal.fromJson(meal as Map<String, dynamic>))
          .toList() ?? [], // List<DietPlanMeal> olarak dönüştür
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'planID': planID,
      'planName': planName,
      'startDate': DateFormat('yyyy-MM-dd').format(startDate),
      'endDate': DateFormat('yyyy-MM-dd').format(endDate),
      'dailyCalorieTarget': dailyCalorieTarget,
      'dailyProteinTarget': dailyProteinTarget,
      'dailyFatTarget': dailyFatTarget,
      'dailyCarbohydrateTarget': dailyCarbohydrateTarget,
      'meals': meals.map((meal) => meal.toJson()).toList(),
    };
  }
}

class DietPlanMeal {
  late final String mealName;
  late final List<String> foods;
  late final int calories;

  DietPlanMeal({
    required this.mealName,
    required this.foods,
    required this.calories,
  });

  factory DietPlanMeal.fromJson(Map<String, dynamic> json) {
    return DietPlanMeal(
      mealName: json['mealName']?.toString() ?? 'Öğün Adı Yok',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      foods: (json['foods'] as List<dynamic>?) // List<dynamic> olarak oku
          ?.map((food) => food.toString()) // Her öğeyi String'e çevir
          .toList() ?? [], // List<String> olarak dönüştür
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mealName': mealName,
      'calories': calories,
      'foods': foods, // List<String> doğrudan JSON'a çevrilebilir
    };
  }
}
