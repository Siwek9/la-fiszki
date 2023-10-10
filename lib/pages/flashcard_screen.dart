import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/pages/flashcard_summary.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key, required this.cards});
  final List<FlashcardElement> cards;

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState(cards: cards);
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  _FlashcardScreenState({required this.cards});
  final List<FlashcardElement> cards;
  int cardNow = 0;
  bool sideNow = false;
  List<FlashcardElement> cardKnown =
      List<FlashcardElement>.empty(growable: true);
  List<FlashcardElement> cardDoesntKnown =
      List<FlashcardElement>.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Text("$cardNow/${cards.length}"),
        ElevatedButton(
          onPressed: () {
            setState(() {
              sideNow = !sideNow;
            });
          },
          child: Card(
            child: Text(
                sideNow ? cards[cardNow].frontSide : cards[cardNow].backSide),
          ),
        ),
        Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  whenUserDontKnow(cards[cardNow]);
                },
                child: Text("Nie Wiem")),
            ElevatedButton(
                onPressed: () {
                  whenUserKnow(cards[cardNow]);
                },
                child: Text("Wiem"))
          ],
        )
      ]),
    );
  }

  void whenUserKnow(FlashcardElement card) {
    cardKnown.add(card);
    if (cardNow == cards.length - 2) {
      Navigator.of(context)
        ..pop()
        ..push(MaterialPageRoute(builder: (context) => FlashcardSummary()));
      return;
    }
    setState(() {
      cardNow++;
    });
  }

  void whenUserDontKnow(FlashcardElement card) {
    cardDoesntKnown.add(card);
    if (cardNow == cards.length - 2) {
      Navigator.of(context)
        ..pop()
        ..push(MaterialPageRoute(builder: (context) => FlashcardSummary()));
      return;
    }
    setState(() {
      cardNow++;
    });
  }
}
