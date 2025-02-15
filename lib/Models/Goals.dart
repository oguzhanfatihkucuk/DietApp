class Goals {
  bool weightLoss;
  bool muscleGain;
  bool healthierEating;

  Goals({
    required this.weightLoss,
    required this.muscleGain,
    required this.healthierEating,
  });

  factory Goals.fromJson(Map<dynamic, dynamic> json) {
    return Goals(
      weightLoss: json['weightLoss'],
      muscleGain: json['muscleGain'],
      healthierEating: json['healthierEating'],
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'weightLoss': weightLoss,
      'muscleGain': muscleGain,
      'healthierEating': healthierEating,
    };
  }
}