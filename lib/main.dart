import 'package:flutter/material.dart';
import 'pages/home.dart';
// import 'pages/choose_cardboard.dart';

void main() {
  runApp(const LaFiszki());
}

class LaFiszki extends StatelessWidget {
  const LaFiszki({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      title: 'La Fiszki',
      // routes: {
      //   '/': (context) => const Home(),
      //   '/choose_cardboard': (context) => const ChooseCardboard()
      // }
    );
  }
}

