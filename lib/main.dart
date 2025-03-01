import 'package:diet/screens/loginScreen.dart';
import 'package:diet/screens/MainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diyetisyen Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isLoggedIn = false;
  bool _isAdmin = false;
  bool _isDietitian = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      // SharedPreferences kullanmadan önce Firebase Authentication kontrolü
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Kullanıcı Firebase'de giriş yapmış, SharedPreferences'ten rolleri al
        await _loadUserPreferences();
      } else {
        setState(() {
          _isLoading = false;
          _isLoggedIn = false;
        });
      }
    } catch (e) {
      print("Kimlik doğrulama kontrolü hatası: $e");
      setState(() {
        _isLoading = false;
        _isLoggedIn = false;
      });
    }
  }

  Future<void> _loadUserPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // SharedPreferences'ten değerleri oku
      bool isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      bool isAdmin = prefs.getBool('is_admin') ?? false;
      bool isDietitian = prefs.getBool('is_dietitian') ?? false;

      setState(() {
        _isLoading = false;
        _isLoggedIn = isLoggedIn;
        _isAdmin = isAdmin;
        _isDietitian = isDietitian;
      });

      print("SharedPreferences verilerini okuma başarılı");
      print("is_logged_in: $isLoggedIn, is_admin: $isAdmin, is_dietitian: $isDietitian");
    } catch (e) {
      print("SharedPreferences okuma hatası: $e");
      // Hata durumunda FirebaseAuth verisine güvenelim
      User? currentUser = FirebaseAuth.instance.currentUser;
      setState(() {
        _isLoading = false;
        _isLoggedIn = currentUser != null;
        // Varsayılan olarak false kullan
        _isAdmin = false;
        _isDietitian = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Uygulama başlatılıyor..."),
            ],
          ),
        ),
      );
    } else {
      if (_isLoggedIn) {
        return Mainscreen(isAdmin: _isAdmin, isDietitian: _isDietitian);
      } else {
        return LoginScreen();
      }
    }
  }
}