import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Models/DietPlanModel.dart';

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