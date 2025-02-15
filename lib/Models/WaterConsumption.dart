class WaterConsumption {
  double dailyWaterAmount;
  String waterConsumptionHabit;

  WaterConsumption({
    required this.dailyWaterAmount,
    required this.waterConsumptionHabit,
  });

  // JSON'a çevirme (Firebase gibi yerlerde kullanmak için)
  Map<dynamic, dynamic> toJson() {
    return {
      'dailyWaterAmount': dailyWaterAmount,
      'waterConsumptionHabit': waterConsumptionHabit,
    };
  }

  // JSON'dan nesne oluşturma (Veri çekerken kullanışlı olur)
  factory WaterConsumption.fromJson(Map<dynamic, dynamic> json) {
    return WaterConsumption(
      dailyWaterAmount: json['dailyWaterAmount'] ?? 0.0,
      waterConsumptionHabit: json['waterConsumptionHabit'] ?? '',
    );
  }
}
