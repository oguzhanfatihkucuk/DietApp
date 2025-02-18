import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import '../Models/DietPlanModel.dart';

class AddDietPlanMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AddDietPlan(),
    );
  }
}

class AddDietPlan extends StatefulWidget {
  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<AddDietPlan> {
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
  final TextEditingController _calorieTargetController = TextEditingController();
  final TextEditingController _proteinTargetController = TextEditingController();
  final TextEditingController _fatTargetController = TextEditingController();
  final TextEditingController _carbTargetController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 7));

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
        dailyCalorieTarget: int.tryParse(_calorieTargetController.text) ?? 0,
        dailyProteinTarget: int.tryParse(_proteinTargetController.text) ?? 0,
        dailyFatTarget: int.tryParse(_fatTargetController.text) ?? 0,
        dailyCarbohydrateTarget: int.tryParse(_carbTargetController.text) ?? 0,
        meals: _meals,
      );
      _saveToFirebase(newPlan);
    }
  }

  void _saveToFirebase(DietPlanModel plan) async {
    try {
      // Firebase reference'ı oluştur
      DatabaseReference dietPlansRef = FirebaseDatabase.instance.ref("customer/${widget.customerId}/dietPlans").push();

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
              TextFormField(
                controller: _calorieTargetController,
                decoration: InputDecoration(labelText: "Hedef Kalori Miktarı"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen hedef kalori miktarını giriniz";
                  }
                  if (int.tryParse(value) == null) {
                    return "Lütfen geçerli bir kalori değeri giriniz";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _proteinTargetController,
                decoration: InputDecoration(labelText: "Hedef Protein Miktarı"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen hedef protein miktarını giriniz";
                  }
                  if (int.tryParse(value) == null) {
                    return "Lütfen geçerli bir protein değeri giriniz";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fatTargetController,
                decoration: InputDecoration(labelText: "Hedef Yağ Miktarı"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen hedef yağ miktarını giriniz";
                  }
                  if (int.tryParse(value) == null) {
                    return "Lütfen geçerli bir yağ değeri giriniz";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _carbTargetController,
                decoration: InputDecoration(labelText: "Hedef Karbonhidrat Miktarı"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen hedef karbonhidrat miktarını giriniz";
                  }
                  if (int.tryParse(value) == null) {
                    return "Lütfen geçerli bir karbonhidrat değeri giriniz";
                  }
                  return null;
                },
              ),
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
              // Öğünleri listeleme alanı
              Column(
                children: _meals.map((meal) => ListTile(
                  title: Text(meal.mealName),
                  subtitle: Text("Kalori: ${meal.calories}, Besinler: ${meal.foods.join(', ')}"),
                )).toList(),
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