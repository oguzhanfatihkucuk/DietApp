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

  void _saveProgress() {
    String date = DateTime.now().toIso8601String().split('T')[0]; // "YYYY-MM-DD" formatında tarih
    Map<String, dynamic> newProgress = {
      "date": date,
      "weight": double.parse(weightController.text),
      "bodyFatPercentage": double.parse(bodyFatController.text),
      "muscleMass": double.parse(muscleMassController.text),
      "notes": notesController.text,
    };

    DatabaseReference progressRef = _dbRef.child("-Nxyz${widget.customer.customerID}/progressTracking");

    progressRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        // Mevcut listeyi al
        List<dynamic> existingData = List<Map<dynamic, dynamic>>.from(event.snapshot.value as List<dynamic>);
        existingData.add(newProgress);
        // Yeni listeyi kaydet
        progressRef.set(existingData);  //TODO set?
      } else {
        // İlk defa kayıt yapılıyorsa direkt liste olarak kaydet
        progressRef.set([newProgress]);
      }
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Başarıyla eklendi!")));
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $error")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("İlerleme Ekle - ${widget.customer.customerID}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: "Kilo (kg)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: bodyFatController,
              decoration: InputDecoration(labelText: "Vücut Yağ Oranı (%)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: muscleMassController,
              decoration: InputDecoration(labelText: "Kas Kütlesi (kg)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: notesController,
              decoration: InputDecoration(labelText: "Notlar"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProgress,
              child: Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }
}