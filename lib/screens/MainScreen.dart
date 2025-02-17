import 'package:flutter/material.dart';
import '../Components/customButton.dart';
import 'Registration.dart';
import 'CustomerDetail1.dart';
import 'AddDietPlan.dart';
import 'AddProgressTracking.dart';

class Mainscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ana Ekran'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'Müşteri Kayıt',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Registration()),
                );
              },
            ),
            CustomButton(
              text: 'Müşteri İzleme',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerDetail1()),
                );
              },
            ),
            CustomButton(
              text: 'Diyet Planı Ekleme',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddDietPlan()),
                );
              },
            ),
            CustomButton(
              text: 'İlerleme Süreci Ekleme',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddProgressTracking()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}