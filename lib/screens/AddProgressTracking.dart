import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Models/CustomerModel.dart';
import 'AddProgressTracking2.dart';

class AddProgressTrackingMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AddProgressTrackingCustomerScreen(),
    );
  }
}

class AddProgressTrackingCustomerScreen extends StatefulWidget {
  @override
  _AddProgressTrackingCustomerScreenState createState() => _AddProgressTrackingCustomerScreenState();
}

class _AddProgressTrackingCustomerScreenState extends State<AddProgressTrackingCustomerScreen> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('customer');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İlerleme Ekle', style: TextStyle(fontSize: 24)),
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

          // Filtreleme ekliyoruz
          final customerList = data.values.where((customerData) {
            // isAdmin alanı yoksa veya false ise listeye al
            return (customerData as Map)['isAdmin'] == false;
          }).toList();

          if (customerList.isEmpty) {
            return Center(child: Text('Gösterilecek müşteri bulunamadı'));
          }

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
                        builder: (context) => AddProgressTrackingScreen(customer: customer),
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