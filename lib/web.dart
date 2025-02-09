import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'Components/buildInfoRow.dart';
import 'Components/buildSectionTitle.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Müşteri Takip Arayüzü',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // Yazı tipi
        textTheme: TextTheme(
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
      ),
      home: CustomerInfoScreen(),
    );
  }
}

class CustomerInfoScreen extends StatefulWidget {
  @override
  _CustomerInfoScreenState createState() => _CustomerInfoScreenState();
}

class _CustomerInfoScreenState extends State<CustomerInfoScreen> {
  List<dynamic> customers = [];
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('customer');

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    try {
      final DatabaseReference ref = FirebaseDatabase.instance.ref("customer");
      final snapshot = await ref.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        List<dynamic> customerList = values.values.toList();

        setState(() {
          customers = customerList;
        });
      } else {
        print("🔥 Veri bulunamadı!");
      }
    } catch (e) {
      print("⚠️ Veri çekme hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Müşteri Takip Arayüzü', style: TextStyle(fontSize: 24)),
        centerTitle: true,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _databaseRef.onValue,
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.hasError) {
            return Center(child: Text('Hata oluştu: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data?.snapshot?.value == null) {
            print("Firebase'den gelen veri NULL!");
            return Center(child: Text('Müşteri bulunamadı.'));
          }
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(child: Text('Müşteri bulunamadı.'));
          }

          // Verileri işleme
          Map<dynamic, dynamic> data =
          snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          List<dynamic> customerList = data.values.toList();

          return ListView.builder(
            itemCount: customerList.length,
            itemBuilder: (context, index) {
              var customer = customerList[index];
              // Mevcut ExpansionTile yapınız aynen kalacak
              return Card(
                margin: EdgeInsets.all(10),
                elevation: 5,
                child: ExpansionTile(
                  title: Text(
                    '${customer['firstName']} ${customer['lastName']}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildInfoRow(
                              'Müşteri ID', customer['customerID'].toString()),
                          buildInfoRow(
                              'Diyetisyen ID', customer['dietitianID'].toString()),
                          buildInfoRow('Yaş', customer['age'].toString()),
                          buildInfoRow('Cinsiyet', customer['gender']),
                          buildInfoRow('Boy', '${customer['height']} cm'),
                          buildInfoRow('Kilo', '${customer['weight']} kg'),
                          buildInfoRow('Vücut Kitle İndeksi',
                              customer['bodyMassIndex'].toString()),
                          buildInfoRow(
                              'Hedef Kilo', '${customer['targetWeight']} kg'),
                          buildInfoRow(
                              'Aktivite Seviyesi', customer['activityLevel']),
                          buildInfoRow('Telefon', customer['phone']),
                          buildInfoRow('Email', customer['email']),
                          Divider(
                            height: 28,
                          ),
                          buildSectionTitle('Sağlık Durumu'),
                          buildInfoRow(
                              'Kronik Hastalıklar',
                              customer['healthStatus']['chronicDiseases']
                                  .join(', ')),
                          buildInfoRow('Alerjiler',
                              customer['healthStatus']['allergies'].join(', ')),
                          buildInfoRow('İlaç Kullanımı',
                              customer['healthStatus']['medicationUse'].join(', ')),
                          Divider(
                            height: 28,
                          ),
                          buildSectionTitle('Beslenme Alışkanlıkları'),
                          buildInfoRow(
                              'Vegan',
                              customer['dietaryHabits']['vegan']
                                  ? 'Evet'
                                  : 'Hayır'),
                          buildInfoRow(
                              'Vejetaryen',
                              customer['dietaryHabits']['vegetarian']
                                  ? 'Evet'
                                  : 'Hayır'),
                          buildInfoRow('Sevilen Yiyecekler',
                              customer['dietaryHabits']['likedFoods'].join(', ')),
                          buildInfoRow(
                              'Sevilmeyen Yiyecekler',
                              customer['dietaryHabits']['dislikedFoods']
                                  .join(', ')),
                          Divider(
                            height: 28,
                          ),
                          buildSectionTitle('Su Tüketimi'),
                          buildInfoRow('Günlük Su Miktarı',
                              '${customer['waterConsumption']['dailyWaterAmount']} litre'),
                          buildInfoRow(
                              'Su Tüketim Alışkanlığı',
                              customer['waterConsumption']
                              ['waterConsumptionHabit']),
                          Divider(
                            height: 28,
                          ),
                          buildSectionTitle('Hedefler'),
                          buildInfoRow('Kilo Verme',customer['goals']['weightLoss'] ? 'Evet' : 'Hayır'),
                          buildInfoRow('Kas Kazanma',customer['goals']['muscleGain'] ? 'Evet' : 'Hayır'),
                          buildInfoRow('Daha Sağlıklı Beslenme',customer['goals']['healthierEating']? 'Evet': 'Hayır'),
                          Divider(
                            height: 28,
                          ),
                          buildSectionTitle('Diyet Planları'),
                          ...customer['dietPlans'].map<Widget>((plan) {
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              elevation: 3,
                              child: ExpansionTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildInfoRow('Plan Adı', plan['planName']),
                                    buildInfoRow('Tarih Aralığı','${plan['startDate']} - ${plan['endDate']}'),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        buildInfoRow('Günlük Kalori Hedefi', '${plan['dailyCalorieTarget']} kcal'),
                                        buildInfoRow('Günlük Protein Hedefi','${plan['dailyProteinTarget']} g'),
                                        buildInfoRow('Günlük Yağ Hedefi','${plan['dailyFatTarget']} g'),
                                        buildInfoRow('Günlük Karbonhidrat Hedefi','${plan['dailyCarbohydrateTarget']} g'),
                                        buildSectionTitle('Planlanan Öğünler'),
                                        ...plan['meals'].map<Widget>((meal) {
                                          return Card(
                                            margin:
                                            EdgeInsets.symmetric(vertical: 8),
                                            elevation: 3,
                                            child: Padding(
                                              padding: EdgeInsets.all(16),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  buildInfoRow(
                                                      'Öğün Adı', meal['mealName']),
                                                  buildInfoRow('Yiyecekler',
                                                      meal['foods'].join(', ')),
                                                  buildInfoRow('Kalori',
                                                      '${meal['calories']} kcal'),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          Divider(
                            height: 28,
                          ),
                          buildSectionTitle('İlerleme Takibi'),
                          ...customer['progressTracking'].map<Widget>((progress) {
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              elevation: 3,
                              child: ExpansionTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildInfoRow('Tarih', progress['date']),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        buildInfoRow(
                                            'Kilo', '${progress['weight']} kg'),
                                        buildInfoRow('Vücut Yağ Oranı',
                                            '${progress['bodyFatPercentage']}%'),
                                        buildInfoRow('Kas Kütlesi',
                                            '${progress['muscleMass']} kg'),
                                        buildInfoRow('Notlar', progress['notes']),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          Divider(
                            height: 28,
                          ),
                          buildSectionTitle('Müşteri Tamamlanan Öğünleri'),
                          ...customer['weeklyMeals'].map<Widget>((weeklyMeals) {
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              elevation: 3,
                              child: ExpansionTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildInfoRow('Tarih', weeklyMeals['date']),
                                    buildInfoRow('Toplam Kalori',
                                        '${weeklyMeals['totalCaloriesConsumed']} kcal'),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Her öğün için liste
                                        ...weeklyMeals['meals'].map<Widget>((meal) {
                                          return Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              // Öğün adı
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8),
                                                child: Text(
                                                  meal['mealName'],
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ),

                                              // Yiyecekler
                                              ...meal['foods'].map<Widget>((food) {
                                                return Padding(
                                                  padding:
                                                  EdgeInsets.only(bottom: 4),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          food['foodName'],
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                      Text(
                                                        food['portion'],
                                                        style: TextStyle(
                                                            color:
                                                            Colors.grey[600]),
                                                      ),
                                                      SizedBox(width: 20),
                                                      Text(
                                                        '${food['calories']} kcal',
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          color: Colors.green[700],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),

                                              // Öğün toplamı
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 8, bottom: 12),
                                                child: Text(
                                                  'Öğün Toplamı: ${meal['totalCalories']} kcal',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                              Divider(),
                                            ],
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],


                ),
              );
            },
          );
        },
      ),
    );
  }
}