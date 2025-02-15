class HealthStatus {
  List<String> chronicDiseases;
  List<String> allergies;
  List<String> medicationUse;

  HealthStatus({
    required this.chronicDiseases,
    required this.allergies,
    required this.medicationUse,
  });

  factory HealthStatus.fromJson(Map<dynamic, dynamic> json) {
    return HealthStatus(
      chronicDiseases: List<String>.from(json['chronicDiseases']),
      allergies: List<String>.from(json['allergies']),
      medicationUse: List<String>.from(json['medicationUse']),
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'chronicDiseases': chronicDiseases,
      'allergies': allergies,
      'medicationUse': medicationUse,
    };
  }
}