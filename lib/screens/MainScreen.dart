import 'package:flutter/material.dart';
import 'AddProgressTracking.dart';
import 'Registration.dart';
import 'CustomerDetail1.dart';
import 'AddDietPlan.dart';
import 'UserProfileScreen.dart';

//TODO Tüm sayfalardaki firebase işlemlerini gözden geçir riskleri değerlendir tüm save methodlarını aynı biçimde olmasını sağla.
//TODO UI için geliştirmelerde bulun.
//TODO Diyetisyen girişi sağlansın ve diyetisyen kendi müşterilerini görebilsin.

//TODO Müşteri silme-diyet planı silme-ilerleme süreci silme bunları yapmaya calis.
//TODO Düzenleme işlemlerini araştır.
//TODO Müşteri için öğün ekleme sayfası olusturalacak

//TODO Authorization işlemlerini araştır nasıl bir yöntem yapabiliriz.Diyetisyen
//TODO Admin:hepsi+diyetisyen konrol sayfası
//TODO Diyetisyen:Tüm sayfalar
//TODO Müşteri:Öğün ekle

//TODO Responsive kontrollerini  yap
class Mainscreen extends StatefulWidget {
  Mainscreen(bool isAdmin, bool isDietitian);

  @override
  _MainscreenState createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  Widget currentPage = Center(child: Text('Ana Ekran', style: TextStyle(fontSize: 24)));
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ana Ekran'),
        backgroundColor: Colors.blueGrey,
      ),
      drawer: Drawer(
        child: ListView( // Column yerine ListView kullan
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey.shade900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Title', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text('subtext', style: TextStyle(fontSize: 14, color: Colors.white70)),
                ],
              ),
            ),
            _buildDrawerItem(Icons.home, 'Ana Ekran', 0, Center(child: Text('Ana Ekran'))),
            _buildDrawerItem(Icons.person_add, 'Müşteri Kayıt', 1, RegistrationMain()),
            _buildDrawerItem(Icons.people, 'Müşteri İzleme', 2, CustomerDetailMain()),
            _buildDrawerItem(Icons.restaurant, 'Diyet Planı Ekleme', 3, AddDietPlanMain()),
            _buildDrawerItem(Icons.track_changes, 'İlerleme Süreci Ekleme', 4, AddProgressTrackingMain()),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Labels', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
              ),
            ),
            _buildDrawerItem(Icons.settings, 'My Profile', 8, UserProfileScreen()),
            _buildDrawerItem(Icons.settings, 'Settings & Account', 8, Center(child: Text('Settings & Account'))),
          ],
        ),
      ),

      body: currentPage,
    );
  }

  Widget _buildDrawerItem(IconData icon, String text, int index, Widget page) {
    return ListTile(
      leading: Icon(icon, color: selectedIndex == index ? Colors.blueGrey : Colors.black54),
      title: Text(text, style: TextStyle(color: selectedIndex == index ? Colors.blueGrey : Colors.black)),
      tileColor: selectedIndex == index ? Colors.blueGrey.shade100 : null,
      onTap: () {
        setState(() {
          selectedIndex = index;
          currentPage = page;
        });
        Navigator.pop(context);
      },
    );
  }
}