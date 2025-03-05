import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../Models/CustomerModel.dart';

class AddProgressTrackingScreen extends StatefulWidget {
  final Customer customer;

  const AddProgressTrackingScreen({super.key, required this.customer});

  @override
  _AddProgressTrackingScreenState createState() => _AddProgressTrackingScreenState();
}

class _AddProgressTrackingScreenState extends State<AddProgressTrackingScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("customer");

  final TextEditingController weightController = TextEditingController();
  final TextEditingController bodyFatController = TextEditingController();
  final TextEditingController muscleMassController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  void _saveProgress() async {
    // Tarih formatı
    final date = DateTime.now().toIso8601String().split('T')[0];

    // Yeni progress objesi
    final newProgress = {
      "date": date,
      "weight": double.parse(weightController.text),
      "bodyFatPercentage": double.parse(bodyFatController.text),
      "muscleMass": double.parse(muscleMassController.text),
      "notes": notesController.text,
    };

    try {
      final progressRef = _dbRef.child(
          "${widget.customer.customerID}/progressTracking");

      // Aynı gün kontrolü
      final existingData = await progressRef
          .orderByChild('date')
          .equalTo(date)
          .once();

      if (existingData.snapshot.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Bugün zaten bir kayıt eklediniz!")),
        );
        return;
      }

      // Push ile yeni unique ID oluştur
      await progressRef.push().set(newProgress);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Başarıyla eklendi!")),
        );
        Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Hata: $error")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("İlerleme Ekle")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: weightController,
              decoration: const InputDecoration(labelText: "Kilo (kg)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: bodyFatController,
              decoration: const InputDecoration(labelText: "Vücut Yağ Oranı (%)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: muscleMassController,
              decoration: const InputDecoration(labelText: "Kas Kütlesi (kg)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: "Notlar"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProgress,
              child: const Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }
}