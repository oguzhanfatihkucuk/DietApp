import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:diet/Models/CustomerModel.dart';
import '../Components/buildInfoRow.dart';
import '../Components/buildSectionTitle.dart';
import '../Components/buildListInfo.dart';
import '../Models/WeeklyMealModel.dart';
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
      final ref =
          FirebaseDatabase.instance.ref('customer/${customer.customerID}');
      final snapshot = await ref.get();

      if (snapshot.exists) {
        setState(() {
          // Mevcut müşteriyi güncelle
          customer = Customer.fromJson(snapshot.value as Map<dynamic, dynamic>);
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
            _buildWaterConsumption(),
            _buildDietSection(),
            _buildProgressTrack(),
            _buildDoneMeals(),
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
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: _navigateToEditScreen,
            ),
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
            buildInfoRow('', ""),
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
  Widget _buildProgressTrack() {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle('İlerleme Takibi'),
            SizedBox(height: 8.0),
            ...(customer.progressTracking ?? [])
                .map((progress) => Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ExpansionTile(
                        key: ValueKey(progress.date.toString()),
                        title: Text(
                          DateFormat('dd/MM/yyyy').format(progress.date),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        children: [
                          Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                            elevation: 1.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'İlerleme Detayları',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => confirmDelete(
                                            'customer/${customer.customerID}/progressTracking/${progress.progressID}'),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  buildInfoRow('Kilo', '${progress.weight} kg'),
                                  SizedBox(height: 4.0),
                                  buildInfoRow('Vücut Yağı',
                                      '%${progress.bodyFatPercentage.toStringAsFixed(1)}'),
                                  SizedBox(height: 4.0),
                                  buildInfoRow('Kas Kütlesi',
                                      '${progress.muscleMass} kg'),
                                  SizedBox(height: 4.0),
                                  buildInfoRow('Notlar', progress.notes),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDoneMeals() {
    // Tarihe göre gruplama yap
    final Map<String, List<WeeklyMealModel>> groupedMeals = {};
    for (var weekly in customer.weeklyMeals) {
      final dateKey = DateFormat('dd.MM.yyyy').format(weekly.date);
      if (!groupedMeals.containsKey(dateKey)) {
        groupedMeals[dateKey] = [];
      }
      groupedMeals[dateKey]!.add(weekly);
    }

    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle('Tamamlanan Öğünler'),
            SizedBox(height: 8.0),
            ...groupedMeals.entries.map((entry) {
              final date = entry.key;
              final weeklyMeals = entry.value;

              // Tarihe ait toplam kaloriyi hesapla
              final totalCalories = weeklyMeals.fold(
                  0, (sum, weekly) => sum + weekly.totalCaloriesConsumed);

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ExpansionTile(
                  title: Text(
                    date,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    'Toplam Kalori: $totalCalories kcal',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                  children: [
                    // Tarihe ait tüm öğünleri göster
                    ...weeklyMeals
                        .map((weekly) => Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Öğün Detayları',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => confirmDelete(
                                            'customer/${customer.customerID}/weeklyMeals/${weekly.weeklyID}'),
                                      ),
                                    ],
                                  ),
                                ),
                                ...weekly.meals
                                    .map((meal) => Card(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 4.0, horizontal: 8.0),
                                          elevation: 1.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: ExpansionTile(
                                            title: Text(
                                              meal.mealName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                              ),
                                            ),
                                            subtitle: Text(
                                              '${meal.totalCalories} kcal',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 13,
                                              ),
                                            ),
                                            children: [
                                              ...meal.foods
                                                  .map((food) => ListTile(
                                                        title: Text(
                                                          food.foodName,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        subtitle: Text(
                                                          '${food.calories} kcal - ${food.portion}',
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[600],
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                        leading: Icon(
                                                          Icons.fastfood,
                                                          color: Colors.orange,
                                                        ),
                                                      ))
                                                  .toList(),
                                              ListTile(
                                                dense: true,
                                                title: Text(
                                                  'Toplam Kalori: ${meal.totalCalories} kcal',
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'Günlük Toplam: ${weekly.totalCaloriesConsumed} kcal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
                  ],
                ),
              );
            }).toList(),
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
      elevation: 4.0,
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTitle('Aktif Diyet Planları'),
            SizedBox(height: 8.0),
            ...customer.dietPlans
                .map((plan) => Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ExpansionTile(
                        title: Text(
                          plan.planName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          '${DateFormat('dd/MM/yyyy').format(plan.startDate)} - '
                          '${DateFormat('dd/MM/yyyy').format(plan.endDate)}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                        children: [
                          Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                            elevation: 1.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Plan Detayları',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () => confirmDelete(
                                            'customer/${customer.customerID}/dietPlans/${plan.planID}'),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  buildInfoRow('Günlük Kalori',
                                      '${plan.dailyCalorieTarget} kcal'),
                                  SizedBox(height: 4.0),
                                  buildInfoRow('Protein',
                                      '${plan.dailyProteinTarget} g'),
                                  SizedBox(height: 4.0),
                                  buildInfoRow(
                                      'Yağ', '${plan.dailyFatTarget} g'),
                                  SizedBox(height: 4.0),
                                  buildInfoRow('Karbonhidrat',
                                      '${plan.dailyCarbohydrateTarget} g'),
                                ],
                              ),
                            ),
                          ),
                          // Meals section
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                top: 8.0,
                                bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Öğünler',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                ...plan.meals.map((meal) => Card(
                                      margin: EdgeInsets.only(bottom: 8.0),
                                      elevation: 1.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: ExpansionTile(
                                        title: Text(
                                          meal.mealName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '${meal.calories} kcal',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13,
                                          ),
                                        ),
                                        children: meal.foods
                                            .map<Widget>((food) => ListTile(
                                                  title: Text(
                                                    food,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  leading: Icon(
                                                    Icons.fastfood,
                                                    color: Colors.orange,
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
