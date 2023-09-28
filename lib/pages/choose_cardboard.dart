import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';

class ChooseCardboard extends StatelessWidget {
  final List<Flashcard> cardboards;

  ChooseCardboard({super.key})
      : cardboards = [Flashcard("name"), Flashcard("name"), Flashcard("name")];

// CardboardsStorage.getCardboardsFromStorage();

  @override
  Widget build(Object context) {
    return Scaffold(
      body: Column(
          children:
              cardboards.map((cardboard) => Text(cardboard.name)).toList()),
    );
  }
}
