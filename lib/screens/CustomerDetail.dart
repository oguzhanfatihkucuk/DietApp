import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:diet/Models/CustomerModel.dart';
import '../Components/buildInfoRow.dart';
import '../Components/buildSectionTitle.dart'; // Özel widget'larınız olduğunu varsayıyorum
import '../Components/buildListInfo.dart';

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${customer.firstName} ${customer.lastName}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPersonalInfo(),
            _buildHealthSection(),
            _buildDietSection(),
            _buildProgressSection(),
            _buildWaterConsumption(),
            _buildDietPlans(),
          ],
        ),
      ),
    );
  }

  // 1. KİŞİSEL BİLGİLER
  Widget _buildPersonalInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildSectionTitle('Kişisel Bilgiler'),
            buildInfoRow('Müşteri ID', customer.customerID.toString()),
            buildInfoRow('Diyetisyen ID', customer.dietitianID.toString()),
            buildInfoRow(
                'Ad Soyad', '${customer.firstName} ${customer.lastName}'),
            buildInfoRow('Yaş', customer.age.toString()),
            buildInfoRow('Cinsiyet', customer.gender),
            buildInfoRow('Boy', '${customer.height.toStringAsFixed(1)} cm'),
            buildInfoRow('Kilo', '${customer.weight.toStringAsFixed(1)} kg'),
            buildInfoRow('VKİ', customer.bodyMassIndex.toStringAsFixed(1)),
            buildInfoRow('Hedef Kilo', '${customer.targetWeight} kg'),
            buildInfoRow('Aktivite Seviyesi', customer.activityLevel),
            buildInfoRow('Email', customer.email),
            buildInfoRow('Telefon', customer.phone),
          ],
        ),
      ),
    );
  }

  // 2. SAĞLIK DURUMU
  Widget _buildHealthSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildSectionTitle('Sağlık Durumu'),
            ...buildListInfo(
                'Kronik Hastalıklar', customer.healthStatus.chronicDiseases),
            ...buildListInfo('Alerjiler', customer.healthStatus.allergies),
            ...buildListInfo(
                'Kullanılan İlaçlar', customer.healthStatus.medicationUse),
          ],
        ),
      ),
    );
  }

  // 3. BESLENME ALIŞKANLIKLARI
  Widget _buildDietSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildSectionTitle('Beslenme Alışkanlıkları'),
            buildInfoRow(
                'Vegan', customer.dietaryHabits.vegan ? 'Evet' : 'Hayır'),
            buildInfoRow('Vejetaryen',
                customer.dietaryHabits.vegetarian ? 'Evet' : 'Hayır'),
            ...buildListInfo(
                'Sevilen Yiyecekler', customer.dietaryHabits.likedFoods),
            ...buildListInfo(
                'Sevilmeyen Yiyecekler', customer.dietaryHabits.dislikedFoods),
          ],
        ),
      ),
    );
  }

  // 4. İLERLEME TAKİBİ
  Widget _buildProgressSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildSectionTitle('İlerleme Takibi'),
            ...(customer.progressTracking ?? []) // Null ise boş liste kullan
                .map((progress) => ExpansionTile(
                      key: ValueKey(progress.date.toString()), // Unique key
                      title:
                          Text(DateFormat('dd/MM/yyyy').format(progress.date)),
                      children: [
                        buildInfoRow('Kilo', '${progress.weight} kg'),
                        buildInfoRow('Vücut Yağı',
                            '%${progress.bodyFatPercentage.toStringAsFixed(1)}'),
                        buildInfoRow(
                            'Kas Kütlesi', '${progress.muscleMass} kg'),
                        buildInfoRow('Notlar', progress.notes),
                      ],
                    ))
                .toList(),
            buildSectionTitle('Tamamlanan Öğünler'),
            ...customer.weeklyMeals.map((weekly) => ExpansionTile(
              title: Text(DateFormat('dd/MM/yyyy').format(weekly.date)),
              subtitle: Text('Toplam Kalori: ${weekly.totalCaloriesConsumed} kcal'),
              children: [
                ...weekly.meals.map((meal) => ExpansionTile(
                  title: Text(meal.mealName),
                  subtitle: Text('${meal.totalCalories} kcal'),
                  trailing: Text('${meal.foods.length} çeşit'),
                  children: [
                    ...meal.foods.map((food) => ListTile(
                      title: Text(food.foodName),
                      subtitle: Text('${food.calories} kcal - ${food.portion}'),
                      leading: Icon(Icons.fastfood),
                    )).toList(),

                    // Ek bilgi satırı
                    ListTile(
                      dense: true,
                      title: Text('Toplam Kalori: ${meal.totalCalories} kcal'),
                      textColor: Colors.blue,
                    ),
                  ],
                )).toList(),

                // Haftalık toplam
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Günlük Toplam: ${weekly.totalCaloriesConsumed} kcal',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 16
                    ),
                  ),
                )
              ],
            )).toList()
          ],
        ),
      ),
    );
  }

  // 5. SU TÜKETİMİ
  Widget _buildWaterConsumption() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildSectionTitle('Su Tüketimi'),
            buildInfoRow('Günlük Miktar', '${customer.waterConsumption.dailyWaterAmount} L'),
            buildInfoRow('Alışkanlık', customer.waterConsumption.waterConsumptionHabit),
          ],
        ),
      ),
    );
  }

  // 6. DİYET PLANLARI
  Widget _buildDietPlans() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildSectionTitle('Aktif Diyet Planları'),
            ...customer.dietPlans
                .map((plan) => ExpansionTile(
                      title: Text(plan.planName),
                      subtitle: Text(
                          '${DateFormat('dd/MM/yyyy').format(plan.startDate)} - '
                          '${DateFormat('dd/MM/yyyy').format(plan.endDate)}'),
                      children: [
                        buildInfoRow(
                            'Günlük Kalori', '${plan.dailyCalorieTarget} kcal'),
                        buildInfoRow('Protein', '${plan.dailyProteinTarget} g'),
                        buildInfoRow('Yağ', '${plan.dailyFatTarget} g'),
                        buildInfoRow('Karbonhidrat',
                            '${plan.dailyCarbohydrateTarget} g'),
                        ...plan.meals
                            .map((meal) => ExpansionTile(
                                  title: Text(meal.mealName),
                                  subtitle:Text('${meal.calories} kcal'),
                          children: meal.foods
                              .map<Widget>((food) => ListTile( // Tür dönüşümü
                            title: Text(food), // Direkt String'i göster
                          ))
                              .toList(),
                                ))
                            ,
                      ],
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  // Yardımcı Metotlar

}


