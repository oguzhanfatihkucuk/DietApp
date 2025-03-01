import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MainScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Yeni eklenen state değişkenleri
  String _selectedRole = 'musteri';
  final Map<String, Map<String, String>> _roleCredentials = {
    'admin': {
      'email': 'admin332@example.com',
      'password': 'password123',
      'title': 'Yönetici Girişi'
    },
    'musteri': {
      'email': 'deneme@gmail.com',
      'password': 'deneme123',
      'title': 'Diyetisyen Girişi'
    },
    'diyetisyen': {
      'email': 'oguzhanfatih@example.com',
      'password': 'password123',
      'title': 'Müşteri Girişi'
    },
  };

  @override
  void initState() {
    super.initState();
    _updateCredentials();
  }

  void _updateCredentials() {
    setState(() {
      _emailController.text = _roleCredentials[_selectedRole]!['email']!;
      _passwordController.text = _roleCredentials[_selectedRole]!['password']!;
    });
  }

  // Oturum bilgilerini SharedPreferences'a kaydet
  Future<void> _saveUserDataToPrefs(
      String uid, bool isAdmin, bool isDietitian) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', uid);
      await prefs.setBool('is_admin', isAdmin);
      await prefs.setBool('is_dietitian', isDietitian);
      await prefs.setBool('is_logged_in', true);
      print("Kullanıcı verileri SharedPreferences'a kaydedildi");
    } catch (e) {
      print("SharedPreferences kayıt hatası: $e");
    }
  }

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        // Kullanıcı giriş yapıyor
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        User? user = userCredential.user;

        if (user != null) {
          // Realtime Database'den isAdmin değerini al
          DatabaseReference userRef =
              FirebaseDatabase.instance.ref().child('customer').child(user.uid);
          DatabaseEvent event = await userRef.once();
          DataSnapshot snapshot = event.snapshot;

          bool isAdmin = false;
          bool isDietitian = false;

          if (snapshot.value != null &&
              snapshot.child('isAdmin').value != null) {
            isAdmin = snapshot.child('isAdmin').value == true;
          }

          if (snapshot.value != null &&
              snapshot.child('isDietitian').value != null) {
            isDietitian = snapshot.child('isDietitian').value == true;
          }

          // Admin bilgisi terminalde yazdırılıyor
          print("Kullanıcı isAdmin mi? $isAdmin");
          print("Kullanıcı isDietitian mi? $isDietitian");

          // SharedPreferences'a kullanıcı verilerini kaydet
          await _saveUserDataToPrefs(user.uid, isAdmin, isDietitian);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Mainscreen(isAdmin: isAdmin, isDietitian: isDietitian)),
          );
        }
      } on FirebaseAuthException catch (e) {
        print("Firebase Auth Hatası: ${e.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Giriş başarısız: ${e.message}")),
        );
      } catch (e) {
        print("Giriş hatası: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Beklenmeyen bir hata oluştu")),
        );
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_roleCredentials[_selectedRole]!['title']!),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Radio Butonlar
                    Column(
                      children: _roleCredentials.keys.map((role) {
                        return RadioListTile<String>(
                          title: Text(role.toUpperCase()),
                          value: role,
                          groupValue: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                              _updateCredentials();
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'E-posta',
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Lütfen e-posta giriniz' : null,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Şifre',
                      ),
                      obscureText: true,
                      validator: (value) =>
                          value!.isEmpty ? 'Lütfen şifre giriniz' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _login(context),
                      child: const Text('Giriş Yap'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
