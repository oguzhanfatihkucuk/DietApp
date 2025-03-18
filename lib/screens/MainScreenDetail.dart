import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AnimasyonOrnegi extends StatefulWidget {
  @override
  _AnimasyonOrnegiState createState() => _AnimasyonOrnegiState();
}

class _AnimasyonOrnegiState extends State<AnimasyonOrnegi> {
  // Yemek tarifleri için örnek veri
  final List<Map<String, dynamic>> tarifler = [
    {
      'isim': 'Karnıyarak',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
            Text(
              'Popüler Tarifler',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 15),

            // Tarif kartları
            ...tarifler.map((tarif) => _buildTarifCard(tarif)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTarifCard(Map<String, dynamic> tarif) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
          Container(
            height: 150,
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
                size: 60,
                color: Colors.grey[600],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tarif['isim'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4),
                    Text(
                      tarif['sure'],
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(
                      Icons.signal_cellular_alt,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 4),
                    Text(
                      tarif['zorluk'],
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  tarif['aciklama'],
                  style: TextStyle(
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[800],
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Tarifi Görüntüle',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}