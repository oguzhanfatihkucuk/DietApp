import 'package:diet/Models/WeeklyMealModel.dart';
import 'WaterConsumption.dart';
import 'DietPlanModel.dart';
import 'DietaryHabits.dart';
import 'Goals.dart';
import 'HealthStatus.dart';
import 'ProgressTracking.dart';

class Customer {
  String customerID;
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
  bool isAdmin;
  bool isDietitian;

  HealthStatus healthStatus;
  DietaryHabits dietaryHabits;
  WaterConsumption waterConsumption;
  Goals goals;

  List<ProgressTracking> progressTracking;
  List<DietPlanModel> dietPlans;
  List<WeeklyMealModel> weeklyMeals;

  Customer({
    required this.customerID,
    required this.dietitianID,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.isAdmin,
    required this.isDietitian,
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

  factory Customer.fromJson(Map<dynamic, dynamic> json) {
    return Customer(
      customerID: json['customerID'],
      dietitianID: json['dietitianID'],
      isAdmin: json['isAdmin'],
      isDietitian: json['isDietitian'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      isLoginBefore: json['isLoginBefore'] ?? false,
      age: json['age'],
      gender: json['gender'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      bodyMassIndex: json['bodyMassIndex']?.toDouble(),
      targetWeight: json['targetWeight']?.toDouble(),
      activityLevel: json['activityLevel'],
      healthStatus: HealthStatus.fromJson(json['healthStatus']),
      dietaryHabits: DietaryHabits.fromJson(json['dietaryHabits']),
      waterConsumption: WaterConsumption.fromJson(json['waterConsumption']),
      goals: Goals.fromJson(json['goals']),
      dietPlans: (json['dietPlans'] as Map<dynamic, dynamic>?)?.entries.map((entry) => DietPlanModel.fromJson(entry.value..['planID'] = entry.key)).toList() ?? [],
      progressTracking: (json['progressTracking'] as Map<dynamic, dynamic>?)?.entries.map((entry) {return ProgressTracking.fromJson(entry.value..['progressID'] = entry.key);}).toList() ?? [],
      weeklyMeals: json['weeklyMeals'] != null ? (json['weeklyMeals'] as Map<dynamic, dynamic>).entries.map((entry) => WeeklyMealModel.fromJson(entry.key,Map<dynamic, dynamic>.from(entry.value))).toList(): [],
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'customerID': customerID,
      'dietitianID': dietitianID,
      'firstName': firstName,
      'isAdmin':isAdmin,
      'isDietitan':isDietitian,
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
      'progressTracking': progressTracking.fold<Map<String, dynamic>>({},(map, progress) => map..[progress.progressID] = progress.toJson(),),
      'weeklyMeals': weeklyMeals.map((w) => w.toJson()).toList(),
    };
  }
}

