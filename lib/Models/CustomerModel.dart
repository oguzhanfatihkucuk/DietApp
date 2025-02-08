import 'DietPlanModel.dart';

class Customer {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final int age;
  final String gender;
  final double height;
  final double weight;
  final String healthStatus;
  final String dietaryHabits;
  final double dailyWaterAmount;
  final String waterConsumptionHabit;
  final String goals;
  final List<DietPlan> dietPlans;

  Customer({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    required this.healthStatus,
    required this.dietaryHabits,
    required this.dailyWaterAmount,
    required this.waterConsumptionHabit,
    required this.goals,
    required this.dietPlans,
  });
}