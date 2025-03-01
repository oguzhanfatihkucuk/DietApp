import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Ayarlar için kullanılacak örnek değişkenler
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  String _language = 'Türkçe';
  String _weightUnit = 'kg';
  String _heightUnit = 'cm';
  String _calorieUnit = 'kcal';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const Divider(height: 1),
            _buildAppearanceSection(),
            const Divider(height: 1),
            _buildNotificationSection(),
            const Divider(height: 1),
            _buildLanguageSection(),
            const Divider(height: 1),
            _buildUnitSection(),
            const Divider(height: 1),
            _buildPrivacySection(),
            const Divider(height: 1),
            _buildSupportSection(),
            const Divider(height: 1),
            _buildAboutSection(),
            const Divider(height: 1),
            _buildLogoutSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green.shade800,
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Profil'),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.person, color: Colors.green.shade800),
          ),
          title: const Text('Profil Bilgilerim'),
          subtitle: const Text('Kişisel bilgilerinizi güncelleyin'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Profil sayfasına yönlendirme yapılacak
          },
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.lock, color: Colors.green.shade800),
          ),
          title: const Text('Şifre Değiştir'),
          subtitle: const Text('Hesap güvenlik ayarlarınızı yönetin'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Şifre değiştirme sayfasına yönlendirme yapılacak
          },
        ),
      ],
    );
  }

  Widget _buildAppearanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Görünüm'),
        SwitchListTile(
          title: const Text('Karanlık Mod'),
          subtitle: const Text('Uygulamayı karanlık temada görüntüleyin'),
          secondary: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(
              _darkMode ? Icons.dark_mode : Icons.light_mode,
              color: Colors.green.shade800,
            ),
          ),
          value: _darkMode,
          onChanged: (bool value) {
            setState(() {
              _darkMode = value;
            });
          },
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.format_size, color: Colors.green.shade800),
          ),
          title: const Text('Yazı Boyutu'),
          subtitle: const Text('Uygulama içindeki yazı boyutunu ayarlayın'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Yazı boyutu ayarlama sayfasına yönlendirme
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Bildirimler'),
        SwitchListTile(
          title: const Text('Bildirimleri Etkinleştir'),
          subtitle: const Text('Tüm bildirimleri açın veya kapatın'),
          secondary: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.notifications, color: Colors.green.shade800),
          ),
          value: _notificationsEnabled,
          onChanged: (bool value) {
            setState(() {
              _notificationsEnabled = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('E-posta Bildirimleri'),
          subtitle: const Text('Güncellemeler ve önemli bilgileri e-posta ile alın'),
          value: _emailNotifications,
          onChanged: _notificationsEnabled ? (bool value) {
            setState(() {
              _emailNotifications = value;
            });
          } : null,
        ),
        SwitchListTile(
          title: const Text('SMS Bildirimleri'),
          subtitle: const Text('Acil hatırlatıcıları SMS ile alın'),
          value: _smsNotifications,
          onChanged: _notificationsEnabled ? (bool value) {
            setState(() {
              _smsNotifications = value;
            });
          } : null,
        ),
        ListTile(
          title: const Text('Diyet Hatırlatıcıları'),
          subtitle: const Text('Öğün ve su tüketimi hatırlatmaları ayarlayın'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          enabled: _notificationsEnabled,
          onTap: _notificationsEnabled ? () {
            // Hatırlatıcı ayarları sayfasına yönlendirme
          } : null,
        ),
      ],
    );
  }

  Widget _buildLanguageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Dil ve Bölge'),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.language, color: Colors.green.shade800),
          ),
          title: const Text('Uygulama Dili'),
          subtitle: Text('Şu anki dil: $_language'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _showLanguageDialog();
          },
        ),
      ],
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dil Seçin'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                _buildLanguageOption('Türkçe'),
                _buildLanguageOption('English'),
                _buildLanguageOption('Deutsch'),
                _buildLanguageOption('Français'),
                _buildLanguageOption('Español'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String language) {
    return ListTile(
      title: Text(language),
      trailing: _language == language ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: () {
        setState(() {
          _language = language;
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildUnitSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Ölçü Birimleri'),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.scale, color: Colors.green.shade800),
          ),
          title: const Text('Ağırlık Birimi'),
          subtitle: Text('Şu anki birim: $_weightUnit'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _showUnitDialog('weight');
          },
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.height, color: Colors.green.shade800),
          ),
          title: const Text('Boy Birimi'),
          subtitle: Text('Şu anki birim: $_heightUnit'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _showUnitDialog('height');
          },
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.local_fire_department, color: Colors.green.shade800),
          ),
          title: const Text('Kalori Birimi'),
          subtitle: Text('Şu anki birim: $_calorieUnit'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            _showUnitDialog('calorie');
          },
        ),
      ],
    );
  }

  void _showUnitDialog(String unitType) {
    List<String> options = [];
    String title = '';
    String currentValue = '';

    switch (unitType) {
      case 'weight':
        title = 'Ağırlık Birimi Seçin';
        options = ['kg', 'lbs'];
        currentValue = _weightUnit;
        break;
      case 'height':
        title = 'Boy Birimi Seçin';
        options = ['cm', 'inch'];
        currentValue = _heightUnit;
        break;
      case 'calorie':
        title = 'Kalori Birimi Seçin';
        options = ['kcal', 'kJ'];
        currentValue = _calorieUnit;
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: options.map((option) {
                return ListTile(
                  title: Text(option),
                  trailing: currentValue == option ? const Icon(Icons.check, color: Colors.green) : null,
                  onTap: () {
                    setState(() {
                      switch (unitType) {
                        case 'weight':
                          _weightUnit = option;
                          break;
                        case 'height':
                          _heightUnit = option;
                          break;
                        case 'calorie':
                          _calorieUnit = option;
                          break;
                      }
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrivacySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Gizlilik ve Güvenlik'),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.security, color: Colors.green.shade800),
          ),
          title: const Text('Gizlilik Politikası'),
          subtitle: const Text('Verilerinizin nasıl kullanıldığını görüntüleyin'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Gizlilik politikası sayfasına yönlendirme
          },
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.data_usage, color: Colors.green.shade800),
          ),
          title: const Text('Veri Kullanımı'),
          subtitle: const Text('Veri kullanımınızı yönetin ve temizleyin'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Veri kullanımı sayfasına yönlendirme
          },
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Destek'),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.help, color: Colors.green.shade800),
          ),
          title: const Text('Yardım Merkezi'),
          subtitle: const Text('Sık sorulan sorular ve yardım makaleleri'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Yardım sayfasına yönlendirme
          },
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.support_agent, color: Colors.green.shade800),
          ),
          title: const Text('Müşteri Desteği'),
          subtitle: const Text('Destek ekibimizle iletişime geçin'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Destek iletişim sayfasına yönlendirme
          },
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.bug_report, color: Colors.green.shade800),
          ),
          title: const Text('Hata Bildir'),
          subtitle: const Text('Bir sorun veya öneri gönderin'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Hata bildirim sayfasına yönlendirme
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Hakkında'),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.info, color: Colors.green.shade800),
          ),
          title: const Text('Uygulama Bilgisi'),
          subtitle: const Text('Versiyon ve lisans bilgisi'),
          trailing: const Text('v1.0.0'),
          onTap: () {
            // Uygulama bilgisi sayfası
          },
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.update, color: Colors.green.shade800),
          ),
          title: const Text('Güncellemeler'),
          subtitle: const Text('Güncellemeleri kontrol edin'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // Güncelleme kontrol işlemi
          },
        ),
      ],
    );
  }

  Widget _buildLogoutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          // Çıkış işlemi
          _showLogoutDialog();
        },
        child: const Text(
          'Çıkış Yap',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Çıkış Yap'),
          content: const Text('Hesabınızdan çıkış yapmak istediğinizden emin misiniz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                // Çıkış işlemi ve giriş sayfasına yönlendirme
                Navigator.of(context).pop();
              },
              child: const Text('Çıkış Yap', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}