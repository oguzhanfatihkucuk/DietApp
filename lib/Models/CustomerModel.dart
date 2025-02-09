import 'WaterConsumption.dart';
import 'DietPlanModel.dart';
import 'DietaryHabits.dart';
import 'Goals.dart';
import 'HealthStatus.dart';

class Customer {
  int customerID;
  int dietitianID;
  String firstName;
  String lastName;
  String email;
  String phone;
  bool isLoginBefore;
  int age;
  String gender;
  double height;
  double weight;
  double bodyMassIndex;
  double targetWeight;
  String activityLevel;

  HealthStatus healthStatus;
  DietaryHabits dietaryHabits;
  WaterConsumption waterConsumption;
  Goals goals;

  List<DietPlan> dietPlans;
  List<dynamic> progressTracking;
  List<dynamic> weeklyMeals;

  Customer({
    required this.customerID,
    required this.dietitianID,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.isLoginBefore,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.bodyMassIndex,
    required this.targetWeight,
    required this.activityLevel,
    required this.healthStatus,
    required this.dietaryHabits,
    required this.goals,
    required this.waterConsumption,
    required this.dietPlans,
    required this.progressTracking,
    required this.weeklyMeals,
    
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerID: json['customerID'],
      dietitianID: json['dietitianID'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      isLoginBefore: json['isLoginBefore'] ?? false,
      age: json['age'],
      gender: json['gender'],
      height: json['height'].toDouble(),
      weight: json['weight'].toDouble(),
      bodyMassIndex: json['bodyMassIndex']?.toDouble(),
      targetWeight: json['targetWeight']?.toDouble(),
      activityLevel: json['activityLevel'],
      healthStatus: HealthStatus.fromJson(json['healthStatus']),
      dietaryHabits: DietaryHabits.fromJson(json['dietaryHabits']),
      waterConsumption: WaterConsumption.fromJson(json['waterConsumption']),
      goals: Goals.fromJson(json['goals']),
      dietPlans: (json['dietPlans'] as List)
          .map((plan) => DietPlan.fromJson(plan))
          .toList(),
      progressTracking: json['progressTracking'] ?? [],
      weeklyMeals: json['weeklyMeals'] ?? [],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerID': customerID,
      'dietitianID': dietitianID,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'isLoginBefore': isLoginBefore,
      'age': age,
      'gender': gender,
      'height': height,
      'weight': weight,
      'bodyMassIndex': bodyMassIndex,
      'targetWeight': targetWeight,
      'activityLevel': activityLevel,
      'healthStatus': healthStatus.toJson(),
      'dietaryHabits': dietaryHabits.toJson(),
      'waterConsumption': waterConsumption.toJson(),
      'goals': goals.toJson(),
      'dietPlans': dietPlans.map((plan) => plan.toJson()).toList(),
      'progressTracking': progressTracking,
      'weeklyMeals': weeklyMeals,
    };
  }
}
