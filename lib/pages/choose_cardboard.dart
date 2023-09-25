import 'package:flutter/material.dart';
import 'package:la_fiszki/cardboard.dart';

class ChooseCardboard extends StatelessWidget {
  final List<Cardboard> cardboards;

  ChooseCardboard({super.key}) : cardboards = [Cardboard("name"), Cardboard("name"), Cardboard("name")];

// CardboardsStorage.getCardboardsFromStorage();

  @override
  Widget build(Object context) {
    return Scaffold(
      body: Column(
        children: cardboards.map((cardboard) => Text(cardboard.name)).toList()
      ),
    );
  }

}