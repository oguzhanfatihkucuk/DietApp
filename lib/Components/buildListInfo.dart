import 'package:flutter/cupertino.dart';
import 'buildInfoRow.dart';

List<Widget> buildListInfo(String title, List<dynamic> items) {
  if (items.isEmpty) return [buildInfoRow(title, 'Bilgi yok')];
  return [
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
    ...items
        .map((item) => Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4),
      child: Text('• $item'),
    ))
        .toList(), // Add .toList() here
  ];
}

