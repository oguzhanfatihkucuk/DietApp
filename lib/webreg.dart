import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Models/CustomerModel.dart';
import 'Models/DietPlanModel.dart';
import 'Models/DietaryHabits.dart';
import 'Models/Goals.dart';
import 'Models/HealthStatus.dart';
import 'Models/Meal.dart';
import 'Models/WaterConsumption.dart';
import 'firebase_options.dart';
import 'dart:math';

final database = FirebaseDatabase.instance.ref();

// Function to save data
Future<void> saveData(String key, Map<String, dynamic> data) async {
  try {
    await database.child(key).set(data);
    print('Data saved successfully!');
  } catch (e) {
    print('Error saving data: $e');
  }
}

int _generate8DigitId() {
  final random = Random();
  return 100000 + random.nextInt(900000);
}

// Ana Uygulama
void main() async{
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

  final _formKey = GlobalKey<FormState>();
  int _planCounter = 1;

  // Kullanıcı Bilgileri
  int customerID = _generate8DigitId();
  int dietitianID = 1; // Eksik değişken eklendi
  bool isLoginBefore = false; // Eksik değişken eklendi

  // Kişisel Bilgiler
  late String firstName ;
  late String lastName ;
  late String email ;
  late String phone ;
  late int age ;
  late String gender ="Kadın" ; // Default değeri Kadın
  late double height ;
  late double weight ;
  late double targetWeight ;
  late String activityLevel ="Orta";

// Sağlık Durumu
  List<String> allergies= [] ;
  List<String> medicationUse = [];
  List<String> chronicDiseases = []; // Eksik değişken eklendi

// Beslenme Alışkanlıkları
  String dietaryHabits = 'Normal';
  bool vegan = false;
  bool vegetarian = false;
  List<String> likedFoods = []; // Eksik değişken eklendi
  List<String> dislikedFoods = []; // Eksik değişken eklendi

// Su Tüketimi
  double dailyWaterAmount = 0;
  String waterConsumptionHabit = '';

// Hedefler
  bool weightLoss = false;
  bool muscleGain = false;
  bool healthierEating = false;

  List<DietPlan> dietPlans = []; // Diyet Listesi
  List<Meal> meals = [];


// Vücut Kitle İndeksi Hesaplaması
  double get bodyMassIndex {
    if (height > 0) {
      return weight / ((height / 100) * (height / 100));
    }
    return 0.0;
  }

  // Formu gönder
  Future<void> _submitForm()  async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newCustomer = Customer(
        customerID: customerID,
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
        progressTracking: [],
        weeklyMeals: [], // Diyet planlarını ekleyerek düzelttim
      );

      // JSON'a çevirme ve loglama
      final customerJson = newCustomer.toJson();
      final jsonString = JsonEncoder.withIndent('  ').convert(customerJson);

      final path = 'customer/-Nxyz${newCustomer.customerID}'; // 👈 ID'yi path'e ekle
      saveData(path, customerJson); // 👈 Dinamik path ile kaydet

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Oluşturulan JSON'),
          content: SingleChildScrollView(
            child: Text(jsonString),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Tamam'),
            )
          ],
        ),
      );
      _formKey.currentState!.reset();
      _removeDietPlan(0);
    }
  }

  void _addNewDietPlan() {
    setState(() {
      dietPlans.add(DietPlan(
        planID: 'P${(_planCounter++).toString().padLeft(3, '0')}',
        planName: 'Yeni Plan $_planCounter',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 7)),
        dailyCalorieTarget: 0,
        dailyProteinTarget: 0,
        dailyFatTarget: 0,
        dailyCarbohydrateTarget: 0,
        meals: [],
      ));
    });
  }

  void _removeDietPlan(int index) {
    setState(() {
      dietPlans.removeAt(index);
    });
  }

  void _addMealToPlan(int planIndex) {
    setState(() {
      dietPlans[planIndex].meals.add(Meal(
            mealName: 'Yeni Öğün',
            foods: [],
            calories: 0,
          ));
    });
  }

  void _removeMealFromPlan(int planIndex, int mealIndex) {
    setState(() {
      dietPlans[planIndex].meals.removeAt(mealIndex);
    });
  }

  Future<void> _selectDate(
      BuildContext context, DietPlan plan, bool isStartDate) async {
      final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? plan.startDate : plan.endDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          plan.startDate = picked;
          // Bitiş tarihini otomatik ayarla (örneğin 30 gün sonrası)
          if (plan.endDate.isBefore(picked.add(Duration(days: 30)))) {
            plan.endDate = picked.add(Duration(days: 30));
          }
        } else {
          plan.endDate = picked;
        }
      });
    }
  }

  Widget _buildDatePickerField(String label, DietPlan plan, bool isStartDate) {
    return Expanded(
      child: InkWell(
        onTap: () => _selectDate(context, plan, isStartDate),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
          child: Text(
            DateFormat('dd/MM/yyyy')
                .format((isStartDate ? plan.startDate : plan.endDate)),
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Müşteri Kayıt Ekranı'),
        backgroundColor: Colors.blueAccent,
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
                                decoration:InputDecoration(labelText: 'Cinsiyet'),
                                onChanged: (newValue) {
                                  setState(() {
                                    gender = newValue!;
                                  });
                                },
                                validator: (value) { // Form validation için
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
                              labelText:
                                  'Kronik Hastalıklar (virgülle ayırın)'),
                          onSaved: (value) => chronicDiseases =
                              value!.isEmpty ? [] : value.split(', '),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Alerjiler (virgülle ayırın)'),
                          onSaved: (value) => allergies =
                              value!.isEmpty ? [] : value.split(', '),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText: 'İlaçlar (virgülle ayırın)'),
                          onSaved: (value) => medicationUse =
                              value!.isEmpty ? [] : value.split(', '),
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
                              labelText:
                                  'Sevdiği Yiyecekler (virgülle ayırın)'),
                          onSaved: (value) => likedFoods =
                              value!.isEmpty ? [] : value.split(', '),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              labelText:
                                  'Sevmediği Yiyecekler (virgülle ayırın)'),
                          onSaved: (value) => dislikedFoods =
                              value!.isEmpty ? [] : value.split(', '),
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
                              dailyWaterAmount = double.parse(value!),
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
                // Diyet Listesi
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Diyet Planları',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: _addNewDietPlan,
                            ),
                          ],
                        ),
                        ...dietPlans.asMap().entries.map((entry) {
                          int planIndex = entry.key;
                          DietPlan plan = entry.value;
                          return ExpansionTile(
                            title: Text(plan.planName),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _removeDietPlan(planIndex),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    TextFormField(
                                      initialValue: plan.planName,
                                      decoration: InputDecoration(
                                          labelText: 'Plan Adı'),
                                      onChanged: (value) =>
                                          plan.planName = value,
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        _buildDatePickerField(
                                            'Başlangıç Tarihi', plan, true),
                                        SizedBox(width: 10),
                                        _buildDatePickerField(
                                            'Bitiş Tarihi', plan, false),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                                labelText:
                                                    'Günlük Kalori Hedefi'),
                                            keyboardType: TextInputType.number,
                                            initialValue: plan
                                                .dailyCalorieTarget
                                                .toString(),
                                            onChanged: (value) =>
                                                plan.dailyCalorieTarget =
                                                    int.parse(value),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                                labelText:
                                                    'Günlük Karbonitrat Hedefi'),
                                            keyboardType: TextInputType.number,
                                            initialValue: plan
                                                .dailyCarbohydrateTarget
                                                .toString(),
                                            onChanged: (value) =>
                                                plan.dailyCarbohydrateTarget =
                                                    int.parse(value),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                                labelText:
                                                    'Günlük Protein Hedefi'),
                                            keyboardType: TextInputType.number,
                                            initialValue: plan
                                                .dailyProteinTarget
                                                .toString(),
                                            onChanged: (value) =>
                                                plan.dailyProteinTarget =
                                                    int.parse(value),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            decoration: InputDecoration(
                                                labelText: 'Günlük Yağ Hedefi'),
                                            keyboardType: TextInputType.number,
                                            initialValue:
                                                plan.dailyFatTarget.toString(),
                                            onChanged: (value) =>
                                                plan.dailyFatTarget =
                                                    int.parse(value),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Öğünler'),
                                        IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () =>
                                              _addMealToPlan(planIndex),
                                        ),
                                      ],
                                    ),
                                    ...plan.meals
                                        .asMap()
                                        .entries
                                        .map((mealEntry) {
                                      int mealIndex = mealEntry.key;
                                      Meal meal = mealEntry.value as Meal;
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: TextFormField(
                                                  initialValue: meal.mealName,
                                                  decoration: InputDecoration(
                                                      labelText: 'Öğün Adı'),
                                                  onChanged: (value) =>
                                                      meal.mealName = value,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () =>
                                                    _removeMealFromPlan(
                                                        planIndex, mealIndex),
                                              ),
                                            ],
                                          ),
                                          TextFormField(
                                            initialValue: meal.foods.join(', '),
                                            decoration: InputDecoration(
                                                labelText:
                                                    'Yiyecekler (virgülle ayırın)'),
                                            onChanged: (value) =>
                                                meal.foods = value.split(','),
                                          ),
                                          TextFormField(
                                            initialValue:
                                                meal.calories.toString(),
                                            decoration: InputDecoration(
                                                labelText: 'Kalori'),
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) => meal
                                                .calories = int.parse(value),
                                          ),
                                          Divider(),
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
