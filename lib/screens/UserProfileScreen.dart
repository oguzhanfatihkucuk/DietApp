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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: _user == null
          ? const Center(child: Text('Lütfen giriş yapın', style: TextStyle(fontSize: 18, color: Colors.black)))
          : StreamBuilder<DatabaseEvent>(
        stream: _database.child('customer/${_user!.uid}').onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}', style: TextStyle(color: Colors.red)));
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
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/images/indir.jpeg'),
                // Eğer görüntü yüklenemezse simge gösterilecek
                child: Container(), // Boş bir container kullanarak simgenin görünmesini engelliyoruz
              ),
              const SizedBox(height: 16),
              Text(
                '${data['firstName']} ${data['lastName']}',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                data['email'] ?? '-',
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildInfoCard('Yaş', data['age']?.toString() ?? 'Belirtilmemiş', Icons.calendar_today),
        _buildInfoCard('Cinsiyet', data['gender'] ?? 'Belirtilmemiş', Icons.people),
        _buildInfoCard('Telefon', data['phone'] ?? '-', Icons.phone),
        _buildInfoCard('Hedef Kilo', '${data['targetWeight']} kg', Icons.fitness_center),
        _buildInfoCard('Mevcut Kilo', '${data['weight']} kg', Icons.monitor_weight),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.blueAccent),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
