import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:diet/Models/CustomerModel.dart';
import '../Components/buildInfoRow.dart';
import '../Components/buildSectionTitle.dart';
import '../Components/buildListInfo.dart';
import 'CustomerEditScreen.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer customer;

  const CustomerDetailScreen({Key? key, required this.customer})
      : super(key: key);

  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  late Customer customer;

  @override
  void initState() {
    super.initState();
    customer = widget.customer;
  }

  void confirmDelete(String path) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Silme Onayı'),
        content: Text('Bu veriyi silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteEntry(path);
            },
            child: Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
  Future<void> deleteEntry(String path) async {
    try {
      await FirebaseDatabase.instance.ref(path).remove();
      await _refreshCustomerData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Başarıyla silindi')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Silme işlemi başarısız: $e')),
      );
    }
  }
  // Müşteri verilerini güncelleme metodu
  Future<void> _refreshCustomerData() async {
    try {
      // Firebase'den müşteri verilerini yeniden çek
      final ref = FirebaseDatabase.instance.ref(
          'customer/${customer.customerID}');
      final snapshot = await ref.get();

      if (snapshot.exists) {
        setState(() {
          // Mevcut müşteriyi güncelle
          customer =
              Customer.fromJson(snapshot.value as Map<dynamic, dynamic>);
        });
      }
    } catch (e) {
      print('Müşteri verileri güncellenirken hata oluştu: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Müşteri bilgileri güncellenemedi')),
      );
    }
  }

  // Düzenleme sayfasına gitme metodu
  void _navigateToEditScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerEditScreen(customer: customer),
      ),
    );

    // Eğer düzenleme yapıldıysa verileri yenile
    if (result == true) {
      await _refreshCustomerData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${customer.firstName} ${customer.lastName}'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _navigateToEditScreen,
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshCustomerData,
          ),
        ],
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
            buildInfoRow('Müşteri ID', customer.customerID),
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
            buildInfoRow(
                '', ""),
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
                .map((progress) =>
                ExpansionTile(
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => confirmDelete(
                        'customer/${customer.customerID}/progressTracking/${progress.progressID}'
                    ),
                  ),
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
            ...customer.weeklyMeals.map((weekly) =>
                ExpansionTile(
                  title: Text(DateFormat('dd/MM/yyyy').format(weekly.date)),
                  subtitle: Text(
                      'Toplam Kalori: ${weekly.totalCaloriesConsumed} kcal'),
                  children: [
                    ...weekly.meals.map((meal) =>
                        ExpansionTile(
                          title: Text(meal.mealName),
                          subtitle: Text('${meal.totalCalories} kcal'),
                          trailing: Text('${meal.foods.length} çeşit'),
                          children: [
                            ...meal.foods.map((food) =>
                                ListTile(
                                  title: Text(food.foodName),
                                  subtitle: Text('${food.calories} kcal - ${food
                                      .portion}'),
                                  leading: Icon(Icons.fastfood),
                                )).toList(),

                            // Ek bilgi satırı
                            ListTile(
                              dense: true,
                              title: Text(
                                  'Toplam Kalori: ${meal.totalCalories} kcal'),
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
            buildInfoRow('Günlük Miktar',
                '${customer.waterConsumption.dailyWaterAmount} L'),
            buildInfoRow(
                'Alışkanlık', customer.waterConsumption.waterConsumptionHabit),
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
                .map((plan) =>
                ExpansionTile(
                  title: Text(plan.planName),
                  subtitle: Text(
                      '${DateFormat('dd/MM/yyyy').format(plan.startDate)} - '
                          '${DateFormat('dd/MM/yyyy').format(plan.endDate)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => confirmDelete(
                        'customer/${customer.customerID}/dietPlans/${plan.planID}'
                    ),
                  ),
                  children: [
                    buildInfoRow(
                        'Günlük Kalori', '${plan.dailyCalorieTarget} kcal'),
                    buildInfoRow('Protein', '${plan.dailyProteinTarget} g'),
                    buildInfoRow('Yağ', '${plan.dailyFatTarget} g'),
                    buildInfoRow('Karbonhidrat',
                        '${plan.dailyCarbohydrateTarget} g'),
                    ...plan.meals
                        .map((meal) =>
                        ExpansionTile(
                          title: Text(meal.mealName),
                          subtitle: Text('${meal.calories} kcal'),
                          children: meal.foods
                              .map<Widget>((food) =>
                              ListTile( // Tür dönüşümü
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
}

