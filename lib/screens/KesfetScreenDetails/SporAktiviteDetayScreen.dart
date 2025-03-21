import 'package:flutter/material.dart';

class SporAktiviteDetayScreen extends StatelessWidget {
  final Map<String, dynamic> aktivite;

  const SporAktiviteDetayScreen({Key? key, required this.aktivite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(aktivite['baslik']),
        backgroundColor: Colors.pink[700],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Aktivite resmi (Placeholder)
            Container(
              height: 200,
              width: double.infinity,
              color: aktivite['renk'] ?? Colors.pink[100],
              child: Center(
                child: Icon(
                  Icons.fitness_center,
                  size: 80,
                  color: Colors.grey[600],
                ),
              ),
            ),

            // Aktivite bilgileri
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık ve süre
                  Text(
                    aktivite['baslik'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        'Süre: ${aktivite['sure']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.fitness_center, color: Colors.grey[600]),
                      SizedBox(width: 8),
                      Text(
                        'Seviye: ${aktivite['seviye']}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  Divider(height: 32),

                  // Açıklama
                  Text(
                    'Antrenman Hakkında',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),

                  Text(
                    aktivite['aciklama'],
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 24),

                  // Ekstra içerik: Egzersizler
                  Text(
                    'Egzersizler',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Örnek egzersizler
                  _buildExerciseCard(
                      'Jumping Jacks',
                      '30 saniye',
                      'Tüm vücudu ısıtmak için mükemmel bir egzersizdir. Ayakta dik durun, kollar yanlarda. Zıplayarak bacakları açın ve kolları başın üzerinde birleştirin, tekrar zıplayarak başlangıç pozisyonuna dönün.'
                  ),

                  _buildExerciseCard(
                      'Squat',
                      '15 tekrar',
                      'Ayaklar omuz genişliğinde açık durumda, kalçanızı arkaya doğru iterek dizlerinizi bükün. Dizler ayak parmak uçlarını geçmemeli. Sonra kalçanızı sıkarak başlangıç pozisyonuna dönün.'
                  ),

                  _buildExerciseCard(
                      'Push-up',
                      '10 tekrar',
                      'Elleriniz omuz genişliğinden biraz daha açık şekilde, vücut düz bir çizgide olacak şekilde plank pozisyonu alın. Dirseklerinizi bükerek göğsünüzü yere yaklaştırın, sonra kendinizi yukarı itin.'
                  ),

                  _buildExerciseCard(
                      'Plank',
                      '30 saniye',
                      'Dirsekleriniz omuzların altında, vücut düz bir çizgide. Karın ve kalça kaslarınızı sıkın ve pozisyonu koruyun. Nefes alıp vermeyi unutmayın.'
                  ),

                  SizedBox(height: 24),

                  // Tavsiyeler bölümü
                  Text(
                    'Antrenman Tavsiyeleri',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),

                  _buildTipCard(
                      'Egzersiz öncesi 5-10 dakika ısınma yaptığınızdan emin olun.',
                      Icons.hot_tub
                  ),

                  _buildTipCard(
                      'Hareket aralığınızı tam kullanmaya özen gösterin.',
                      Icons.auto_graph
                  ),

                  _buildTipCard(
                      'Her egzersiz sonrası 30-60 saniye dinlenin.',
                      Icons.bedtime
                  ),

                  _buildTipCard(
                      'Egzersiz sonrası bol su için ve streching yapmayı unutmayın.',
                      Icons.water_drop
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {
            // Antrenmana başla butonu
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink[700],
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'Antrenmana Başla',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Egzersiz kartı oluşturmak için yardımcı widget
  Widget _buildExerciseCard(String title, String duration, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.pink[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  duration,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.pink[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  // Tavsiye kartı oluşturmak için yardımcı widget
  Widget _buildTipCard(String tip, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.pink[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.pink[700],
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}