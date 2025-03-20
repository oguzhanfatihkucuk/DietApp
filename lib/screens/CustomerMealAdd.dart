import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import '../Models/WeeklyMealModel.dart';

class WeeklyMealFormScreen extends StatefulWidget {
  @override
  _WeeklyMealFormScreenState createState() => _WeeklyMealFormScreenState();
}

class _WeeklyMealFormScreenState extends State<WeeklyMealFormScreen> {
  final databaseRef = FirebaseDatabase.instance.ref();
  final _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();

  // Düzenlenebilir liste - meal state'i tam olarak modele benzetiyoruz
  List<_EditableMeal> editableMeals = [
    _EditableMeal(
        mealName: "Kahvaltı",
        foods: [_EditableFood(foodName: "", portion: "", calories: 0)]
    )
  ];

  String customerID = "";

  @override
  void initState() {
    super.initState();
    getCurrentUserId();
  }

  // Mevcut kullanıcının ID'sini almak için fonksiyon
  void getCurrentUserId() {
    // Firebase Authentication'dan mevcut kullanıcıyı al
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      // Eğer kullanıcı giriş yapmışsa, ID'sini değişkene ata
      setState(() {
        customerID = currentUser.uid;
      });
      print("Giriş yapmış kullanıcı ID: $customerID");
    } else {
      // Kullanıcı giriş yapmamışsa yapılacak işlemler
      print("Giriş yapmış kullanıcı bulunamadı!");
      // Burada kullanıcıyı giriş sayfasına yönlendirebilirsiniz
      // Navigator.of(context).pushReplacementNamed('/login');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Haftalık Öğün Takibi'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDatePicker(),
              SizedBox(height: 20),
              Text(
                'Öğünler',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ..._buildMealsList(),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _addMeal,
                  icon: Icon(Icons.add),
                  label: Text('Yeni Öğün Ekle'),
                ),
              ),
              SizedBox(height: 30),
              _buildTotalCalories(),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveMealsToFirebase,
                  child: Text('Öğünleri Kaydet', style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tarih',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('dd.MM.yyyy').format(selectedDate),
                  style: TextStyle(fontSize: 16),
                ),
                Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildMealsList() {
    return editableMeals.asMap().map((index, meal) {
      return MapEntry(
        index,
        _buildMealCard(meal, index),
      );
    }).values.toList();
  }

  Widget _buildMealCard(_EditableMeal meal, int mealIndex) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: meal.mealName,
                    decoration: InputDecoration(labelText: 'Öğün Adı'),
                    validator: (value) => value!.isEmpty ? 'Öğün adı gerekli' : null,
                    onChanged: (value) => setState(() {
                      editableMeals[mealIndex].mealName = value;
                    }),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeMeal(mealIndex),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Besinler',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            ...meal.foods.asMap().map((foodIndex, food) {
              return MapEntry(
                foodIndex,
                _buildFoodRow(food, mealIndex, foodIndex),
              );
            }).values.toList(),
            SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: () => _addFood(mealIndex),
              icon: Icon(Icons.add, size: 16),
              label: Text('Besin Ekle'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            Divider(height: 20),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Toplam Kalori: ${_calculateMealCalories(meal)} kcal',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodRow(_EditableFood food, int mealIndex, int foodIndex) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              initialValue: food.foodName,
              decoration: InputDecoration(labelText: 'Besin Adı'),
              onChanged: (value) => setState(() {
                editableMeals[mealIndex].foods[foodIndex].foodName = value;
              }),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: TextFormField(
              initialValue: food.portion,
              decoration: InputDecoration(labelText: 'Porsiyon'),
              onChanged: (value) => setState(() {
                editableMeals[mealIndex].foods[foodIndex].portion = value;
              }),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: TextFormField(
              initialValue: food.calories > 0 ? food.calories.toString() : '',
              decoration: InputDecoration(labelText: 'Kalori'),
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {
                editableMeals[mealIndex].foods[foodIndex].calories = int.tryParse(value) ?? 0;
              }),
            ),
          ),
          IconButton(
            icon: Icon(Icons.remove_circle, color: Colors.red, size: 20),
            onPressed: () => _removeFood(mealIndex, foodIndex),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCalories() {
    int totalCalories = editableMeals.fold(0,
            (sum, meal) => sum + _calculateMealCalories(meal)
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          Text(
            'Günlük Toplam Kalori',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '$totalCalories kcal',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _addMeal() {
    setState(() {
      editableMeals.add(_EditableMeal(
          mealName: "",
          foods: [_EditableFood(foodName: "", portion: "", calories: 0)]
      ));
    });
  }

  void _removeMeal(int index) {
    if (editableMeals.length > 1) {
      setState(() {
        editableMeals.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('En az bir öğün bulunmalıdır')),
      );
    }
  }

  void _addFood(int mealIndex) {
    setState(() {
      editableMeals[mealIndex].foods.add(_EditableFood(
          foodName: "",
          portion: "",
          calories: 0
      ));
    });
  }

  void _removeFood(int mealIndex, int foodIndex) {
    if (editableMeals[mealIndex].foods.length > 1) {
      setState(() {
        editableMeals[mealIndex].foods.removeAt(foodIndex);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Her öğünde en az bir besin bulunmalıdır')),
      );
    }
  }

  int _calculateMealCalories(_EditableMeal meal) {
    return meal.foods.fold(0, (sum, food) => sum + food.calories);
  }

  // WeeklyMealModel'e dönüştür ve Firebase'e kaydet
  void _saveMealsToFirebase() {
    if (_formKey.currentState!.validate()) {
      try {
        // Toplam kaloriyi hesapla
        int totalCaloriesConsumed = editableMeals.fold(0,
                (sum, meal) => sum + _calculateMealCalories(meal)
        );

        // Düzenlenebilir formdan Model sınıfına dönüştür
        List<WeeklyMeal> finalMeals = editableMeals.map((editableMeal) {
          List<Food> foods = editableMeal.foods.map((editableFood) {
            return Food(
                foodName: editableFood.foodName,
                portion: editableFood.portion,
                calories: editableFood.calories
            );
          }).toList();

          return WeeklyMeal(
              mealName: editableMeal.mealName,
              foods: foods,
              totalCalories: _calculateMealCalories(editableMeal)
          );
        }).toList();

        // Final modelini oluştur
        WeeklyMealModel weeklyMealModel = WeeklyMealModel(
            date: selectedDate,
            meals: finalMeals,
            totalCaloriesConsumed: totalCaloriesConsumed
        );
        print(weeklyMealModel.toJson());
        // Firebase Realtime Database'e veri kaydetme
        databaseRef
            .child('customer')
            .child(customerID)
            .child('weeklyMeals')
            .push()
            .set(weeklyMealModel.toJson())
            .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Öğünler başarıyla kaydedildi!'))
          );
        })
            .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Hata: $error'))
          );
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bir hata oluştu: $e'))
        );
      }
    }
  }
}

// Form düzenleme için yardımcı sınıflar
class _EditableMeal {
  String mealName;
  List<_EditableFood> foods;

  _EditableMeal({required this.mealName, required this.foods});
}

class _EditableFood {
  String foodName;
  String portion;
  int calories;

  _EditableFood({required this.foodName, required this.portion, required this.calories});
}