class DietaryHabits {
  bool vegan;
  bool vegetarian;
  List<String> likedFoods;
  List<String> dislikedFoods;

  DietaryHabits({
    required this.vegan,
    required this.vegetarian,
    required this.likedFoods,
    required this.dislikedFoods,
  });

  factory DietaryHabits.fromJson(Map<String, dynamic> json) {
    return DietaryHabits(
      vegan: json['vegan'],
      vegetarian: json['vegetarian'],
      likedFoods: List<String>.from(json['likedFoods']),
      dislikedFoods: List<String>.from(json['dislikedFoods']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vegan': vegan,
      'vegetarian': vegetarian,
      'likedFoods': likedFoods,
      'dislikedFoods': dislikedFoods,
    };
  }
}