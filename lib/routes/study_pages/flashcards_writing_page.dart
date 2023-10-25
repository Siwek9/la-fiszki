import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/routes/study_pages/flashcard_summary.dart';
import 'package:la_fiszki/widgets/buttons.dart';

// ignore: unused_import
import 'dart:developer' as dev;

class FlashcardsWritingPage extends StatefulWidget {
  const FlashcardsWritingPage({super.key, required this.cards, required this.folderName, required this.flashcardData});
  final List<FlashcardElement> cards;
  final String folderName;
  final Flashcard flashcardData;

  @override
  State<FlashcardsWritingPage> createState() => _FlashcardsWritingPageState();
}

class _FlashcardsWritingPageState extends State<FlashcardsWritingPage> {
  _FlashcardsWritingPageState();
  int cardNow = 0;
  bool sideNow = true;
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
                height: constraints.maxHeight - constraints.maxHeight / 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(children: [
                    Card(
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
                    Positioned.fill(
                      top: 25,
                      child: Text(sideNow ? widget.flashcardData.frontSideName : widget.flashcardData.backSideName,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary)),
                    ),
                    // Positioned.fill(
                    //   bottom: 25,
                    //   // left: 25,
                    //   child: TextField(
                    //     decoration: InputDecoration(
                    //       border: OutlineInputBorder(),
                    //       hintText: 'Enter a search term',
                    //     ),
                    //   ),
                    // ),
                  ]),
                ),
              ),
            ),
            // Flex(
            //   direction: Axis.horizontal,
            //   children: [
            //     ChooseButton(
            //         text: "Wiem",
            //         color: MaterialStatePropertyAll(Colors.green),
            //         constraints: constraints,
            //         onPressed: () {
            //           whenUserKnow(widget.cards[cardNow]);
            //         }),
            //     ChooseButton(
            //         text: "Nie wiem",
            //         color: MaterialStatePropertyAll(Colors.red),
            //         constraints: constraints,
            //         onPressed: () {
            //           whenUserDontKnow(widget.cards[cardNow]);
            //         }),
            //   ],
            // )
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Text('Wyjście'),
          content: Text('Twoje postępy w tej sesji fiszek nie zostaną zapisane. Czy na pewno chcesz wyjść?'),
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
                  flashcardData: widget.flashcardData,
                )));
      return;
    }
    setState(() {
      cardNow++;
      sideNow = true;
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
                  flashcardData: widget.flashcardData,
                )));
      return;
    }
    setState(() {
      cardNow++;
      sideNow = true;
    });
  }
}
