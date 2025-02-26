import 'package:flutter/material.dart';
import 'AddProgressTracking.dart';
import 'Registration.dart';
import 'CustomerDetail1.dart';
import 'AddDietPlan.dart';
import 'UserProfileScreen.dart';

//TODO Tüm sayfalardaki firebase işlemlerini gözden geçir riskleri değerlendir tüm save methodlarını aynı biçimde olmasını sağla.

//TODO UI için geliştirmelerde bulun.
//TODO Responsive kontrollerini  yap

//TODO Diyetisyen girişi sağlansın ve diyetisyen kendi müşterilerini görebilsin.
//TODO Admin sayfasında diyetisyeni kayıtı ve admin kayıdı yapılabilsin.isADmin?, isDietitan?
//TODO diyetisyen sadece müşteri kayıdı yapabilir,kayıt yaptığında o kişi otomatik olarak o dietitanID ye sahip olsun

//TODO Müşteri silme-diyet planı silme-ilerleme süreci silme bunları yapmaya calis.
//TODO Düzenleme işlemlerini araştır.
//TODO Müşteri için öğün ekleme sayfası olusturalacak



class Mainscreen extends StatefulWidget {
  final bool isAdmin;
  final bool isDietitian;

  const Mainscreen({
    Key? key,
    required this.isAdmin,
    required this.isDietitian,
  }) : super(key: key);

  @override
  _MainscreenState createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  Widget currentPage = const Center(child: Text('Ana Ekran', style: TextStyle(fontSize: 24)));
  int selectedIndex = 0;

  bool get isAdmin => widget.isAdmin;
  bool get isDietitian => widget.isDietitian;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Ekran'),
        backgroundColor: Colors.blueGrey,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey),
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
            // Admin ve Diyetisyenler için menü öğeleri
            if (isAdmin || isDietitian) ...[
              _buildDrawerItem(Icons.home, 'Ana Ekran', 0, const Center(child: Text('Ana Ekran'))),
              _buildDrawerItem(Icons.person_add, 'Müşteri Kayıt', 1, RegistrationMain()),
              _buildDrawerItem(Icons.people, 'Müşteri İzleme', 2, CustomerDetailMain()),
              _buildDrawerItem(Icons.restaurant, 'Diyet Planı Ekleme', 3, AddDietPlanMain()),
              _buildDrawerItem(Icons.track_changes, 'İlerleme Süreci Ekleme', 4, AddProgressTrackingMain()),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Labels', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
                ),
              ),
              _buildDrawerItem(Icons.settings, 'Settings & Account', 8, const Center(child: Text('Settings & Account'))),
            ],
            // Tüm kullanıcılar için profil sayfası (Admin ve Diyetisyenler hariç)
            if (!isAdmin && !isDietitian)
              _buildDrawerItem(Icons.person, 'My Profile', 5, UserProfileScreen()),
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