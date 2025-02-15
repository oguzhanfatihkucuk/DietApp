import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(home: CustomerListScreen()));
}

class CustomerListScreen extends StatefulWidget {
  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  List<String> customerIds = [];
  DatabaseReference dbRef = FirebaseDatabase.instance.ref("customer");

  void _fetchCustomers() async {
    DatabaseEvent event = await dbRef.once();
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> customersMap = Map<dynamic, dynamic>.from(event.snapshot.value as Map);

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
          ? Center(child: CircularProgressIndicator()) // Veri yüklenene kadar göster
          : ListView.builder(
        itemCount: customerIds.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Müşteri ID: ${customerIds[index]}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProgressScreen(customerIds[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class AddProgressScreen extends StatefulWidget {
  final String customerId;
  AddProgressScreen(this.customerId);

  @override
  _AddProgressScreenState createState() => _AddProgressScreenState();
}

class _AddProgressScreenState extends State<AddProgressScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref("customers");
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

    DatabaseReference progressRef = _dbRef.child("${widget.customerId}/progressTracking");

    progressRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        // Mevcut listeyi al
        List<dynamic> existingData = List<Map<String, dynamic>>.from(event.snapshot.value as List<dynamic>);
        existingData.add(newProgress);

        // Yeni listeyi kaydet
        progressRef.set(existingData);
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
      appBar: AppBar(title: Text("İlerleme Ekle - ${widget.customerId}")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: weightController, decoration: InputDecoration(labelText: "Kilo (kg)"), keyboardType: TextInputType.number),
            TextField(controller: bodyFatController, decoration: InputDecoration(labelText: "Vücut Yağ Oranı (%)"), keyboardType: TextInputType.number),
            TextField(controller: muscleMassController, decoration: InputDecoration(labelText: "Kas Kütlesi (kg)"), keyboardType: TextInputType.number),
            TextField(controller: notesController, decoration: InputDecoration(labelText: "Notlar")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveProgress, child: Text("Kaydet")),
          ],
        ),
      ),
    );
  }
}

