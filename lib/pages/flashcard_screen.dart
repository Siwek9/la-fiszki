import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/pages/flashcard_summary.dart';

// import 'dart:developer' as dev;

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
    return WillPopScope(
      onWillPop: () => preventFromLosingProgress(context),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("$cardNow/${widget.cards.length}"),
        ),
        body: LayoutBuilder(builder: (context, BoxConstraints constraints) {
          return Column(children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  sideNow = !sideNow;
                });
              },
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight / 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.green,
                    child: Text(sideNow ? widget.cards[cardNow].frontSide : widget.cards[cardNow].backSide),
                  ),
                ),
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
          ]);
        }),
      ),
    );
  }

  Future<bool> preventFromLosingProgress(BuildContext context) async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Fiszki'),
          content: Text('Postępy w tej sesji fiszek nie zostaną zapisane. Czy na pewno chcesz wyjść?'),
          actions: [
            TextButton(
              child: Text('Anuluj'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text('Potwierdź'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
    return shouldPop ?? false;
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
