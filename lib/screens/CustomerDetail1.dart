import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'CustomerDetail2.dart';
import '../Models/CustomerModel.dart';
import 'package:firebase_database/firebase_database.dart';

class CustomerDetailMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CustomerDetailCustomerScreen(),
    );
  }
}

class CustomerDetailCustomerScreen extends StatefulWidget {
  @override
  _CustomerDetailCustomerScreenState createState() => _CustomerDetailCustomerScreenState();
}

class _CustomerDetailCustomerScreenState extends State<CustomerDetailCustomerScreen> {
  List<dynamic> customers = [];
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('customer');

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    try {
      // 1. Firebase referansını oluştur
      final DatabaseReference ref = FirebaseDatabase.instance.ref("customers");

      // 2. Verileri çek
      final DatabaseEvent event = await ref.once();
      final DataSnapshot snapshot = event.snapshot;

      // 3. Veri kontrolü
      if (snapshot.exists) {
        // 4. Veriyi işle
        final Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;

        if (data != null) {
          // 5. Müşteri listesine dönüştür
          final List<Map<String, dynamic>> customers = data.entries.map((entry) {
            return {
              'id': entry.key,
              ...Map<String, dynamic>.from(entry.value as Map)
            };
          }).toList();

          // 6. State'i güncelle (mounted kontrolü ekledik)
          if (mounted) {
            setState(() {
              this.customers = customers;
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
        title: Text('Müşteri Takip Arayüzü', style: TextStyle(fontSize: 24)),
        centerTitle: true,
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _databaseRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Hata oluştu: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return Center(child: Text('Müşteri bulunamadı.'));
          }

          final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          final customerList = data.values.toList();

          return ListView.builder(
            itemCount: customerList.length,
            itemBuilder: (context, index) {
              final customerData = customerList[index] as Map<dynamic, dynamic>;
              final customer = Customer.fromJson(customerData);

              return Card(
                child: ListTile(
                  title: Text('${customer.firstName} ${customer.lastName}'),
                  subtitle: Text('ID: ${customer.customerID}'),
                  onTap: () {
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
          );
        },
      ),
    );
  }
}