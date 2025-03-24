import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../Models/ProgressTracking.dart';

class ProgressTrackingPage extends StatefulWidget {
  const ProgressTrackingPage({Key? key}) : super(key: key);

  @override
  _ProgressTrackingPageState createState() => _ProgressTrackingPageState();
}

class _ProgressTrackingPageState extends State<ProgressTrackingPage> {

  // State değişkenleri
  List<ProgressTracking> progressList = [];
  bool isLoading = true;
  String? errorMessage;
  String selectedChartType = 'weight'; // 'weight', 'fat', 'muscle'
  final FirebaseDatabase database = FirebaseDatabase.instance;

  @override
  void initState() {
    super.initState();
    _fetchProgressData();
  }

  Future<void> _fetchProgressData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        isLoading = false;
        errorMessage = 'Kullanıcı girişi yapılmamış';
      });
      return;
    }

    setState(() => isLoading = true);
    try {
      DatabaseReference ref =
          database.ref('customer/${user.uid}/progressTracking');
      DatabaseEvent event = await ref.once();

      if (event.snapshot.value == null) {
        setState(() {
          isLoading = false;
          progressList = [];
        });
        return;
      }

      Map<dynamic, dynamic> data =
          event.snapshot.value as Map<dynamic, dynamic>;
      List<ProgressTracking> loadedData = [];

      data.forEach((key, value) {
        loadedData.add(ProgressTracking.fromJson(value));
      });

      // Tarihe göre sırala (yeniden eskiye)
      loadedData.sort((a, b) => b.date.compareTo(a.date));

      setState(() {
        progressList = loadedData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Veri yüklenirken hata oluştu: $e';
      });
    }
  }

  Widget _buildProgressChart() {
    if (progressList.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: Text('Gösterilecek veri yok'),
      );
    }

    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        title: ChartTitle(text: 'İlerleme Grafiği'),
        //legend: Legend(isVisible: true),
        //tooltipBehavior: TooltipBehavior(enable: true),
        primaryXAxis: DateTimeAxis(
          title: AxisTitle(text: 'Tarih'),
          intervalType: DateTimeIntervalType.days,
        ),
        primaryYAxis: NumericAxis(
          title: AxisTitle(text: _getYAxisTitle()),
        ),
        series: <CartesianSeries>[
          LineSeries<ProgressTracking, DateTime>(
            dataSource: progressList,
            xValueMapper: (ProgressTracking data, _) => data.date,
            yValueMapper: (ProgressTracking data, _) => _getSelectedValue(data),
            name: _getSeriesName(),
            markerSettings: MarkerSettings(isVisible: true),
            dataLabelSettings: DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  String _getYAxisTitle() {
    switch (selectedChartType) {
      case 'weight':
        return 'Kilo (kg)';
      case 'fat':
        return 'Vücut Yağ Oranı (%)';
      case 'muscle':
        return 'Kas Kütlesi (kg)';
      default:
        return 'Değer';
    }
  }

  String _getSeriesName() {
    switch (selectedChartType) {
      case 'weight':
        return 'Kilo';
      case 'fat':
        return 'Vücut Yağ Oranı';
      case 'muscle':
        return 'Kas Kütlesi';
      default:
        return 'İlerleme';
    }
  }

  double _getSelectedValue(ProgressTracking data) {
    switch (selectedChartType) {
      case 'weight':
        return data.weight;
      case 'fat':
        return data.bodyFatPercentage;
      case 'muscle':
        return data.muscleMass;
      default:
        return data.weight;
    }
  }

  Widget _buildChartTypeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ChoiceChip(
            label: Text('Kilo'),
            selected: selectedChartType == 'weight',
            onSelected: (selected) {
              if (selected) {
                setState(() => selectedChartType = 'weight');
                _fetchProgressData();
              }
            },
          ),
          ChoiceChip(
            label: Text('Yağ Oranı'),
            selected: selectedChartType == 'fat',
            onSelected: (selected) {
              if (selected) {
                setState(() => selectedChartType = 'fat');
                _fetchProgressData();
              }
            },
          ),
          ChoiceChip(
            label: Text('Kas Kütlesi'),
            selected: selectedChartType == 'muscle',
            onSelected: (selected) {
              if (selected) {
                setState(() => selectedChartType = 'muscle');
                _fetchProgressData();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProgressList() {
    if (progressList.isEmpty) {
      return Center(
        child: Text('Henüz kayıtlı ilerleme verisi bulunmamaktadır.'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: progressList.length,
      itemBuilder: (context, index) {
        final progress = progressList[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            title:Text(DateFormat('dd MMMM yyyy').format(progress.date)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Kilo: ${progress.weight.toStringAsFixed(1)} kg'),
                Text(
                    'Vücut Yağ Oranı: ${progress.bodyFatPercentage.toStringAsFixed(1)}%'),
                Text(
                    'Kas Kütlesi: ${progress.muscleMass.toStringAsFixed(1)} kg'),
                if (progress.notes.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      'Not: ${progress.notes}',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('İlerleme Takibi'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchProgressData,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildProgressChart(),
                      _buildChartTypeSelector(),
                      SizedBox(height: 20),
                      Text(
                        'Kayıt Geçmişi',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 10),
                      _buildProgressList(),
                    ],
                  ),
                ),
    );
  }
}
