import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'AddDietPlan2.dart';

class AddDietPlanMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AddDietPlan(),
    );
  }
}

class AddDietPlan extends StatefulWidget {
  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<AddDietPlan> {
  List<String> customerIds = [];
  DatabaseReference dbRef = FirebaseDatabase.instance.ref("customer");

  void _fetchCustomers() async {
    DatabaseEvent event = await dbRef.once();
    if (event.snapshot.value != null) {
      Map<dynamic, dynamic> customersMap =
          Map<dynamic, dynamic>.from(event.snapshot.value as Map);

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
          ? Center(
              child: CircularProgressIndicator()) // Veri yüklenene kadar göster
          : ListView.builder(
              itemCount: customerIds.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Müşteri ID: ${customerIds[index]}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AddDietPlanScreen(customerIds[index]),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
