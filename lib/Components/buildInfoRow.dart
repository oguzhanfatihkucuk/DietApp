import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildInfoRow(String title, dynamic value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Text('$title: ', style: TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    ),
  );
}