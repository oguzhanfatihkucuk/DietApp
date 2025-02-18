import 'package:flutter/material.dart';
import '../Components/customButton.dart';
import 'Registration.dart';
import 'CustomerDetail1.dart';
import 'AddDietPlan.dart';
import 'AddProgressTracking.dart';

class Mainscreen extends StatefulWidget {
  @override
  _MainscreenState createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  // Başlangıçta hangi sayfanın gösterileceğini belirliyoruz
  Widget currentPage = Center(child: Text('Ana Ekran', style: TextStyle(fontSize: 24)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ana Ekran'),
      ),
      body: Row(
        children: [
          // Sol tarafta sabit kalan menü
          Container(
            width: 250,
            color: Colors.blueGrey, // Menü için arka plan rengi
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  text: 'Müşteri Kayıt',
                  onPressed: () {
                    setState(() {
                      currentPage = Registration();
                    });
                  },
                ),
                CustomButton(
                  text: 'Müşteri İzleme',
                  onPressed: () {
                    setState(() {
                      currentPage = CustomerDetail1();
                    });
                  },
                ),
                CustomButton(
                  text: 'Diyet Planı Ekleme',
                  onPressed: () {
                    setState(() {
                      currentPage = AddDietPlan();
                    });
                  },
                ),
                CustomButton(
                  text: 'İlerleme Süreci Ekleme',
                  onPressed: () {
                    setState(() {
                      currentPage = AddProgressTracking();
                    });
                  },
                ),
              ],
            ),
          ),
          // Sağ tarafta içerik
          Expanded(
            child: currentPage,
          ),
        ],
      ),
    );
  }
}
