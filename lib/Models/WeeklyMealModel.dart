import 'package:intl/intl.dart';

class WeeklyMealModel {
  final DateTime date;
  final List<WeeklyMeal> meals;
  final int totalCaloriesConsumed;

  WeeklyMealModel({
    required this.date,
    required this.meals,
    required this.totalCaloriesConsumed,
  });

  factory WeeklyMealModel.fromJson(Map<dynamic, dynamic> json) {
    final dateFormat = DateFormat('dd.MM.yyyy'); // Formatı belirle

    return WeeklyMealModel(
      date: json['date'] != null
          ? dateFormat.parse(json['date'] as String) // String → DateTime
          : DateTime.now(),
      meals: (json['meals'] as List<dynamic>)
          .map((meal) => WeeklyMeal.fromJson(meal as Map<dynamic, dynamic>))
          .toList(),
      totalCaloriesConsumed: (json['totalCaloriesConsumed'] as num).toInt(),
    );
  }

  Map<dynamic, dynamic> toJson() {
    final dateFormat = DateFormat('dd.MM.yyyy'); // Aynı format

    return {
      'date': dateFormat.format(date), // DateTime → String
      'meals': meals.map((meal) => meal.toJson()).toList(),
      'totalCaloriesConsumed': totalCaloriesConsumed,
    };
  }
}

class WeeklyMeal {
  final String mealName;
  final List<Food> foods;
  final int totalCalories;

  WeeklyMeal({
    required this.mealName,
    required this.foods,
    required this.totalCalories,
  });

  factory WeeklyMeal.fromJson(Map<dynamic, dynamic> json) {
    return WeeklyMeal(
      mealName: json['mealName'] as String,
      totalCalories: json['totalCalories'] as int,
      foods: (json['foods'] as List).map((food) => Food.fromJson(food)).toList(),
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'mealName': mealName,
      'totalCalories': totalCalories,
      'foods': foods.map((food) => food.toJson()).toList(),
    };
  }
}

class Food {
  final int calories;
  final String foodName;
  final String portion;

  Food({
    required this.calories,
    required this.foodName,
    required this.portion,
  });

  factory Food.fromJson(Map<dynamic, dynamic> json) {
    return Food(
      calories: json['calories'] as int,
      foodName: json['foodName'] as String,
      portion: json['portion'] as String,
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'calories': calories,
      'foodName': foodName,
      'portion': portion,
    };
  }
}