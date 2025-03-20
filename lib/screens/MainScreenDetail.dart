import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class GunlukIlerlemeEkrani extends StatefulWidget {
  @override

  _GunlukIlerlemeEkraniState createState() => _GunlukIlerlemeEkraniState();
}

class _GunlukIlerlemeEkraniState extends State<GunlukIlerlemeEkrani> {
  // Yemek tarifleri için örnek veri
  final List<Map<String, dynamic>> tarifler = [
    {
      'isim': 'Karnıyırak',
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

  // Günlük hedef değerleri
  final double gunlukKaloriHedefi = 2181;
  final double yakilanKalori = 690;
  final double tuketilenKalori = 536;
  final double kalanKalori = 1645;
  final double suHedefi = 1.4; // Litre
  final double suTuketimi = 0.9; // Litre

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildKaloriTakipWidget(),
          ],
        ),
      ),
    );
  }


  Widget _buildKaloriTakipWidget() {

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Üst kısım (tarih ve ayarlar)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.calendar_today, color: Colors.black54, size: 20),
                  ),
                  Text(
                    "02.05.2025", // Bugünün tarihini göster
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.more_horiz, color: Colors.black54, size: 20),
                  ),
                ],
              ),
            ),
          ),

          // Kalori bölümü
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Yakılan
                Column(
                  children: [
                    Icon(Icons.local_fire_department, color: Colors.orange),
                    SizedBox(height: 8),
                    Text(
                      '690',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'burn',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                // Kalori grafiği
                Container(
                  width: 180,
                  height: 180,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Dış halka (gri arka plan)
                      Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[50],
                        ),
                      ),

                      // İlerleme halkası
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: CircularProgressIndicator(
                          value: 0.75,
                          strokeWidth: 15,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                          // Sol taraf için sarı renkli kısım
                          color: Colors.amber,
                        ),
                      ),

                      // İç içerik
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '1645',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            'Kcal available',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Tüketilen
                Column(
                  children: [
                    Icon(Icons.restaurant, color: Colors.green),
                    SizedBox(height: 8),
                    Text(
                      '536',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'eaten',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
              ),
              SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),

          // Hedef kalori
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Text(
                  '2181',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Kcal Goal',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Su takibi
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Water',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '0.9L (75%)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '0.1L',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '0.2L',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recomended until now 1.4L',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              _buildWaterIndicator(filled: true),
                              _buildWaterIndicator(filled: true),
                              _buildWaterIndicator(filled: true),
                              _buildWaterIndicator(filled: true),
                              _buildWaterIndicator(filled: true, halfFilled: true),
                              _buildWaterIndicator(),
                              _buildWaterIndicator(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Eksi butonu
                    Container(
                      width: 36,
                      height: 36,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.green[300],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.remove, color: Colors.white),
                    ),
                    // Artı butonu
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.green[400],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildWaterIndicator({bool filled = false, bool halfFilled = false}) {
    Color color;

    if (filled) {
      color = Colors.blue;
    } else if (halfFilled) {
      color = Colors.blue.withOpacity(0.5);
    } else {
      color = Colors.grey[300]!;
    }

    return Container(
      width: 16,
      height: 24,
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        shape: BoxShape.rectangle,
      ),
      child: Icon(Icons.water_drop, color: Colors.white, size: 12),
    );
  }

}