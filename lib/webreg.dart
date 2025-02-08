import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Models/CustomerModel.dart';
import 'Models/DietPlanModel.dart';
import 'Models/MealModel.dart';
// Ana Uygulama
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  _CustomerRegistrationScreenState createState() => _CustomerRegistrationScreenState();
}

class _CustomerRegistrationScreenState extends State<CustomerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  List<DietPlan> _dietPlans = [];
  int _planCounter = 1;
  // Kişisel Bilgiler
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  int age = 0;
  String gender = 'Kadın'; // Default değeri Kadın
  double height = 0.0;
  double weight = 0.0;

  // Sağlık Durumu
  String healthStatus = 'Yok'; // Default
  String allergies = 'Gluten';
  String medicationUse = 'Yok';

  // Beslenme Alışkanlıkları
  String dietaryHabits = 'Normal';
  bool vegan = false;
  bool vegetarian = false;

  // Su Tüketimi
  double dailyWaterAmount = 1.5;
  String waterConsumptionHabit = 'Az';

  // Hedefler
  bool weightLoss = false;
  bool muscleGain = false;
  bool healthierEating = false;

  // Diyet Listesi
  List<Meal> meals = [

  ];

  // Formu gönder
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newCustomer = Customer(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        age: age,
        gender: gender,
        height: height,
        weight: weight,
        healthStatus: '$healthStatus, $allergies, $medicationUse',
        dietaryHabits: '$dietaryHabits, Vegan: $vegan, Vegetarian: $vegetarian',
        dailyWaterAmount: dailyWaterAmount,
        waterConsumptionHabit: waterConsumptionHabit,
        goals: 'Kilo Verme: $weightLoss, Kas Kazanımı: $muscleGain, Sağlıklı Beslenme: $healthierEating', dietPlans: [],

      );
    }
  }

  void _addNewDietPlan() {
    setState(() {
      _dietPlans.add(DietPlan(
        planID: 'P${(_planCounter++).toString().padLeft(3, '0')}',
        planName: 'Yeni Plan $_planCounter',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days:7)),
        dailyCalorieTarget: 2000,
        dailyProteinTarget: 50,
        dailyFatTarget: 30,
        dailyCarbohydrateTarget: 100,
        meals: [],
      ));
    });
  }

  void _removeDietPlan(int index) {
    setState(() {
      _dietPlans.removeAt(index);
    });
  }

  void _addMealToPlan(int planIndex) {
    setState(() {
      _dietPlans[planIndex].meals.add(Meal(
        mealName: 'Yeni Öğün',
        foods: [],
        calories: 0,
      ));
    });
  }

  void _removeMealFromPlan(int planIndex, int mealIndex) {
    setState(() {
      _dietPlans[planIndex].meals.removeAt(mealIndex);
    });
  }
  Future<void> _selectDate(BuildContext context, DietPlan plan, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? plan.startDate : plan.endDate,
      firstDate: DateTime(2000),
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
            DateFormat('dd/MM/yyyy').format(
                isStartDate ? plan.startDate : plan.endDate
            ),
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
          child: ListView(
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Ad'),
                              onSaved: (value) => firstName = value!,
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
                        validator: (value) {
                          if (value == null || value.isEmpty || !value.contains('@')) {
                            return 'Geçerli bir e-posta adresi girin';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Telefon'),
                        onSaved: (value) => phone = value!,
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
                              onSaved: (value) => age = int.parse(value!),
                              validator: (value) {
                                if (value == null || value.isEmpty || int.tryParse(value) == null) {
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
                              decoration: InputDecoration(labelText: 'Cinsiyet'),
                              onChanged: (newValue) {
                                setState(() {
                                  gender = newValue!;
                                });
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
                              decoration: InputDecoration(labelText: 'Boy (cm)'),
                              keyboardType: TextInputType.number,
                              onSaved: (value) => height = double.parse(value!),
                              validator: (value) {
                                if (value == null || value.isEmpty || double.tryParse(value) == null) {
                                  return 'Geçerli bir boy girin';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(labelText: 'Kilo (kg)'),
                              keyboardType: TextInputType.number,
                              onSaved: (value) => weight = double.parse(value!),
                              validator: (value) {
                                if (value == null || value.isEmpty || double.tryParse(value) == null) {
                                  return 'Geçerli bir kilo girin';
                                }
                                return null;
                              },
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
                      Text(
                        'Sağlık Durumu',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Kronik Hastalıklar'),
                        onSaved: (value) => healthStatus = value!,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Alerjiler'),
                        onSaved: (value) => allergies = value!,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Kullanılan İlaçlar'),
                        onSaved: (value) => medicationUse = value!,
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
                      Text(
                        'Beslenme Alışkanlıkları',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
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
                    children: [
                      Text(
                        'Su Tüketimi',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Günlük Su Tüketimi (litre)'),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => dailyWaterAmount = double.parse(value!),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Su Tüketim Alışkanlığı'),
                        onSaved: (value) => waterConsumptionHabit = value!,
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: _addNewDietPlan,
                          ),
                        ],
                      ),
                      ..._dietPlans.asMap().entries.map((entry) {
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
                                    decoration: InputDecoration(labelText: 'Plan Adı'),
                                    onChanged: (value) => plan.planName = value,
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      _buildDatePickerField('Başlangıç Tarihi', plan, true),
                                      SizedBox(width: 10),
                                      _buildDatePickerField('Bitiş Tarihi', plan, false),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(labelText: 'Günlük Kalori Hedefi'),
                                          keyboardType: TextInputType.number,
                                          initialValue: plan.dailyCalorieTarget.toString(),
                                          onChanged: (value) => plan.dailyCalorieTarget = int.parse(value),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(labelText: 'Günlük Karbonitrat Hedefi'),
                                          keyboardType: TextInputType.number,
                                          initialValue: plan.dailyCarbohydrateTarget.toString(),
                                          onChanged: (value) => plan.dailyCarbohydrateTarget = int.parse(value),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(labelText: 'Günlük Protein Hedefi'),
                                          keyboardType: TextInputType.number,
                                          initialValue: plan.dailyProteinTarget.toString(),
                                          onChanged: (value) => plan.dailyProteinTarget = int.parse(value),
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          decoration: InputDecoration(labelText: 'Günlük Yağ Hedefi'),
                                          keyboardType: TextInputType.number,
                                          initialValue: plan.dailyFatTarget.toString(),
                                          onChanged: (value) => plan.dailyFatTarget = int.parse(value),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Öğünler'),
                                      IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: () => _addMealToPlan(planIndex),
                                      ),
                                    ],
                                  ),
                                  ...plan.meals.asMap().entries.map((mealEntry) {
                                    int mealIndex = mealEntry.key;
                                    Meal meal = mealEntry.value;
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                initialValue: meal.mealName,
                                                decoration: InputDecoration(labelText: 'Öğün Adı'),
                                                onChanged: (value) => meal.mealName = value,
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete),
                                              onPressed: () => _removeMealFromPlan(planIndex, mealIndex),
                                            ),
                                          ],
                                        ),
                                        TextFormField(
                                          initialValue: meal.foods.join(', '),
                                          decoration: InputDecoration(labelText: 'Yiyecekler (virgülle ayırın)'),
                                          onChanged: (value) => meal.foods = value.split(','),
                                        ),
                                        TextFormField(
                                          initialValue: meal.calories.toString(),
                                          decoration: InputDecoration(labelText: 'Kalori'),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) => meal.calories = int.parse(value),
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

              // Gönder Butonu
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Kayıt Ol'),
                style: ElevatedButton.styleFrom(
                  //primary: Colors.blueAccent,
                  //onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}