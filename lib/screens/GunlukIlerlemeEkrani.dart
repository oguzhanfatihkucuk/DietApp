import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GunlukIlerlemeEkrani extends StatefulWidget {
  @override
  _GunlukIlerlemeEkraniState createState() => _GunlukIlerlemeEkraniState();
}

class _GunlukIlerlemeEkraniState extends State<GunlukIlerlemeEkrani> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  User? _user;
  Map<dynamic, dynamic>? _userData;

  // Değişkenleri başlangıç değerleriyle initialize et
  double gunlukKaloriHedefi = 0;
  double tuketilenKalori = 0;
  double kalanKalori = 0;
  double progressValue = 0.0;
  final double yakilanKalori = 690;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) async {
      if (user != null && mounted) {
        _user = user;
        await _getUserData();
        if (mounted) {
          _verileriHesapla();
        }
      }
    });
  }

  Future<void> _getUserData() async {
    try {
      final snapshot = await _database.child('customer/${_user!.uid}').get();

      if (!snapshot.exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Kullanıcı verisi bulunamadı')));
        }
        return;
      }

      final userData = Map<dynamic, dynamic>.from(snapshot.value as Map);

      if (mounted) {
        setState(() => _userData = userData);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Hata: ${e.toString()}')));
      }
    }
  }

  void _verileriHesapla() {
    if (_userData == null) return;

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd.MM.yyyy');
    final String today = formatter.format(now);

    // Diyet planlarını al
    final dietPlans = _userData!['dietPlans'] as Map<dynamic, dynamic>? ?? {};

    // Haftalık öğünleri al
    final weeklyMeals = _userData!['weeklyMeals'] as Map<dynamic, dynamic>? ?? {};

    // Aktif diyet planını bul
    final activePlan = dietPlans.values.firstWhere(
          (plan) => DateTime.parse(plan['endDate']).isAfter(now),
      orElse: () => {'dailyCalorieTarget': 2181},
    );

    // Bugüne ait TÜM öğünleri bul ve topla
    double totalTuketilen = 0;

    weeklyMeals.forEach((key, value) {
      final mealDate = value['date']?.toString() ?? '';
      if (mealDate == today) {
        final calories = value['totalCaloriesConsumed'] as int? ?? 0;
        totalTuketilen += calories.toDouble();
      }
    });

    // Alternatif LINQ stili çözüm:
    // totalTuketilen = weeklyMeals.values
    //     .where((meal) => meal['date'] == today)
    //     .fold(0.0, (sum, meal) => sum + (meal['totalCaloriesConsumed'] as num).toDouble());

    setState(() {
      gunlukKaloriHedefi = activePlan['dailyCalorieTarget'].toDouble();
      tuketilenKalori = totalTuketilen;
      kalanKalori = gunlukKaloriHedefi - tuketilenKalori;
      progressValue = (tuketilenKalori / gunlukKaloriHedefi).clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildKaloriTakipWidget(),
            _buildBugununOgunleri(),
          ],
        ),
      ),
    );
  }
  // Yeni eklenen widget
  Widget _buildBugununOgunleri() {
    if (_userData == null) return SizedBox.shrink();

    final weeklyMeals = _userData!['weeklyMeals'] as Map<dynamic, dynamic>? ?? {};
    final today = DateFormat('dd.MM.yyyy').format(DateTime.now());
    final bugununOgunleri = weeklyMeals.values.where((meal) => meal['date'] == today).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Today's Meals",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 10),
          if (bugununOgunleri.isEmpty)
            _buildBosOgunKarti()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: bugununOgunleri.length,
              itemBuilder: (context, index) {
                final gunlukOgun = bugununOgunleri[index];
                return _buildOgunKarti(gunlukOgun);
              },
            ),
        ],
      ),
    );
  }

// Öğün kartı widget'ı
  Widget _buildOgunKarti(Map<dynamic, dynamic> ogun) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ogun['totalCaloriesConsumed'].toString() + ' kcal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Chip(
                  label: Text('Total'),
                  backgroundColor: Colors.green[100],
                )
              ],
            ),
            SizedBox(height: 10),
            ...(ogun['meals'] as List<dynamic>).map((meal) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(),
                  SizedBox(height: 8),
                  Text(
                    meal['mealName'] ?? 'Meal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  ...(meal['foods'] as List<dynamic>).map((food) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(Icons.restaurant_menu, size: 16, color: Colors.grey),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${food['foodName']} (${food['portion']})',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Text(
                            '${food['calories']} kcal',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

// Boş öğün durumu için widget
  Widget _buildBosOgunKarti() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.fastfood, size: 40, color: Colors.grey[400]),
            SizedBox(height: 10),
            Text(
              'No meals recorded today',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildKaloriTakipWidget() {
    if (_userData == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleIcon(Icons.calendar_today),
                  Text(
                    DateFormat('dd.MM.yyyy').format(DateTime.now()),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  _buildCircleIcon(Icons.more_horiz),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildKaloriColumn(
                  icon: Icons.local_fire_department,
                  value: yakilanKalori,
                  label: 'burn',
                  color: Colors.orange,
                ),
                _buildKaloriGrafik(),
                _buildKaloriColumn(
                  icon: Icons.restaurant,
                  value: tuketilenKalori,
                  label: 'eaten',
                  color: Colors.green,
                ),
              ],
            ),
          ),
          _buildHedefKalori(),
          _buildSuTakip(),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCircleIcon(IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.black54, size: 20),
    );
  }

  Widget _buildKaloriColumn({
    required IconData icon,
    required double value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color),
        SizedBox(height: 8),
        Text(
          value.toStringAsFixed(0),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildKaloriGrafik() {
    return Container(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[50],
            ),
          ),
          SizedBox(
            width: 160,
            height: 160,
            child: CircularProgressIndicator(
              value: progressValue,
              strokeWidth: 15,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              color: Colors.amber,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                kalanKalori.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Text(
                'Kcal available',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHedefKalori() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text(
            gunlukKaloriHedefi.toStringAsFixed(0),
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            'Kcal Goal',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSuTakip() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Water',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
              SizedBox(width: 8),
              Text(
                '0.9L (75%)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('0.1L',
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                  Text('0.2L',
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recomended until now 1.4L',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: List.generate(
                          7,
                          (index) => _buildWaterIndicator(
                                filled: index < 4,
                                halfFilled: index == 4,
                              )),
                    ),
                  ],
                ),
              ),
              _buildSuButonu(Icons.remove, Colors.green[300]!),
              SizedBox(width: 8),
              _buildSuButonu(Icons.add, Colors.green[400]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuButonu(IconData icon, Color color) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildWaterIndicator({bool filled = false, bool halfFilled = false}) {
    Color color = filled
        ? Colors.blue
        : halfFilled
            ? Colors.blue.withOpacity(0.5)
            : Colors.grey[300]!;

    return Container(
      width: 16,
      height: 24,
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(Icons.water_drop, color: Colors.white, size: 12),
    );
  }
}
