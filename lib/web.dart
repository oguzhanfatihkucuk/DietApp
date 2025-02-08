import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'Components/buildInfoRow.dart';
import 'Components/buildSectionTitle.dart';

void main() {
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

  @override
  void initState() {
    super.initState();
    loadCustomerData();
  }

  Future<void> loadCustomerData() async {
    String jsonString = await rootBundle.loadString('customer.json');
    setState(() {
      customers = json.decode(jsonString);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Müşteri Takip Arayüzü', style: TextStyle(fontSize: 24)),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          var customer = customers[index];
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
      ),
    );
  }
}