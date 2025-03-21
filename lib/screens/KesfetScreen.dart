import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'KesfetScreenDetails/SaglikHaberDetayScreen.dart';
import 'KesfetScreenDetails/SporAktiviteDetayScreen.dart';
import 'KesfetScreenDetails/TarifDetayScreen.dart';

class KesfetScreen extends StatefulWidget {
  @override
  _KesfetScreenState createState() => _KesfetScreenState();
}

class _KesfetScreenState extends State<KesfetScreen> {
  // Yemek tarifleri için örnek veri
  // KesfetScreen.dart (Güncellenmiş kısım)
  final List<Map<String, dynamic>> tarifler = [
    {
      'isim': 'Karnıyarık',
      'sure': '45 dk',
      'zorluk': 'Orta',
      'kalori': '380 kcal',
      'kisiSayisi': '4 Kişilik',
      'resim': 'https://example.com/karniyarik.jpg',
      'malzemeler': [
        '4 adet orta boy patlıcan',
        '300 gr kıyma',
        '2 adet soğan',
        '3 adet domates',
        '2 adet yeşil biber',
        '3 diş sarımsak',
        '2 yemek kaşığı zeytinyağı',
        '1 tatlı kaşığı biber salçası',
        'Tuz, karabiber, pul biber'
      ],
      'adimlar': [
        'Patlıcanları alacalı soyun ve tuzlu suda 15 dakika bekletin.',
        'Soğanları küp küp doğrayıp zeytinyağında kavurun.',
        'Kıymayı ekleyip renk alana kadar kavurmaya devam edin.',
        'Küp doğranmış domates, biber ve sarımsağı ekleyin.',
        'Salça ve baharatları ilave edip 5 dakika daha pişirin.',
        'Patlıcanları ortadan ikiye kesip içlerini hafifçe oyun.',
        'Hazırlanan iç harcı patlıcanlara doldurun.',
        'Önceden ısıtılmış 180 derece fırında 25-30 dakika pişirin.'
      ],
      'aciklama': 'Geleneksel Türk mutfağının en sevilen yemeklerinden biri olan karnıyarık, patlıcan ve kıyma ile hazırlanır.',
      'renk': Colors.purple[100],
    },
    {
      'isim': 'Lazanya',
      'sure': '1 saat 30 dk',
      'zorluk': 'Zor',
      'kalori': '600 kcal',
      'kisiSayisi': '6 Kişilik',
      'resim': 'https://example.com/lazanya.jpg',
      'malzemeler': [
        '12 adet lazanya hamuru',
        '500 gr kıyma',
        '2 adet soğan',
        '3 adet domates',
        '2 yemek kaşığı domates salçası',
        '3 diş sarımsak',
        '400 gr beşamel sos',
        '200 gr rendelenmiş mozzarella peyniri',
        'Tuz, karabiber, kekik',
        '2 yemek kaşığı zeytinyağı'
      ],
      'adimlar': [
        'Soğanları doğrayıp zeytinyağında kavurun.',
        'Kıymayı ekleyin ve suyunu salıp çekene kadar pişirin.',
        'Domatesleri doğrayıp, domates salçasını ve baharatları ekleyin.',
        'Lazanya hamurlarını haşlayın.',
        'Bir fırın kabına bir kat lazanya, üzerine kıymalı harç ve beşamel sosu dökün.',
        'İşlemi 3 kat olacak şekilde tekrarlayın.',
        'Üst katmana mozzarella peynirini serpip 180 derece fırında 40-45 dakika pişirin.'
      ],
      'aciklama': 'İtalyan mutfağının en sevilen yemeklerinden biri olan lazanya, bol malzemeli katmanları ile lezzetli bir yemektir.',
      'renk': Colors.orange[100],
    },
    {
      'isim': 'Fırın Tavuk',
      'sure': '1 saat',
      'zorluk': 'Kolay',
      'kalori': '450 kcal',
      'kisiSayisi': '4 Kişilik',
      'resim': 'https://example.com/firin_tavuk.jpg',
      'malzemeler': [
        '1 bütün tavuk',
        '2 yemek kaşığı zeytinyağı',
        '1 tatlı kaşığı kekik',
        '1 tatlı kaşığı pul biber',
        'Tuz, karabiber',
        '2 diş sarımsak',
        '1 adet limon'
      ],
      'adimlar': [
        'Tavuğu yıkayıp, üzerine zeytinyağını, baharatları ve tuzu sürün.',
        'Sarımsakları ezip tavuğun içine koyun.',
        'Limonu ortadan ikiye kesip tavuk ile birlikte pişireceğiniz tepsiye yerleştirin.',
        'Önceden ısıtılmış 200 derece fırında 45-50 dakika pişirin.',
        'Tavuk piştikten sonra üzerine biraz daha kekik serpip servis edin.'
      ],
      'aciklama': 'Pratik ve lezzetli bir şekilde hazırlanan fırın tavuk, özellikle hafta sonu yemekleri için ideal bir tercihtir.',
      'renk': Colors.yellow[100],
    },
  ];

