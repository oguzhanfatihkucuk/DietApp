import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'Models/DietPlanModel.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(home: CustomerListScreen()));
}

class CustomerListScreen extends StatefulWidget {
  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  List<String> customerIds = [];
  DatabaseReference dbRef = FirebaseDatabase.instance.ref("customer");

  void _fetchCustomers() async {
    DatabaseEvent event = await dbRef.once();
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> customersMap =
          Map<dynamic, dynamic>.from(event.snapshot.value as Map);

      // Müşteri ID’lerini listeye çevir ve setState ile güncelle
      setState(() {
        customerIds = customersMap.keys.map((key) => key.toString()).toList();
      });

      print("Müşteri ID'leri: $customerIds");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Müşteriler")),
      body: customerIds.isEmpty
          ? Center(
              child: CircularProgressIndicator()) // Veri yüklenene kadar göster
          : ListView.builder(
              itemCount: customerIds.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Müşteri ID: ${customerIds[index]}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddDietPlanScreen(customerIds[index]),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class AddDietPlanScreen extends StatefulWidget {
  final String customerId;

  AddDietPlanScreen(this.customerId);

  @override
  _AddDietPlanScreenState createState() => _AddDietPlanScreenState();
}

class _AddDietPlanScreenState extends State<AddDietPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _planNameController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 7));
  int _calorieTarget = 2000;
  int _proteinTarget = 50;
  int _fatTarget = 30;
  int _carbTarget = 300;
  List<DietPlanMeal> _meals = [];

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _savePlan() {
    if (_formKey.currentState!.validate()) {
      // Firebase'e kaydetme işlemi burada olacak
      final newPlan = DietPlanModel(
        planID: "", // Firebase otomatik ID üretecek
        planName: _planNameController.text,
        startDate: _startDate,
        endDate: _endDate,
        dailyCalorieTarget: _calorieTarget,
        dailyProteinTarget: _proteinTarget,
        dailyFatTarget: _fatTarget,
        dailyCarbohydrateTarget: _carbTarget,
        meals: _meals,
      );

      _saveToFirebase(newPlan);
    }
  }

  // Firebase işlemi için sonraki adımda dolduracağız
  void _saveToFirebase(DietPlanModel plan) async {
    try {
      // Firebase reference'ı oluştur
      DatabaseReference dietPlansRef = FirebaseDatabase.instance.ref("customer/${widget.customerId}/dietPlans")  .push();

      // Plan ID'sini güncelle
      plan.planID = dietPlansRef.key!;

      // Modeli JSON'a çevir ve Firebase'e yaz
      await dietPlansRef.set(plan.toJson());

      // Başarılıysa kullanıcıyı bilgilendir
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Plan başarıyla kaydedildi!")),
      );

      // Ekranı kapat
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Yeni Öğün Planı Ekle")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _planNameController,
                decoration: InputDecoration(labelText: "Plan Adı"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen plan adı giriniz";
                  }
                  return null;
                },
              ),
              ListTile(
                title: Text("Başlangıç Tarihi: ${DateFormat('yyyy-MM-dd').format(_startDate)}"),
                onTap: () => _selectDate(context, true),
              ),
              ListTile(
                title: Text("Bitiş Tarihi: ${DateFormat('yyyy-MM-dd').format(_endDate)}"),
                onTap: () => _selectDate(context, false),
              ),
              // Diğer hedef alanları için benzer TextFormField'lar ekleyin
              // Öğün ekleme butonu
              ElevatedButton(
                onPressed: () async {
                  final newMeal = await Navigator.push<DietPlanMeal>(
                    context,
                    MaterialPageRoute(builder: (context) => AddMealScreen()),
                  );
                  if (newMeal != null) {
                    setState(() {
                      _meals.add(newMeal);
                    });
                  }
                },
                child: Text("Öğün Ekle"),
              ),
              ElevatedButton(
                onPressed: _savePlan,
                child: Text("Planı Kaydet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddMealScreen extends StatefulWidget {
  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  String _mealName = "";
  int _calories = 0;
  String _foodsInput = ""; // Kullanıcının girdiği besinler
  List<String> foods = []; // Besinler listesi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Yeni Öğün Ekle")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                onSaved: (value) => _mealName = value!,
                decoration: InputDecoration(labelText: "Öğün Adı"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen öğün adı giriniz";
                  }
                  return null;
                },
              ),
              TextFormField(
                onSaved: (value) => _foodsInput = value!,
                decoration: InputDecoration(labelText: "Besinler (virgülle ayırın)"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen besinleri giriniz";
                  }
                  return null;
                },
              ),
              TextFormField(
                onSaved: (value) => _calories = int.parse(value!),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Kalori"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen kalori giriniz";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Besinleri virgülle ayır ve listeye çevir
                    foods = _foodsInput.split(',').map((food) => food.trim()).toList();

                    Navigator.pop(context, DietPlanMeal(
                      mealName: _mealName,
                      foods: foods, // List<String> olarak gönder
                      calories: _calories,
                    ));
                  }
                },
                child: Text("Kaydet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}