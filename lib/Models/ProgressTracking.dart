import 'package:intl/intl.dart';

class ProgressTracking {
  final DateTime date;
  final double weight;
  final double bodyFatPercentage;
  final double muscleMass;
  final String notes;

  ProgressTracking({
    required this.date,
    required this.weight,
    required this.bodyFatPercentage,
    required this.muscleMass,
    required this.notes,
  });

  factory ProgressTracking.fromJson(Map<dynamic, dynamic> json) { // dynamic → String
    return ProgressTracking(
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      bodyFatPercentage: (json['bodyFatPercentage'] as num?)?.toDouble() ?? 0.0,
      muscleMass: (json['muscleMass'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes']?.toString() ?? '',
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'date': DateFormat('yyyy-MM-dd').format(date), // EKSİK OLAN KISIM
      'weight': weight,
      'bodyFatPercentage': bodyFatPercentage,
      'muscleMass': muscleMass,
      'notes': notes,
    };
  }
}