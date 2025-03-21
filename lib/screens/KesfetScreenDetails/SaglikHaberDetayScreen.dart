// SaglikHaberDetayScreen.dart
import 'package:flutter/material.dart';

class SaglikHaberDetayScreen extends StatelessWidget {
  final Map<String, dynamic> haber;

  const SaglikHaberDetayScreen({Key? key, required this.haber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sağlık Haberi'),
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Haber resmi (Placeholder)
            Container(
              height: 200,
              width: double.infinity,
              color: haber['renk'] ?? Colors.blue[100],
              child: Center(
                child: Icon(
                  Icons.health_and_safety,
                  size: 80,
                  color: Colors.green,
                ),
              ),
            ),

            // Haber içeriği
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    haber['tarih'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),

                  Text(
                    haber['baslik'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Genişletilmiş özet
                  Text(
                    haber['ozet'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  SizedBox(height: 24),

                  // Burada gerçek bir uygulamada haber detayı olacaktır
                  // Örnek metin olarak lorem ipsum ekliyorum
                  _buildArticleText(),

                  SizedBox(height: 24),

                  // Ekstra bölüm: İlgili Makaleler
                  Text(
                    'İlgili Makaleler',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),

                  // İlgili makale listeleri
                  _buildRelatedArticle(
                      'Sabah Yürüyüşünün Faydaları',
                      '12 Mart 2025'
                  ),

                  _buildRelatedArticle(
                      'Dengeli Beslenme İçin Öneriler',
                      '5 Mart 2025'
                  ),

                  _buildRelatedArticle(
                      'Vitamin Takviyeleri Ne Zaman Alınmalı?',
                      '1 Mart 2025'
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Makale metni oluşturmak için yardımcı widget
  Widget _buildArticleText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Son yapılan bilimsel araştırmalar, dengeli ve düzenli bir beslenme programının insan sağlığı üzerinde uzun vadeli olumlu etkileri olduğunu doğruluyor. Özellikle günün ilk öğünü olan kahvaltının, metabolizma hızını artırdığı ve gün boyu enerji seviyelerini dengelediği belirtiliyor.',
          style: TextStyle(fontSize: 16, height: 1.6),
        ),
        SizedBox(height: 16),
        Text(
          'Amerika Beslenme Derneği tarafından desteklenen ve 5000 katılımcı ile gerçekleştirilen araştırmada, düzenli kahvaltı yapan bireylerin gün içerisinde daha az abur cubur tükettikleri ve kan şekeri seviyelerinin daha dengeli seyrettiği gözlemlendi.',
          style: TextStyle(fontSize: 16, height: 1.6),
        ),
        SizedBox(height: 16),
        Text(
          'Araştırma ekibinden Prof. Dr. Emily Johnson, "Kahvaltı, adından da anlaşılacağı gibi gece boyu süren açlık periyodunu sonlandırmak için önemlidir. Protein ve kompleks karbonhidrat içeren bir kahvaltı, beyni ve vücudu güne hazırlar" açıklamasında bulundu.',
          style: TextStyle(fontSize: 16, height: 1.6),
        ),
        SizedBox(height: 16),
        Text(
          'İdeal bir kahvaltıda neler olmalı?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Uzmanlar, ideal bir kahvaltının şu besin gruplarını içermesi gerektiğini vurguluyor:',
          style: TextStyle(fontSize: 16, height: 1.6),
        ),
        SizedBox(height: 8),
        Text(
          '• Protein kaynakları (yumurta, peynir, süt ürünleri)\n• Tam tahıllı ekmek veya yulaf\n• Taze meyve veya sebzeler\n• Sağlıklı yağlar (avokado, ceviz, badem)',
          style: TextStyle(fontSize: 16, height: 1.6),
        ),
      ],
    );
  }

  // İlgili makale widget'ı
  Widget _buildRelatedArticle(String title, String date) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.article,
              color: Colors.blue[700],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }
}