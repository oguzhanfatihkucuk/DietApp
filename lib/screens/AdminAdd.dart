import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Models/AdminModel.dart';

class AdminRegistrationScreen extends StatefulWidget {
  @override
  _AdminRegistrationScreenState createState() => _AdminRegistrationScreenState();
}

class _AdminRegistrationScreenState extends State<AdminRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Form kontrolleri
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  final bool _isAdmin = true;
  final bool _isDietitian = true;

  Future<void> _registerAdmin() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Önce Firebase Authentication ile kullanıcı oluştur
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Kullanıcı oluşturulduktan sonra admin bilgilerini kaydet
        Admin newAdmin = Admin(
          uid: userCredential.user!.uid,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          isAdmin: _isAdmin,
          isDietitian: _isDietitian,
        );

        // Realtime Database'e kaydet
        await _database.child('customer').child(newAdmin.uid).set(newAdmin.toJson());

        // Başarılı kayıt sonrası işlemler
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Admin başarıyla kaydedildi!')),
        );

        // Gerekirse başka bir sayfaya yönlendirme yapabilirsiniz
        // Navigator.of(context).pushReplacement(...);

      } on FirebaseAuthException catch (e) {
        // Hata yönetimi
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: ${e.message}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bir hata oluştu: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Kayıt Formu'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-posta'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'E-posta boş bırakılamaz';
                  }
                  if (!value.contains('@')) {
                    return 'Geçerli bir e-posta adresi girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Şifre'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Şifre boş bırakılamaz';
                  }
                  if (value.length < 6) {
                    return 'Şifre en az 6 karakter olmalı';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'Ad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ad boş bırakılamaz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Soyad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Soyad boş bırakılamaz';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerAdmin,
                child: Text('Admin Kaydını Tamamla'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

