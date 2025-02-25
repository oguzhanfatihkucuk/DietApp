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
    _auth.authStateChanges().listen((User? user) {
      if (user != null && mounted) {
        _user = user;
        _getUserData();
      }
    });
  }

  Future<void> _getUserData() async {
    try {
      final snapshot = await _database.child('customer/${_user!.uid}').get();
      if (!snapshot.exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Kullanıcı verisi bulunamadı'))
          );
        }
        return;
      }

      final userData = Map<String, dynamic>.from(snapshot.value as Map);
      if (mounted) {
        setState(() => _userData = userData);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Hata: ${e.toString()}'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: _user == null
          ? const Center(child: Text('Lütfen giriş yapın'))
          : StreamBuilder<DatabaseEvent>(
        stream: _database.child('customer/${_user!.uid}').onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final userData = Map<String, dynamic>.from(
              snapshot.data!.snapshot.value as Map
          );
          return _buildProfile(userData);
        },
      ),
    );
  }

  Widget _buildProfile(Map<String, dynamic> data) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildInfoRow('Ad Soyad', '${data['firstName']} ${data['lastName']}'),
        _buildInfoRow('E-posta', data['email'] ?? '-'),
        _buildInfoRow('Yaş', data['age']?.toString() ?? 'Belirtilmemiş'),
        _buildInfoRow('Cinsiyet', data['gender'] ?? 'Belirtilmemiş'),
        _buildInfoRow('Telefon', data['phone'] ?? '-'),
        const SizedBox(height: 20),
        _buildInfoRow('Hedef Kilo', '${data['targetWeight']} kg'),
        _buildInfoRow('Mevcut Kilo', '${data['weight']} kg'),
      ],
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}