import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Components/BuildDivider.dart';
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
      title: 'Müşteri Kayıt Ekranı',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
  final DatabaseReference _databaseRef =FirebaseDatabase.instance.ref('customer');


  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    try {
      // 1. Firebase referansını oluştur
      final DatabaseReference ref = FirebaseDatabase.instance.ref("customers");

      // 2. Verileri çek
      final DatabaseEvent event = await ref.once();
      final DataSnapshot snapshot = event.snapshot;

      // 3. Veri kontrolü
      if (snapshot.exists) {
        // 4. Veriyi işle
        final Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          // 5. Müşteri listesine dönüştür
          final List<Map<String, dynamic>> customers = data.entries.map((entry) {
            return {
              'id': entry.key,
              ...Map<String, dynamic>.from(entry.value as Map)
            };
          }).toList();

          // 6. State'i güncelle (mounted kontrolü ekledik)
          if (mounted) {
            setState(() {
              this.customers = customers;
            });
          }
        }
      } else {
        print("📭 Veritabanında müşteri bulunamadı");
      }
    } on FirebaseException catch (e) {
      print("🔥 Firebase Hatası: ${e.code} - ${e.message}");
    } catch (e) {
      print("⚠️ Genel Hata: ${e.toString()}");
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
          if (snapshot.hasError) {
            return Center(child: Text('Hata oluştu: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(child: Text('Müşteri bulunamadı.'));
          }

          final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          final customerList = data.values.toList();

          return ListView.builder(
            itemCount: customerList.length,
            itemBuilder: (context, index) {
              final customer = customerList[index] as Map<dynamic, dynamic>;

              // Yardımcı metodlar
              String getField(dynamic field, [String fallback = 'Bilgi yok']) {
                return field?.toString() ?? fallback;
              }

              List<dynamic> safeList(dynamic list) {
                if (list is List<dynamic>) {
                  return list;
                } else if (list is Map) {
                  return list.values.toList(); // Veya list.keys.toList()
                } else {
                  return [];
                }
              }


              return Card(
                margin: EdgeInsets.all(10),
                elevation: 5,
                child: ExpansionTile(
                  title: Text(
                    '${getField(customer["firstName"])} ${getField(customer["lastName"])}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Temel Bilgiler
                          buildInfoRow( 'Müşteri ID', getField(customer['customerID'])),

                          buildInfoRow('Diyetisyen ID',getField(customer['dietitianID'])),

                          buildInfoRow('Yaş', getField(customer['age'])),

                          buildInfoRow('Cinsiyet', getField(customer['gender'])),

                          buildInfoRow( 'Boy', '${getField(customer['height'])} cm'),

                          buildInfoRow('Kilo', '${getField(customer['weight'])} kg'),

                          buildInfoRow('VKİ', customer['bodyMassIndex']?.toStringAsFixed(2)),

                          buildInfoRow('Hedef Kilo','${getField(customer['targetWeight'])} kg'),

                          buildInfoRow('Aktivite Seviyesi', getField(customer['activityLevel'])),

                          buildInfoRow('Telefon', getField(customer['phone'])),

                          buildInfoRow('Email', getField(customer['email'])),

                          buildDivider(),

                          // Sağlık Durumu
                          buildSectionTitle('Sağlık Durumu'),

                          buildInfoRow('Kronik Hastalıklar', safeList(customer['healthStatus']  ?['chronicDiseases']) .join(', ')),

                          buildInfoRow( 'Alerjiler',safeList(customer['healthStatus']?['allergies']).join(', ')),

                          buildInfoRow('İlaç Kullanımı', safeList(customer['healthStatus']?['medicationUse']).join(', ')),

                          buildDivider(),

                          // Beslenme Alışkanlıkları
                          buildSectionTitle('Beslenme Alışkanlıkları'),

                          buildInfoRow( 'Vegan',(customer['dietaryHabits']?['vegan'] == true) ? 'Evet'  : 'Hayır'),

                          buildInfoRow( 'Vejetaryen',(customer['dietaryHabits']?['vegetarian'] == true)? 'Evet': 'Hayır'),

                          buildInfoRow( 'Sevilen Yiyecekler',safeList(customer['dietaryHabits']?['likedFoods']) .join(', ')),

                          buildInfoRow( 'Sevilmeyen Yiyecekler', safeList(customer['dietaryHabits']  ?['dislikedFoods']).join(', ')),

                          buildDivider(),

                          // Su Tüketimi
                          buildSectionTitle('Su Tüketimi'),
                          buildInfoRow('Su Tüketim Alışkanlığı',getField(customer['waterConsumption']?['waterConsumptionHabit'])),

                          buildInfoRow( 'Su Tüketim Alışkanlığı',getField(customer['waterConsumption'] ?['dailyWaterAmount']) +" litre"),

                          buildDivider(),

                          // Hedefler
                          buildSectionTitle('Hedefler'),

                          buildInfoRow('Kilo Verme',(customer['goals']?['weightLoss'] == true) ? 'Evet': 'Hayır'),

                          buildInfoRow( 'Kas Kazanma', (customer['goals']?['muscleGain'] == true)? 'Evet' : 'Hayır'),

                          buildInfoRow('Sağlıklı Beslenme', (customer['goals']?['healthierEating'] == true) ? 'Evet': 'Hayır'),

                          buildDivider(),

                          // Diyet Planları
                          buildSectionTitle('Diyet Planları'),
                          ...safeList(customer['dietPlans'])
                              .map<Widget>((plan) {
                            final p = plan as Map<dynamic, dynamic>;
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              elevation: 3,
                              child: ExpansionTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildInfoRow('Plan Adı', getField(p['planName'])),
                                    buildInfoRow('Tarih', '${getField(p['startDate'])} - ${getField(p['endDate'])}'),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        buildInfoRow('Günlük Kalori','${getField(p['dailyCalorieTarget'])} kcal'),

                                        buildInfoRow('Protein Hedefi','${getField(p['dailyProteinTarget'])} g'),

                                        buildInfoRow('Yağ Hedefi','${getField(p['dailyFatTarget'])} g'),

                                        buildInfoRow('Karbonhidrat Hedefi','${getField(p['dailyCarbohydrateTarget'])} g'),

                                        buildSectionTitle('Öğünler'), ...safeList(p['meals']).map<Widget>((meal) {
                                          final m =
                                              meal as Map<dynamic, dynamic>;
                                          return ListTile(
                                            title:
                                                Text(getField(m['mealName'])),
                                            subtitle: Column(
                                              children: [
                                                buildInfoRow('Kalori','${getField(m['calories'])} kcal'),

                                                buildInfoRow( 'Yiyecekler',safeList(m['foods']).join(', ')),
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
                          }).toList(),
                          buildDivider(),

                          // İlerleme Takibi
                          buildSectionTitle('İlerleme Takibi'),
                          ...safeList(customer['progressTracking'])
                              .map<Widget>((progress) {
                            final p = progress as Map<dynamic, dynamic>;
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              elevation: 3,
                              child: ExpansionTile(
                                title: Text(getField(p['date'])),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        buildInfoRow('Kilo',
                                            '${getField(p['weight'])} kg'),
                                        buildInfoRow('Vücut Yağ Oranı',
                                            '${(p['bodyFatPercentage'] as num?)?.toStringAsFixed(1)}%'),
                                        buildInfoRow('Kas Kütlesi',
                                            '${getField(p['muscleMass'])} kg'),
                                        buildInfoRow(
                                            'Notlar', getField(p['notes'])),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          buildDivider(),

                          // Haftalık Öğünler
                          buildSectionTitle('Tamamlanan Öğünler'),
                          ...safeList(customer['weeklyMeals'])
                              .map<Widget>((weekly) {
                            final w = weekly as Map<dynamic, dynamic>;
                            return ExpansionTile(
                              title: Text(getField(w['date'])),
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      buildInfoRow('Toplam Kalori',
                                          '${getField(w['totalCaloriesConsumed'])} kcal'),
                                      ...safeList(w['meals'])
                                          .map<Widget>((meal) {
                                        final m = meal as Map<dynamic, dynamic>;
                                        return ExpansionTile(
                                          title: Text(getField(m['mealName'])),
                                          subtitle: Text(
                                              'Toplam: ${getField(m['totalCalories'])} kcal'),
                                          children: [
                                            ...safeList(m['foods'])
                                                .map<Widget>((food) {
                                              final f =
                                                  food as Map<dynamic, dynamic>;
                                              return ListTile(
                                                title: Text(
                                                    getField(f['foodName'])),
                                                subtitle: Text(
                                                    '${getField(f['portion'])} - ${getField(f['calories'])} kcal'),
                                              );
                                            }).toList(),
                                          ],
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              ],
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
