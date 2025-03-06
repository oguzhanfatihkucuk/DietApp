import 'package:flutter/material.dart';
import '../Models/DietitianModel.dart';
import '../Components/buildInfoRow.dart';
import '../Components/buildSectionTitle.dart';

class DietitianDetailScreen extends StatelessWidget {
  final Dietitian dietitian;
  const DietitianDetailScreen({super.key, required this.dietitian});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${dietitian.firstName} ${dietitian.lastName}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPersonalInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildSectionTitle('Diyetisyen Bilgileri'),
            buildInfoRow('ID', dietitian.uid),
            buildInfoRow('Ad Soyad', '${dietitian.firstName} ${dietitian.lastName}'),
            buildInfoRow('Email', dietitian.email),
            buildInfoRow('Telefon', dietitian.phone),
          ],
        ),
      ),
    );
  }
}