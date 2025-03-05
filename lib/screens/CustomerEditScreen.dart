import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Models/CustomerModel.dart';

class CustomerEditScreen extends StatefulWidget {
  final Customer customer;

  const CustomerEditScreen({Key? key, required this.customer}) : super(key: key);

  @override
  _CustomerEditScreenState createState() => _CustomerEditScreenState();
}

class _CustomerEditScreenState extends State<CustomerEditScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _targetWeightController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing customer data
    _firstNameController = TextEditingController(text: widget.customer.firstName);
    _lastNameController = TextEditingController(text: widget.customer.lastName);
    _emailController = TextEditingController(text: widget.customer.email);
    _phoneController = TextEditingController(text: widget.customer.phone);
    _ageController = TextEditingController(text: widget.customer.age.toString());
    _heightController = TextEditingController(text: widget.customer.height.toString());
    _weightController = TextEditingController(text: widget.customer.weight.toString());
    _targetWeightController = TextEditingController(text: widget.customer.targetWeight.toString());
  }

  Future<void> _updateCustomerData() async {
    // Form validasyonu
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Firebase'e gönderilecek veri haritası
      Map<String, dynamic> updatedData = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'age': int.parse(_ageController.text),
        'height': double.parse(_heightController.text),
        'weight': double.parse(_weightController.text),
        'targetWeight': double.parse(_targetWeightController.text),

        // Diğer mevcut alanları koruyun
        'customerID': widget.customer.customerID,
        'dietitianID': widget.customer.dietitianID,
        'isAdmin': widget.customer.isAdmin,
        'isDietitian': widget.customer.isDietitian,
        'gender': widget.customer.gender,
        'isLoginBefore': widget.customer.isLoginBefore,
        'activityLevel': widget.customer.activityLevel,
        'bodyMassIndex': widget.customer.bodyMassIndex,
      };

      // Karmaşık alt nesnelerin de korunması
      if (widget.customer.healthStatus != null) {
        updatedData['healthStatus'] = widget.customer.healthStatus.toJson();
      }

      if (widget.customer.dietaryHabits != null) {
        updatedData['dietaryHabits'] = widget.customer.dietaryHabits.toJson();
      }

      if (widget.customer.waterConsumption != null) {
        updatedData['waterConsumption'] = widget.customer.waterConsumption.toJson();
      }

      if (widget.customer.goals != null) {
        updatedData['goals'] = widget.customer.goals.toJson();
      }

      // Diet planları ve diğer liste bazlı alanların korunması
      if (widget.customer.dietPlans.isNotEmpty) {
        updatedData['dietPlans'] = {
          for (var i = 0; i < widget.customer.dietPlans.length; i++)
            i.toString(): widget.customer.dietPlans[i].toJson()
        };
      }

      if (widget.customer.progressTracking.isNotEmpty) {
        updatedData['progressTracking'] = widget.customer.progressTracking
            .map((tracking) => tracking.toJson())
            .toList();
      }

      if (widget.customer.weeklyMeals.isNotEmpty) {
        updatedData['weeklyMeals'] = {
          for (var i = 0; i < widget.customer.weeklyMeals.length; i++)
            i.toString(): widget.customer.weeklyMeals[i].toJson()
        };
      }

      // Update in Firebase
      final DatabaseReference customerRef =
      FirebaseDatabase.instance.ref('customer/${widget.customer.customerID}');

      await customerRef.set(updatedData);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Müşteri bilgileri güncellendi'), backgroundColor: Colors.green),
      );

      // Pop back to previous screen with success flag
      Navigator.pop(context, true);

    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Güncelleme sırasında hata oluştu: $e'), backgroundColor: Colors.red),
      );
      print('Güncelleme hatası: $e');
    }
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.customer.firstName} ${widget.customer.lastName} - Düzenle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'Ad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ad alanı boş bırakılamaz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Soyad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Soyad alanı boş bırakılamaz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email boş bırakılamaz';
                  }
                  // Basit email validasyonu
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Geçerli bir email adresi girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Telefon'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Yaş'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Yaş boş bırakılamaz';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Geçerli bir yaş girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Boy (cm)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Boy boş bırakılamaz';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Geçerli bir boy girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Kilo (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kilo boş bırakılamaz';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Geçerli bir kilo girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _targetWeightController,
                decoration: InputDecoration(labelText: 'Hedef Kilo (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Hedef kilo boş bırakılamaz';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Geçerli bir hedef kilo girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateCustomerData,
                child: Text('Güncelle'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}