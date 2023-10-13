import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/pages/flashcard_summary.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key, required this.cards, required this.folderName});
  final List<FlashcardElement> cards;
  final String folderName;

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  _FlashcardScreenState();
  // final List<FlashcardElement> cards;
  int cardNow = 0;
  bool sideNow = false;
  List<FlashcardElement> cardKnown = List<FlashcardElement>.empty(growable: true);
  List<FlashcardElement> cardDoesntKnown = List<FlashcardElement>.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Text("$cardNow/${widget.cards.length}"),
        ElevatedButton(
          onPressed: () {
            setState(() {
              sideNow = !sideNow;
            });
          },
          child: Card(
            child: Text(sideNow ? widget.cards[cardNow].frontSide : widget.cards[cardNow].backSide),
          ),
        ),
        Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  whenUserDontKnow(widget.cards[cardNow]);
                },
                child: Text("Nie Wiem")),
            ElevatedButton(
                onPressed: () {
                  whenUserKnow(widget.cards[cardNow]);
                },
                child: Text("Wiem"))
          ],
        )
      ]),
    );
  }

  void whenUserKnow(FlashcardElement card) {
    cardKnown.add(card);
    if (cardNow == widget.cards.length - 1) {
      Navigator.of(context)
        ..pop()
        ..push(MaterialPageRoute(
            builder: (context) => FlashcardSummary(
                  folderName: widget.folderName,
                  knownFlashcards: cardKnown,
                  dontKnownFlashcards: cardDoesntKnown,
                )));
      return;
    }
    setState(() {
      cardNow++;
    });
  }

  void whenUserDontKnow(FlashcardElement card) {
    cardDoesntKnown.add(card);
    if (cardNow == widget.cards.length - 1) {
      Navigator.of(context)
        ..pop()
        ..push(MaterialPageRoute(
            builder: (context) => FlashcardSummary(
                  folderName: widget.folderName,
                  knownFlashcards: cardKnown,
                  dontKnownFlashcards: cardDoesntKnown,
                )));
      return;
    }
    setState(() {
      cardNow++;
    });
  }
}
