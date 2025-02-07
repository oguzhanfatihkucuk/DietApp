import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                      _buildInfoRow('Müşteri ID', customer['customerID'].toString()),
                      _buildInfoRow('Diyetisyen ID', customer['dietitianID'].toString()),
                      _buildInfoRow('Yaş', customer['age'].toString()),
                      _buildInfoRow('Cinsiyet', customer['gender']),
                      _buildInfoRow('Boy', '${customer['height']} cm'),
                      _buildInfoRow('Kilo', '${customer['weight']} kg'),
                      _buildInfoRow('Vücut Kitle İndeksi', customer['bodyMassIndex'].toString()),
                      _buildInfoRow('Hedef Kilo', '${customer['targetWeight']} kg'),
                      _buildInfoRow('Aktivite Seviyesi', customer['activityLevel']),
                      _buildInfoRow('Telefon', customer['phone']),
                      _buildInfoRow('Email', customer['email']),
                      Divider(height: 28,),
                      _buildSectionTitle('Sağlık Durumu'),
                      _buildInfoRow('Kronik Hastalıklar', customer['healthStatus']['chronicDiseases'].join(', ')),
                      _buildInfoRow('Alerjiler', customer['healthStatus']['allergies'].join(', ')),
                      _buildInfoRow('İlaç Kullanımı', customer['healthStatus']['medicationUse'].join(', ')),
                      Divider(height: 28,),
                      _buildSectionTitle('Beslenme Alışkanlıkları'),
                      _buildInfoRow('Vegan', customer['dietaryHabits']['vegan'] ? 'Evet' : 'Hayır'),
                      _buildInfoRow('Vejetaryen', customer['dietaryHabits']['vegetarian'] ? 'Evet' : 'Hayır'),
                      _buildInfoRow('Sevilen Yiyecekler', customer['dietaryHabits']['likedFoods'].join(', ')),
                      _buildInfoRow('Sevilmeyen Yiyecekler', customer['dietaryHabits']['dislikedFoods'].join(', ')),
                      Divider(height: 28,),
                      _buildSectionTitle('Su Tüketimi'),
                      _buildInfoRow('Günlük Su Miktarı', '${customer['waterConsumption']['dailyWaterAmount']} litre'),
                      _buildInfoRow('Su Tüketim Alışkanlığı', customer['waterConsumption']['waterConsumptionHabit']),
                      Divider(height: 28,),
                      _buildSectionTitle('Hedefler'),
                      _buildInfoRow('Kilo Verme', customer['goals']['weightLoss'] ? 'Evet' : 'Hayır'),
                      _buildInfoRow('Kas Kazanma', customer['goals']['muscleGain'] ? 'Evet' : 'Hayır'),
                      _buildInfoRow('Daha Sağlıklı Beslenme', customer['goals']['healthierEating'] ? 'Evet' : 'Hayır'),
                      Divider(height: 28,),
                      _buildSectionTitle('Diyet Planları'),
                      ...customer['dietPlans'].map<Widget>((plan) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          child: ExpansionTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow('Plan Adı', plan['planName']),
                                _buildInfoRow('Tarih Aralığı', '${plan['startDate']} - ${plan['endDate']}'),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoRow('Günlük Kalori Hedefi', '${plan['dailyCalorieTarget']} kcal'),
                                    _buildInfoRow('Günlük Protein Hedefi', '${plan['dailyProteinTarget']} g'),
                                    _buildInfoRow('Günlük Yağ Hedefi', '${plan['dailyFatTarget']} g'),
                                    _buildInfoRow('Günlük Karbonhidrat Hedefi', '${plan['dailyCarbohydrateTarget']} g'),
                                    _buildSectionTitle('Planlanan Öğünler'),
                                    ...plan['meals'].map<Widget>((meal) {
                                      return Card(
                                        margin: EdgeInsets.symmetric(vertical: 8),
                                        elevation: 3,
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              _buildInfoRow('Öğün Adı', meal['mealName']),
                                              _buildInfoRow('Yiyecekler', meal['foods'].join(', ')),
                                              _buildInfoRow('Kalori', '${meal['calories']} kcal'),
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
                      Divider(height: 28,),

                      _buildSectionTitle('İlerleme Takibi'),
                      ...customer['progressTracking'].map<Widget>((progress) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          child: ExpansionTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow('Tarih', progress['date']),

                              ],
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoRow('Kilo', '${progress['weight']} kg'),
                                    _buildInfoRow('Vücut Yağ Oranı', '${progress['bodyFatPercentage']}%'),
                                    _buildInfoRow('Kas Kütlesi', '${progress['muscleMass']} kg'),
                                    _buildInfoRow('Notlar', progress['notes']),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      Divider(height: 28,),
                      _buildSectionTitle('Müşteri Tamamlanan Öğünleri'),
                      ...customer['weeklyMeals'].map<Widget>((weeklyMeals) {
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          child: ExpansionTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow('Tarih', weeklyMeals['date']),
                                _buildInfoRow('Toplam Kalori', '${weeklyMeals['totalCaloriesConsumed']} kcal'),
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Öğün adı
                                          Padding(
                                            padding: EdgeInsets.symmetric(vertical: 8),
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
                                              padding: EdgeInsets.only(bottom: 4),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      food['foodName'],
                                                      style: TextStyle(fontSize: 14),
                                                    ),
                                                  ),
                                                  Text(
                                                    food['portion'],
                                                    style: TextStyle(color: Colors.grey[600]),
                                                  ),
                                                  SizedBox(width: 20),
                                                  Text(
                                                    '${food['calories']} kcal',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.green[700],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),

                                          // Öğün toplamı
                                          Padding(
                                            padding: EdgeInsets.only(top: 8, bottom: 12),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}