import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  User? _user;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    // Giriş yapmış kullanıcıyı al
    _user = _auth.currentUser;

    if (_user == null) {
      print("Kullanıcı giriş yapmamış!");
      return;
    }

    try {
      // Realtime Database'den kullanıcı verilerini çek
      DataSnapshot userSnapshot = await _database.child('customer/${_user!.uid}').get();

      if (userSnapshot.exists) {
        final data = userSnapshot.value as Map<Object?, Object?>;
        final userData = data.cast<String, dynamic>();
        setState(() {
          _userData = userData;
        });
        //print("Kullanıcı verileri: $_userData");
      } else {
        print("Kullanıcı verisi bulunamadı!");
      }
    } catch (e) {
      print("Veri çekme hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcı Profili'),
      ),
      body: _userData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ad: ${_userData!['firstName']} ${_userData!['lastName']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('E-posta: ${_userData!['email']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Yaş: ${_userData!['age']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Cinsiyet: ${_userData!['gender']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Telefon: ${_userData!['phone']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Hedef Kilo: ${_userData!['targetWeight']} kg', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Mevcut Kilo: ${_userData!['weight']} kg', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}