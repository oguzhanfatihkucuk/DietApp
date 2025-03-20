import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class KesfetScreen extends StatefulWidget {
  @override
  _KesfetScreenState createState() => _KesfetScreenState();
}

class _KesfetScreenState extends State<KesfetScreen> {
  // Yemek tarifleri için örnek veri
  final List<Map<String, dynamic>> tarifler = [
    {
      'isim': 'Karnıyarık',
      'sure': '45 dk',
      'zorluk': 'Orta',
      'aciklama': 'Geleneksel Türk mutfağının en sevilen yemeklerinden biri olan karnıyarık, patlıcan ve kıyma ile hazırlanır.',
      'renk': Colors.purple[100],
    },
    {
      'isim': 'Mercimek Çorbası',
      'sure': '30 dk',
      'zorluk': 'Kolay',
      'aciklama': 'Kırmızı mercimek kullanılarak hazırlanan, protein açısından zengin, besleyici bir çorba tarifi.',
      'renk': Colors.orange[100],
    },
    {
      'isim': 'Mantı',
      'sure': '90 dk',
      'zorluk': 'Zor',
      'aciklama': 'Hamur içerisine kıyma konularak yapılan, yoğurt ve sarımsaklı sos ile servis edilen geleneksel bir Türk yemeği.',
      'renk': Colors.green[100],
    },
    {
      'isim': 'Fırında Tavuk',
      'sure': '60 dk',
      'zorluk': 'Orta',
      'aciklama': 'Baharatlarla marine edilmiş tavuk parçalarının fırında pişirilmesiyle hazırlanan lezzetli bir ana yemek.',
      'renk': Colors.red[100],
    },
    {
      'isim': 'Revani Tatlısı',
      'sure': '50 dk',
      'zorluk': 'Orta',
      'aciklama': 'İrmik kullanılarak yapılan, şerbetli ve hafif bir Türk tatlısı. Servis ederken üzerine hindistan cevizi serpilir.',
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

  // Günlük hedef değerleri
  final double gunlukKaloriHedefi = 2181;
  final double yakilanKalori = 690;
  final double tuketilenKalori = 536;
  final double kalanKalori = 1645;
  final double suHedefi = 1.4; // Litre
  final double suTuketimi = 0.9; // Litre

  @override
  Widget build(BuildContext context) {
    // Ekran boyutlarını al
    final screenWidth = MediaQuery.of(context).size.width;

    // Kartların genişliğini ekran genişliğine göre ayarla
    final cardWidth = screenWidth * 0.65;
    final smallCardWidth = screenWidth * 0.6;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ana İçerik
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

                  // Arama çubuğu
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

                  // Popüler Tarifler Başlık
                  _buildSectionHeader('Popüler Tarifler'),
                  SizedBox(height: 10),

                  // Yatay Kaydırılabilir Popüler Tarifler
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.75, // Responsive yükseklik
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: tarifler.length,
                      itemBuilder: (context, index) {
                        return _buildHorizontalTarifCard(tarifler[index], cardWidth);
                      },
                    ),
                  ),

                  SizedBox(height: 25),

                  // Sağlık Haberleri Başlık
                  _buildSectionHeader('Sağlık Haberleri'),
                  SizedBox(height: 10),

                  // Yatay Kaydırılabilir Sağlık Haberleri
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.45, // Responsive yükseklik
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: saglikHaberleri.length,
                      itemBuilder: (context, index) {
                        return _buildSaglikHaberCard(saglikHaberleri[index], smallCardWidth);
                      },
                    ),
                  ),

                  SizedBox(height: 25),

                  // Spor Aktiviteleri Başlık
                  _buildSectionHeader('Spor Aktiviteleri'),
                  SizedBox(height: 10),

                  // Yatay Kaydırılabilir Spor Aktiviteleri
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.55, // Responsive yükseklik
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: sporAktiviteleri.length,
                      itemBuilder: (context, index) {
                        return _buildSporAktiviteCard(sporAktiviteleri[index], cardWidth);
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

  // Bölüm başlıkları için widget
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
            style: TextStyle(
              color: Colors.orange[800],
            ),
          ),
        ),
      ],
    );
  }

  // Yatay kaydırmada kullanılacak tarif kartı
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
          // Resim alanı
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
                child: Icon(
                  Icons.restaurant,
                  size: 50,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),

          // İçerik alanı
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
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                        size: 20,
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        tarif['sure'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(
                        Icons.signal_cellular_alt,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        tarif['zorluk'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      tarif['aciklama'],
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800],
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Tarifi Görüntüle',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
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

  // Sağlık haberi kartı
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
                Icon(
                  Icons.health_and_safety,
                  color: Colors.green,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  haber['tarih'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              haber['baslik'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Expanded(
              child: Text(
                haber['ozet'],
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              'Devamını Oku',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Spor aktivitesi kartı
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
          // Resim alanı
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
                child: Icon(
                  Icons.fitness_center,
                  size: 50,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),

          // İçerik alanı
          Expanded(
            flex: 6,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    aktivite['baslik'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        aktivite['sure'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 12),
                      Icon(
                        Icons.fitness_center,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        aktivite['seviye'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: Text(
                      aktivite['aciklama'],
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                      ),
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