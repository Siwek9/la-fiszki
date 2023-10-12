import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';

class FlashcardSummary extends StatelessWidget {
  const FlashcardSummary({super.key, required this.knownFlashcards, required this.dontKnownFlashcards});

  final List<FlashcardElement> knownFlashcards;
  final List<FlashcardElement> dontKnownFlashcards;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Column(
          children: [
            Card(
              child: Builder(builder: (context) {
                if (dontKnownFlashcards.isEmpty) {
                  return Text("Umiesz już wszystko!\nCzy chcesz rozwiązać je jeszcze raz?");
                } else {
                  Navigator siema = Navigator();
                  return Text("Umiesz ${knownFlashcards.length} fiszek!\nPozostało ${dontKnownFlashcards.length} do nauki\nCzy kontynuowac naukę?");
                }
              }),
            ),
          ],
        ),
      ),
    ));
  }
}
