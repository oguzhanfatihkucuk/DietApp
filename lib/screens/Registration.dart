import 'dart:convert';
import 'package:diet/Models/WeeklyMealModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Models/CustomerModel.dart';
import '../Models/DietPlanModel.dart';
import '../Models/DietaryHabits.dart';
import '../Models/Goals.dart';
import '../Models/HealthStatus.dart';
import '../Models/ProgressTracking.dart';
import '../Models/WaterConsumption.dart';
import 'dart:math';

int generate8DigitId() {
  final random = Random();
  return 100000 + random.nextInt(900000);
}

class RegistrationMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Müşteri Kayıt Ekranı',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CustomerRegistrationScreen(),
    );
  }
}

class CustomerRegistrationScreen extends StatefulWidget {
  @override
  _CustomerRegistrationScreenState createState() =>
      _CustomerRegistrationScreenState();
}

class _CustomerRegistrationScreenState
    extends State<CustomerRegistrationScreen> {
  final database = FirebaseDatabase.instance.ref();

  Future<void> saveData(String key, Map<dynamic, dynamic> data) async {
    try {
      await database.child(key).set(data); //TODO set?
      print('Data saved successfully!');
    } catch (e) {
      print('Error saving data: $e');
    }
  }

  final _formKey = GlobalKey<FormState>();

  // Kullanıcı Bilgileri
  int customerID = generate8DigitId();
  int dietitianID = 1; // Eksik değişken eklendi
  bool isLoginBefore = false; // Eksik değişken eklendi

  // Kişisel Bilgiler
  late String firstName;

  late String lastName;

  late String email;

  late String phone;

  late int age;

  late String gender = "Kadın"; // Default değeri Kadın
  late double height;

  late double weight;

  late double targetWeight;

  late String activityLevel = "Orta";

// Sağlık Durumu
  List<String> allergies = [];
  List<String> medicationUse = [];
  List<String> chronicDiseases = []; // Eksik değişken eklendi

// Beslenme Alışkanlıkları
  String dietaryHabits = 'Normal';
  bool vegan = false;
  bool vegetarian = false;
  List<String> likedFoods = []; // Eksik değişken eklendi
  List<String> dislikedFoods = []; // Eksik değişken eklendi

// Su Tüketimi
  int dailyWaterAmount = 0;
  String waterConsumptionHabit = '';

// Hedefler
  bool weightLoss = false;
  bool muscleGain = false;
  bool healthierEating = false;

  List<DietPlanModel> dietPlans = []; // Diyet Listesi
  List<ProgressTracking> progressTracking = [];
  List<WeeklyMealModel> weeklyMeals = [];

// Vücut Kitle İndeksi Hesaplaması
  double get bodyMassIndex {
    if (height > 0) {
      return weight / ((height / 100) * (height / 100));
    }
    return 0.0;
  }

  final FirebaseAuth _auth = FirebaseAuth.instance; // _auth değişkenini tanımla
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Future<String?> registerUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Kullanıcı kaydı başarılı olduğunda uid'yi al
      final uid = userCredential.user!.uid;
      print('Kullanıcı kaydı başarılı. UID: $uid');

      return uid; // Yeni kullanıcının uid'sini döndür
    } catch (e) {
      print('Kullanıcı kaydı hatası: $e');
      return null;
    }
  }

  // Formu gönder
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Yeni kullanıcı için Firebase Authentication'da hesap oluştur
      final String email = '${firstName.toLowerCase()}.${lastName.toLowerCase()}@example.com'; // Örnek e-posta
      final String password = 'password123'; // Örnek şifre

      final String? uid = await registerUser(email, password);

      if (uid == null) {
        print('Kullanıcı kaydı başarısız!');
        return;
      }

      // Yeni müşteri nesnesi oluştur
      final newCustomer = Customer(
        customerID: uid, // Firebase Authentication'dan gelen uid'yi kullan
        dietitianID: dietitianID,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        isLoginBefore: isLoginBefore,
        age: age,
        gender: gender,
        height: height,
        weight: weight,
        bodyMassIndex: bodyMassIndex,
        targetWeight: targetWeight,
        activityLevel: activityLevel,
        healthStatus: HealthStatus(
          chronicDiseases: chronicDiseases,
          allergies: allergies,
          medicationUse: medicationUse,
        ),
        dietaryHabits: DietaryHabits(
          vegan: vegan,
          vegetarian: vegetarian,
          likedFoods: likedFoods,
          dislikedFoods: dislikedFoods,
        ),
        waterConsumption: WaterConsumption(
          dailyWaterAmount: dailyWaterAmount,
          waterConsumptionHabit: waterConsumptionHabit,
        ),
        goals: Goals(
          weightLoss: weightLoss,
          muscleGain: muscleGain,
          healthierEating: healthierEating,
        ),
        dietPlans: dietPlans,
        progressTracking: progressTracking,
        weeklyMeals: weeklyMeals,
      );

      // JSON'a çevirme ve loglama
      final customerJson = newCustomer.toJson();
      final jsonString = JsonEncoder.withIndent('  ').convert(customerJson);

      // Firebase'e kaydet (uid altında)
      final path = 'customer/$uid'; // Kullanıcı uid'sini path olarak kullan
      await database.child(path).set(customerJson);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Kayıt Başarılı'),
          content: Text('Müşteri başarıyla kaydedildi. Firebase UID: $uid'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tamam'),
            )
          ],
        ),
      );

      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Müşteri Kayıt', style: TextStyle(fontSize: 24)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Kişisel Bilgiler
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kişisel Bilgiler',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(labelText: 'Ad'),
                                onSaved: (value) => firstName = value!,
                                initialValue: "a",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Ad boş olamaz';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(labelText: 'Soyad'),
                                onSaved: (value) => lastName = value!,
                                initialValue: "a",
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Soyad boş olamaz';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'E-posta'),
                          onSaved: (value) => email = value!,
                          initialValue: "a@",
                          validator: (value) {
                            if (value == null || !value.contains('@')) {
                              return 'Geçerli bir e-posta adresi girin';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Telefon'),
                          onSaved: (value) => phone = value!,
                          initialValue: "a",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Telefon boş olamaz';
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(labelText: 'Yaş'),
                                keyboardType: TextInputType.number,
                                initialValue: "1",
                                onSaved: (value) => age = int.parse(value!),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      int.tryParse(value) == null) {
                                    return 'Geçerli bir yaş girin';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: gender,
                                decoration:
                                    InputDecoration(labelText: 'Cinsiyet'),
                                onChanged: (newValue) {
                                  setState(() {
                                    gender = newValue!;
                                  });
                                },
                                validator: (value) {
                                  // Form validation için
                                  if (value == null) {
                                    return 'Lütfen cinsiyet seçiniz';
                                  }
                                  return null;
                                },
                                items: ['Kadın', 'Erkek']
                                    .map((label) => DropdownMenuItem(
                                          child: Text(label),
                                          value: label,
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Boy (cm)'),
                                keyboardType: TextInputType.number,
                                initialValue: "1",
                                onSaved: (value) =>
                                    height = double.parse(value!),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      double.tryParse(value) == null) {
                                    return 'Geçerli bir boy girin';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Kilo (kg)'),
                                keyboardType: TextInputType.number,
                                initialValue: "1",
                                onSaved: (value) =>
                                    weight = double.parse(value!),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      double.tryParse(value) == null) {
                                    return 'Geçerli bir kilo girin';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Hedef Kilo'),
                                initialValue: "1",
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      double.tryParse(value) == null) {
                                    return 'Geçerli bir kilo girin';
                                  }
                                  return null;
                                },
                                onSaved: (value) =>
                                    targetWeight = double.parse(value!),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: activityLevel.isNotEmpty &&
                                        ['Az', 'Orta', 'Yeterli', 'Yüksek']
                                            .contains(activityLevel)
                                    ? activityLevel
                                    : "Az",
                                // Eğer geçerli bir değer değilse null yap
                                decoration: InputDecoration(
                                    labelText: 'Aktivite Seviyesi'),

                                onChanged: (newValue) {
                                  setState(() {
                                    activityLevel = newValue!;
                                  });
                                },
                                items: ['Az', 'Orta', 'Yeterli', 'Yüksek']
                                    .map((label) => DropdownMenuItem(
                                          value: label,
                                          child: Text(label),
                                        ))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Sağlık Durumu
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sağlık Durumu',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Kronik Hastalıklar (virgülle ayırın)',
                          ),
                          onSaved: (value) => chronicDiseases =
                              value!.isEmpty ? [] : value.split(', '),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen kronik hastalıklarınızı giriniz.';
                            }
                            return null; // Geçerli bir değer girildiğinde null döndürülür.
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Alerjiler (virgülle ayırın)',
                          ),
                          onSaved: (value) => allergies =
                              value!.isEmpty ? [] : value.split(', '),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen alerjilerinizi giriniz.';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'İlaçlar (virgülle ayırın)',
                          ),
                          onSaved: (value) => medicationUse =
                              value!.isEmpty ? [] : value.split(', '),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen kullandığınız ilaçları giriniz.';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Beslenme Alışkanlıkları
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Beslenme Alışkanlıkları',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Sevdiği Yiyecekler (virgülle ayırın)',
                          ),
                          onSaved: (value) => likedFoods =
                              value!.isEmpty ? [] : value.split(', '),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen sevdiğiniz yiyecekleri giriniz.';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Sevmediği Yiyecekler (virgülle ayırın)',
                          ),
                          onSaved: (value) => dislikedFoods =
                              value!.isEmpty ? [] : value.split(', '),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen sevmediğiniz yiyecekleri giriniz.';
                            }
                            return null;
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Vegan'),
                          value: vegan,
                          onChanged: (value) {
                            setState(() {
                              vegan = value!;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Vejetaryen'),
                          value: vegetarian,
                          onChanged: (value) {
                            setState(() {
                              vegetarian = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Su Tüketimi
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      // Column'un içeriğe göre boyut almasını sağla
                      children: [
                        Text(
                          'Su Tüketimi',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Günlük Su Tüketimi (litre)'),
                          keyboardType: TextInputType.number,
                          initialValue: "1",
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                double.tryParse(value) == null) {
                              return 'Geçerli bir değer girin';
                            }
                            return null;
                          },
                          onSaved: (value) =>
                              dailyWaterAmount = int.parse(value!),
                        ),
                        SizedBox(height: 10),
                        // Expanded yerine boşluk ekleyerek daha iyi bir görünüm sağlıyoruz
                        DropdownButtonFormField<String>(
                          value: waterConsumptionHabit != null &&
                                  ['Kötü', 'Orta', 'Yeterli', 'İyi']
                                      .contains(waterConsumptionHabit)
                              ? waterConsumptionHabit
                              : null, // Eğer geçerli bir değer değilse null yap
                          decoration: InputDecoration(
                              labelText: 'Su Tüketim Alışkanlığı'),
                          onChanged: (newValue) {
                            setState(() {
                              waterConsumptionHabit = newValue!;
                            });
                          },
                          items: ['Kötü', 'Orta', 'Yeterli', 'İyi']
                              .map((label) => DropdownMenuItem(
                                    value: label,
                                    child: Text(label),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),
                // Hedefler
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hedefler',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        CheckboxListTile(
                          title: Text('Kilo Verme'),
                          value: weightLoss,
                          onChanged: (value) {
                            setState(() {
                              weightLoss = value!;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Kas Kazanımı'),
                          value: muscleGain,
                          onChanged: (value) {
                            setState(() {
                              muscleGain = value!;
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text('Daha Sağlıklı Beslenme'),
                          value: healthierEating,
                          onChanged: (value) {
                            setState(() {
                              healthierEating = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Kayıt Ol'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
