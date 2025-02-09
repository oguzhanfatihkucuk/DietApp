class Meal {
  String mealName;
  List<String> foods;
  int calories;

  Meal({required this.mealName, required this.foods, required this.calories});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      mealName: json['mealName'],
      foods: List<String>.from(json['foods']),
      calories: json['calories'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mealName': mealName,
      'foods': foods,
      'calories': calories,
    };
  }
}
