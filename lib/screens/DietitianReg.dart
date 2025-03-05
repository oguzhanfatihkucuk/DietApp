import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DietitianService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  // Kullanıcı kayıt metodu
  Future<String?> registerUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;
      print('Kullanıcı kaydı başarılı. UID: $uid');
      return uid;
    } catch (e) {
      print('Kullanıcı kaydı hatası: $e');
      return null;
    }
  }

  Future<void> registerDietitian({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phone,
    required int age,
    required String gender,
    bool isAdmin = false,
    bool isDietitian = true,
  }) async {
    try {
      // Önce kullanıcıyı kaydet
      String? uid = await registerUser(email, password);

      if (uid == null) {
        throw Exception('Kullanıcı kaydı başarısız');
      }

      // Kullanıcının UID'sini doğrudan path olarak kullan
      DatabaseReference dietitianRef = _databaseRef.child('customer').child(uid);
      await dietitianRef.set({
        'uid': uid,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'age': age,
        'gender': gender,
        'isAdmin': isAdmin,
        'isDietitian': isDietitian,
        'createdAt': DateTime.now().toIso8601String(),
      });

      print('Diyetisyen başarıyla kaydedildi. UID: $uid');
    } catch (e) {
      print('Diyetisyen kayıt hatası: $e');
      rethrow;
    }
  }
}

class DietitianRegistrationForm extends StatefulWidget {
  @override
  _DietitianRegistrationFormState createState() => _DietitianRegistrationFormState();
}

class _DietitianRegistrationFormState extends State<DietitianRegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final DietitianService _dietitianService = DietitianService();

  // Text Controller'ları
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  // Cinsiyet ve diğer boolean değerler için seçenekler
  String _selectedGender = 'Erkek';
  bool _isAdmin = false;
  bool _isDietitian = true;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _dietitianService.registerDietitian(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          phone: _phoneController.text,
          age: int.parse(_ageController.text),
          gender: _selectedGender,
          isAdmin: _isAdmin,
          isDietitian: _isDietitian,
        );

        // Başarılı kayıt sonrası bilgilendirme
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Diyetisyen başarıyla kaydedildi!')),
        );

        // Form alanlarını temizle
        _formKey.currentState!.reset();
      } catch (e) {
        // Hata durumunda bilgilendirme
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kayıt sırasında hata oluştu: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diyetisyen Kayıt Formu'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Ad
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'Ad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ad gereklidir';
                  }
                  return null;
                },
              ),

              // Soyad
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Soyad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Soyad gereklidir';
                  }
                  return null;
                },
              ),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email gereklidir';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Geçerli bir email adresi girin';
                  }
                  return null;
                },
              ),

              // Şifre
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Şifre'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Şifre gereklidir';
                  }
                  if (value.length < 6) {
                    return 'Şifre en az 6 karakter olmalıdır';
                  }
                  return null;
                },
              ),

              // Telefon
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Telefon'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Telefon numarası gereklidir';
                  }
                  return null;
                },
              ),

              // Yaş
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Yaş'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Yaş gereklidir';
                  }
                  return null;
                },
              ),

              // Cinsiyet Dropdown
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(labelText: 'Cinsiyet'),
                items: ['Erkek', 'Kadın', 'Diğer']
                    .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
              ),

              // Admin Mi Checkbox
              CheckboxListTile(
                title: Text('Admin Mi?'),
                value: _isAdmin,
                onChanged: (bool? value) {
                  setState(() {
                    _isAdmin = value!;
                  });
                },
              ),

              // Kaydet Butonu
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Controller'ları temizle
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}