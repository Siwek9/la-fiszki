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
                    color: Theme.of(context).colorScheme.primary,
                    child: Center(
                      child: Text(
                        sideNow ? widget.cards[cardNow].frontSide : widget.cards[cardNow].backSide,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: SizedBox(
                    height: constraints.maxHeight / 2,
                    child: ElevatedButton(
                      onPressed: () {
                        whenUserKnow(widget.cards[cardNow]);
                      },
                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green)),
                      child: Text(
                        "Wiem",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: constraints.maxHeight / 2,
                    child: ElevatedButton(
                      onPressed: () {
                        whenUserDontKnow(widget.cards[cardNow]);
                      },
                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red)),
                      child: Text(
                        "Nie Wiem",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
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
      sideNow = false;
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
      sideNow = false;
    });
  }
}
