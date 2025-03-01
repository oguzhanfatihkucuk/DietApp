import 'package:flutter/material.dart';
import '../Models/CustomerModel.dart';
import '../Components/buildInfoRow.dart';
import '../Components/buildSectionTitle.dart';

class DietitianDetailScreen extends StatelessWidget {
  final Customer customer;
  const DietitianDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${customer.firstName} ${customer.lastName}'),
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
            buildInfoRow('ID', customer.customerID),
            buildInfoRow('Ad Soyad', '${customer.firstName} ${customer.lastName}'),
            buildInfoRow('Email', customer.email),
            buildInfoRow('Telefon', customer.phone),
            //buildInfoRow('Uzmanlık Alanı', customer.specialization ?? 'Belirtilmemiş'),
            //buildInfoRow('Deneyim', '${customer.experienceYears ?? 0} yıl'),
            //buildInfoRow('Kayıt Tarihi', _formatDate(customer.registrationDate)),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}