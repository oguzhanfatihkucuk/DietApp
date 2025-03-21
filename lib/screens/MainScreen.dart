import 'package:diet/screens/GunlukIlerlemeEkrani.dart';
import 'package:diet/screens/SettingsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AddProgresTracking/AddProgressTracking.dart';
import 'AdminAdd.dart';
import 'CustomerDietPlanView.dart';
import 'CustomerMealAdd.dart';
import 'DietitianDetail/DietitianDetail1.dart';
import 'DietitianReg.dart';
import 'Registration.dart';
import 'CustomerDetail/CustomerDetail1.dart';
import 'AddDietPlan/AddDietPlan.dart';
import 'UserProfileScreen.dart';
import 'KesfetScreen.dart';
import 'loginScreen.dart';

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
  int selectedIndex = 0; // Drawer için seçili indeks
  int _bottomNavIndex = 0 ; // BottomNavigationBar için seçili indeks
  Widget currentPage = KesfetScreen(); // Şu anki sayfa

  bool get isAdmin => widget.isAdmin;
  bool get isDietitian => widget.isDietitian;

  // BottomNavigationBar'da gösterilecek sayfalar
  List<Widget> get _bottomNavPages {
    if (widget.isDietitian) {
      return [
        KesfetScreen(),
        SettingsPage(),
      ];
    } else if (widget.isAdmin) {
      return [
        KesfetScreen(),
        UserProfileScreen(),
        SettingsPage(),
      ];
    } else {
      return [
        KesfetScreen(),
        GunlukIlerlemeEkrani(),
        UserProfileScreen(),
        SettingsPage(),
      ];
    }
  }

  List<BottomNavigationBarItem> get _bottomNavItems {
    if (widget.isDietitian) {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Keşfet',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Ayarlar',
        ),
      ];
    } else if (widget.isAdmin) {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Keşfet',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Ayarlar',
        ),
      ];
    } else {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Keşfet',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.area_chart),
          label: 'İlerlemem',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Ayarlar',
        ),
      ];
    }
  }
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_id');
      await prefs.remove('is_admin');
      await prefs.remove('is_dietitian');
      await prefs.remove('is_logged_in');
      print("SharedPreferences verileri temizlendi");

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
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
                  const Text('Title',
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  const Text('subtext',
                      style: TextStyle(fontSize: 14, color: Colors.white70)),
                ],
              ),
            ),
            if (isAdmin) ...[
              _buildDrawerItem(Icons.home, 'Ana Ekran', 0, GunlukIlerlemeEkrani()),
              _buildDrawerItem(Icons.person_add, 'Admin Kayıt', 11,
                  AdminRegistrationScreen()),

              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Diyetisyen İslemleri',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54)),
                ),
              ),
              _buildDrawerItem(Icons.person_add, 'Diyetisyen Kayıt', 10,
                  DietitianRegistrationForm()),
              _buildDrawerItem(
                  Icons.food_bank, 'Diyetisyen İzle', 9, DietitianListScreen()),
            ],
            if (!isAdmin && isDietitian) ...[
              //_buildDrawerItem(Icons.home, 'Ana Ekran', 0, GunlukIlerlemeEkrani()),
              //const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Müsteri İslemleri',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54)),
                ),
              ),
              _buildDrawerItem(
                  Icons.person_add, 'Müşteri Kayıt', 1, RegistrationMain()),
              _buildDrawerItem(
                  Icons.people, 'Müşteri İzleme', 2, CustomerDetailMain()),
              _buildDrawerItem(
                  Icons.restaurant, 'Diyet Planı Ekleme', 3, AddDietPlanMain()),
              _buildDrawerItem(Icons.track_changes, 'İlerleme Süreci Ekleme', 4,
                  AddProgressTrackingMain()),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Ayarlar',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54)),
                ),
              ),
              _buildDrawerItem(Icons.food_bank, 'Ayarlar', 6, SettingsPage())
            ],
            if (!isAdmin && !isDietitian) ...[
             // _buildDrawerItem(Icons.home, 'Ana Ekran', 0, GunlukIlerlemeEkrani()),
              //_buildDrawerItem(Icons.person, 'Profilim', 5, UserProfileScreen()),

              _buildDrawerItem(
                  Icons.fastfood, 'Öğün Ekle', 8, WeeklyMealFormScreen()),
              _buildDrawerItem(
                  Icons.list_alt, 'Diyet Planlarım', 15, DietPlansPage()),
              _buildDrawerItem(Icons.settings, 'Ayarlar', 6, SettingsPage()),
            ]
          ],
        ),
      ),
      body: currentPage, // Şu anki sayfa
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
            currentPage = _bottomNavPages[index];
          });
        },
        items: _bottomNavItems,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String text, int index, Widget page) {
    return ListTile(
      leading: Icon(icon,
          color: selectedIndex == index ? Colors.blueGrey : Colors.black54),
      title: Text(text,
          style: TextStyle(
              color: selectedIndex == index ? Colors.blueGrey : Colors.black)),
      tileColor: selectedIndex == index ? Colors.blueGrey.shade100 : null,
      onTap: () {
        setState(() {
          selectedIndex = index; // Drawer indeksini güncelle
          currentPage = page; // Sayfayı güncelle
          _bottomNavIndex = 0; // BottomNavigationBar'ı sıfırla (geçerli bir indeks yap)
        });
        Navigator.pop(context); // Drawer'ı kapat
      },
    );
  }
}