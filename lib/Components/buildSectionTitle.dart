import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildSectionTitle(String title) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
    ),
  );
}