import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      'email': 'musteri@example.com',
      'password': 'musteri123',
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

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Mainscreen()),
        );
      } on FirebaseAuthException catch (e) {
        // Hata mesajları aynı kaldı
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_roleCredentials[_selectedRole]!['title']!),
      ),
      body: Padding(
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
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _updateCredentials,
                  ),
                ),
                validator: (value) => value!.isEmpty
                    ? 'Lütfen e-posta giriniz'
                    : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _updateCredentials,
                  ),
                ),
                obscureText: true,
                validator: (value) => value!.isEmpty
                    ? 'Lütfen şifre giriniz'
                    : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
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