  // Sağlık haberleri için örnek veri
  final List<Map<String, dynamic>> saglikHaberleri = [
    {
      'baslik': 'Düzenli Kahvaltının Önemi',
      'ozet': 'Düzenli kahvaltı yapmanın metabolizma üzerindeki olumlu etkileri araştırmalarla kanıtlandı.',
      'tarih': '18 Mart 2025',
      'renk': Colors.blue[100],
    },
    {
      'baslik': 'Akdeniz Diyetinin Faydaları',
      'ozet': 'Zeytinyağı ve sebze ağırlıklı Akdeniz diyetinin kalp sağlığına etkileri üzerine yeni bir araştırma yayınlandı.',
      'tarih': '15 Mart 2025',
      'renk': Colors.teal[100],
    },
    {
      'baslik': 'Uyku Kalitesini Artıran Besinler',
      'ozet': 'Bazı besinlerin uyku kalitesini artırdığı ve uykusuzluk sorunlarına çözüm olabileceği belirtiliyor.',
      'tarih': '10 Mart 2025',
      'renk': Colors.indigo[100],
    },
  ];

  // Spor aktiviteleri için örnek veri
  final List<Map<String, dynamic>> sporAktiviteleri = [
    {
      'baslik': 'Evde Pilates Egzersizleri',
      'sure': '30 dk',
      'seviye': 'Başlangıç',
      'aciklama': 'Ekipman gerektirmeyen, evde yapılabilecek temel pilates hareketleri.',
      'renk': Colors.pink[100],
    },
    {
      'baslik': 'HIIT Antrenmanı',
      'sure': '25 dk',
      'seviye': 'Orta',
      'aciklama': 'Yüksek yoğunluklu interval antrenmanıyla kısa sürede maksimum kalori yakımı.',
      'renk': Colors.amber[100],
    },
    {
      'baslik': 'Yoga Akışı',
      'sure': '45 dk',
      'seviye': 'Tüm Seviyeler',
      'aciklama': 'Stresi azaltan ve esnekliği artıran temel yoga pozisyonları.',
      'renk': Colors.cyan[100],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.65;
    final smallCardWidth = screenWidth * 0.6;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tarifler Keşfet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Bugün ne pişirmek istersiniz?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tarif ara...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  _buildSectionHeader('Popüler Tarifler'),
                  SizedBox(height: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.75,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: tarifler.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _navigateToTarifDetay(tarifler[index], context),
                          child: _buildHorizontalTarifCard(tarifler[index], cardWidth),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 25),
                  _buildSectionHeader('Sağlık Haberleri'),
                  SizedBox(height: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.45,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: saglikHaberleri.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _navigateToSaglikHaberDetay(saglikHaberleri[index], context),
                          child: _buildSaglikHaberCard(saglikHaberleri[index], smallCardWidth),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 25),
                  _buildSectionHeader('Spor Aktiviteleri'),
                  SizedBox(height: 10),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.55,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: sporAktiviteleri.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _navigateToSporAktiviteDetay(sporAktiviteleri[index], context),
                          child: _buildSporAktiviteCard(sporAktiviteleri[index], cardWidth),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NAVİGASYON FONKSİYONLARI
  void _navigateToTarifDetay(Map<String, dynamic> tarif, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TarifDetayScreen(tarif: tarif)),
    );
  }

  void _navigateToSaglikHaberDetay(Map<String, dynamic> haber, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SaglikHaberDetayScreen(haber: haber)),
    );
  }

  void _navigateToSporAktiviteDetay(Map<String, dynamic> aktivite, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SporAktiviteDetayScreen(aktivite: aktivite)),
    );
  }

  // DİĞER WIDGETLAR
  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Tümünü Gör',
            style: TextStyle(color: Colors.orange[800]),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalTarifCard(Map<String, dynamic> tarif, double width) {
    return Container(
      width: width,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: tarif['renk'] ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Icon(Icons.restaurant, size: 50, color: Colors.grey[600]),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          tarif['isim'],
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.favorite_border, color: Colors.red, size: 20),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(tarif['sure'], style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      SizedBox(width: 12),
                      Icon(Icons.signal_cellular_alt, size: 14, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(tarif['zorluk'], style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      tarif['aciklama'],
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text('Tarifi Görüntüle', style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaglikHaberCard(Map<String, dynamic> haber, double width) {
    return Container(
      width: width,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: haber['renk'] ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.health_and_safety, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Text(haber['tarih'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
            SizedBox(height: 10),
            Text(
              haber['baslik'],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Expanded(
              child: Text(
                haber['ozet'],
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              'Devamını Oku',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSporAktiviteCard(Map<String, dynamic> aktivite, double width) {
    return Container(
      width: width,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: aktivite['renk'] ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Center(
                child: Icon(Icons.fitness_center, size: 50, color: Colors.grey[600]),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    aktivite['baslik'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(aktivite['sure'], style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      SizedBox(width: 12),
                      Icon(Icons.fitness_center, size: 14, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(aktivite['seviye'], style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      aktivite['aciklama'],
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}