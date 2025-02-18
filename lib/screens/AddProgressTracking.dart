import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'CustomerDetail2.dart';



class AddProgressTracking extends StatefulWidget {
  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}


class _CustomerListScreenState extends State<AddProgressTracking> {
  List<dynamic> customers = [];
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('customers');

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  // Firebase'den müşteri verilerini çekme
  Future<void> _fetchCustomers() async {
    try {
      final DatabaseEvent event = await _databaseRef.once();
      final DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        final Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>;

        if (data != null) {
          final List<Map<String, dynamic>> customersList = data.entries.map((entry) {
            return {
              'id': entry.key,
              ...Map<String, dynamic>.from(entry.value as Map),
            };
          }).toList();

          // State güncelleme
          if (mounted) {
            setState(() {
              customers = customersList;
            });
          }
        }
      } else {
        print("📭 Veritabanında müşteri bulunamadı");
      }
    } on FirebaseException catch (e) {
      print("🔥 Firebase Hatası: ${e.code} - ${e.message}");
    } catch (e) {
      print("⚠️ Genel Hata: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Müşteriler'),
      ),
      body: customers.isEmpty
          ? Center(child: CircularProgressIndicator()) // Veriler yüklenene kadar göster
          : ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];

          return Card(
            child: ListTile(
              title: Text('${customer['firstName']} ${customer['lastName']}'),
              subtitle: Text('ID: ${customer['id']}'),
              onTap: () {
                // Müşteri detay sayfasına yönlendirme
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomerDetailScreen(customer: customer),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}


