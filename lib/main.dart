import 'package:flutter/material.dart';
import 'pages/home.dart';
// import 'pages/choose_cardboard.dart';

void main() {
  runApp(const LaFiszki());
}

class LaFiszki extends StatelessWidget {
  const LaFiszki({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      title: 'La Fiszki',
    );
  }
}