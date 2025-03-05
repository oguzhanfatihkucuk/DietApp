import 'package:flutter/material.dart';
import '../Models/DietitianModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'DietitianDetail2.dart';

class DietitianListScreen extends StatefulWidget {
  @override
  _DietitianListScreenState createState() => _DietitianListScreenState();
}

class _DietitianListScreenState extends State<DietitianListScreen> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref('customer');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diyetisyen Listesi', style: TextStyle(fontSize: 24)),
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
            return Center(child: Text('Veri bulunamadı.'));
          }

          final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          final customerList = data.values.where((customerData) {
            final customerMap = customerData as Map<dynamic, dynamic>;
            return customerMap['isAdmin'] == false &&
                customerMap['isDietitian'] == true;
          }).toList();

          if (customerList.isEmpty) {
            return Center(child: Text('Listelenecek diyetisyen bulunamadı'));
          }

          return ListView.builder(
            itemCount: customerList.length,
            itemBuilder: (context, index) {
              final customerData = customerList[index] as Map<dynamic, dynamic>;
              final dietitian = Dietitian.fromJson(customerData);

              return Card(
                child: ListTile(
                  title: Text('${dietitian.firstName} ${dietitian.lastName}'),
                  subtitle: Text('ID: ${dietitian.uid}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DietitianDetailScreen( dietitian: dietitian),
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