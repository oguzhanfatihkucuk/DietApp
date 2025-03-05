import 'package:diet/screens/SettingsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddProgressTracking.dart';
import 'CustomerMealAdd.dart';
import 'DietitianDetail1.dart';
import 'DietitianReg.dart';
import 'Registration.dart';
import 'CustomerDetail1.dart';
import 'AddDietPlan.dart';
import 'UserProfileScreen.dart';
import 'loginScreen.dart';

//TODO Tüm sayfalardaki firebase işlemlerini gözden geçir riskleri değerlendir tüm save methodlarını aynı biçimde olmasını sağla.

//TODO UI için geliştirmelerde bulun.Responsive kontrollerini  yap
//TODO Diyetisyen girişi sağlansın ve diyetisyen kendi müşterilerini görebilsin.

//TODO Admin sayfasında diyetisyeni kayıtı ve admin kayıdı yapılabilsin.isADmin?, isDietitan?
//TODO diyetisyen sadece müşteri kayıdı yapabilir,kayıt yaptığında o kişi otomatik olarak o dietitanID ye sahip olsun

//TODO Müşteri silme-diyet planı silme-ilerleme süreci silme bunları yapmaya calis.
//TODO Düzenleme işlemlerini araştır.

//TODO Diyetisyen kayıdı icin farklı bir ekran ve model yap
//TODO Admin kayıdı icin farklı bir ekran ve modelyap


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

  Future<void> _logout(BuildContext context) async {
    try {
      // Firebase'den çıkış yap
      await FirebaseAuth.instance.signOut();

      // SharedPreferences'ten kullanıcı verilerini temizle
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('user_id');
        await prefs.remove('is_admin');
        await prefs.remove('is_dietitian');
        await prefs.remove('is_logged_in');
        print("SharedPreferences verileri temizlendi");
      } catch (e) {
        print("SharedPreferences temizleme hatası: $e");
      }

      // Giriş ekranına yönlendir
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false, // Tüm sayfaları stack'ten kaldırır
      );
    } catch (e) {
      print("Çıkış hatası: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Çıkış yapılırken hata oluştu")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
        title: const Text('Ana Ekran'),
        backgroundColor: Colors.blueGrey,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blueGrey),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Title', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text('subtext', style: TextStyle(fontSize: 14, color: Colors.white70)),
                ],
              ),
            ),
            // Admin ve Diyetisyenler için menü öğeleri
            if (isAdmin && isDietitian) ...[
              _buildDrawerItem(Icons.home, 'Ana Ekran', 0, const Center(child: Text('Ana Ekran'))),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Diyetisyen İslemleri', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
                ),
              ),
              _buildDrawerItem(Icons.person_add, 'Diyetisyen Kayıt', 10, DietitianRegistrationForm()),
              _buildDrawerItem(Icons.food_bank, 'Diyetisyen İzle', 9, DietitianListScreen()),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Müsteri İslemleri', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
                ),
              ),
              _buildDrawerItem(Icons.person_add, 'Müşteri Kayıt', 1, RegistrationMain()),
              _buildDrawerItem(Icons.people, 'Müşteri İzleme', 2, CustomerDetailMain()),
              _buildDrawerItem(Icons.restaurant, 'Diyet Planı Ekleme', 3, AddDietPlanMain()),
              _buildDrawerItem(Icons.track_changes, 'İlerleme Süreci Ekleme', 4, AddProgressTrackingMain()),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Ayarlar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
                ),
              ),
              _buildDrawerItem(Icons.food_bank, 'Ayarlar', 6, SettingsPage())
            ],
            if (!isAdmin && isDietitian) ...[
              _buildDrawerItem(Icons.home, 'Ana Ekran', 0, const Center(child: Text('Ana Ekran'))),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Müsteri İslemleri', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
                ),
              ),
              _buildDrawerItem(Icons.person_add, 'Müşteri Kayıt', 1, RegistrationMain()),
              _buildDrawerItem(Icons.people, 'Müşteri İzleme', 2, CustomerDetailMain()),
              _buildDrawerItem(Icons.restaurant, 'Diyet Planı Ekleme', 3, AddDietPlanMain()),
              _buildDrawerItem(Icons.track_changes, 'İlerleme Süreci Ekleme', 4, AddProgressTrackingMain()),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Ayarlar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
                ),
              ),
              //_buildDrawerItem(Icons.food_bank, 'Diyetisyen İzle', 9, DietitianListScreen()),
              _buildDrawerItem(Icons.food_bank, 'Ayarlar', 6, SettingsPage())
            ],
            // Tüm kullanıcılar için profil sayfası (Admin ve Diyetisyenler hariç)
            if (!isAdmin && !isDietitian)...[
              _buildDrawerItem(Icons.person, 'Profilim', 5, UserProfileScreen()),
              _buildDrawerItem(Icons.food_bank, 'Ayarlar', 6, SettingsPage()),
              _buildDrawerItem(Icons.food_bank, 'Öğün Ekle', 8, WeeklyMealFormScreen()),
            ]
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