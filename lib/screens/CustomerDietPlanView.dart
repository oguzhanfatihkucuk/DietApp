import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import '../Models/DietPlanModel.dart';


class DietPlansPage extends StatefulWidget {
  @override
  _DietPlansPageState createState() => _DietPlansPageState();
}

class _DietPlansPageState extends State<DietPlansPage> {
  final databaseRef = FirebaseDatabase.instance.ref();
  String customerID = "";
  bool isLoading = true;
  List<DietPlanModel> userDietPlans = [];
  DietPlanModel? selectedPlan;

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
  }

  // Firebase'den giriş yapmış kullanıcının ID'sini alın
  void getCurrentUserId() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      setState(() {
        customerID = currentUser.uid;
      });
      fetchDietPlans();
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kullanıcı girişi yapılmamış.'))
      );
    }
  }

  // Kullanıcıya atanmış diyet planlarını getir
  void fetchDietPlans() async {
    try {
      DatabaseReference ref = databaseRef.child('customer/$customerID/dietPlans');
      DatabaseEvent event = await ref.once();

      // Veri kontrolü
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> plans = event.snapshot.value as Map<dynamic, dynamic>;
        List<DietPlanModel> fetchedPlans = [];

        plans.forEach((key, value) {
          DietPlanModel plan = DietPlanModel.fromJson(value);
          fetchedPlans.add(plan);
        });

        setState(() {
          userDietPlans = fetchedPlans;
          if (fetchedPlans.isNotEmpty) {
            selectedPlan = fetchedPlans[0]; // İlk planı varsayılan olarak seç
          }
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Diyet planları yüklenirken hata: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Diyet planları yüklenirken bir hata oluştu.'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diyet Planlarım'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userDietPlans.isEmpty
          ? _buildEmptyPlansView()
          : _buildPlansView(),
    );
  }

  Widget _buildEmptyPlansView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.no_food, size: 80, color: Colors.grey[400]),
          SizedBox(height: 20),
          Text(
            'Henüz atanmış bir diyet planınız bulunmamaktadır.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlansView() {
    return Column(
      children: [
        // Plan seçme dropdown'ı
        if (userDietPlans.length > 1)
          Container(
            padding: EdgeInsets.all(16),
            child: DropdownButtonFormField<DietPlanModel>(
              decoration: InputDecoration(
                labelText: 'Diyet Planı Seçin',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              value: selectedPlan,
              items: userDietPlans.map((plan) {
                return DropdownMenuItem<DietPlanModel>(
                  value: plan,
                  child: Text('${plan.planName} (${DateFormat('yyyy-MM-dd').format(plan.startDate)} - ${DateFormat('yyyy-MM-dd').format(plan.endDate)})'),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedPlan = newValue;
                });
              },
            ),
          ),

        // Seçilen plan detayları
        if (selectedPlan != null)
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPlanHeader(),
                  SizedBox(height: 20),
                  _buildCalorieTargets(),
                  SizedBox(height: 20),
                  _buildMealsList(),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlanHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.green[50],
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedPlan!.planName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                ),
                Icon(Icons.restaurant_menu, color: Colors.green[700]),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Tarih Aralığı: ${DateFormat('yyyy-MM-dd').format(selectedPlan!.startDate)} - ${DateFormat('yyyy-MM-dd').format(selectedPlan!.endDate)}',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieTargets() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Günlük Hedefler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 12),
            _buildTargetRow(
              icon: Icons.local_fire_department,
              title: 'Kalori',
              value: '${selectedPlan!.dailyCalorieTarget} kcal',
              color: Colors.red[400]!,
            ),
            Divider(),
            _buildTargetRow(
              icon: Icons.grain,
              title: 'Karbonhidrat',
              value: '${selectedPlan!.dailyCarbohydrateTarget} g',
              color: Colors.amber[700]!,
            ),
            Divider(),
            _buildTargetRow(
              icon: Icons.fitness_center,
              title: 'Protein',
              value: '${selectedPlan!.dailyProteinTarget} g',
              color: Colors.blue[700]!,
            ),
            Divider(),
            _buildTargetRow(
              icon: Icons.opacity,
              title: 'Yağ',
              value: '${selectedPlan!.dailyFatTarget} g',
              color: Colors.orange[400]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetRow({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Önerilen Öğünler',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 12),
        if (selectedPlan!.meals.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'Bu planda henüz belirlenmiş öğün bulunmamaktadır.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          )
        else
          ...selectedPlan!.meals.map((meal) => _buildMealCard(meal)).toList(),
      ],
    );
  }

  Widget _buildMealCard(DietPlanMeal meal) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  meal.mealName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${meal.calories} kcal',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            if (meal.foods.isEmpty)
              Text(
                'Besin bilgisi bulunamadı',
                style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Besinler:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  ...meal.foods.map((food) => Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 4),
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 8, color: Colors.green[700]),
                        SizedBox(width: 8),
                        Text(food),
                      ],
                    ),
                  )).toList(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}