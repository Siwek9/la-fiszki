import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/routes/study_pages/flashcard_summary.dart';
import 'package:la_fiszki/widgets/choose_button.dart';

// ignore: unused_import
import 'dart:developer' as dev;

class FlashcardsExclusionPage extends StatefulWidget {
  final int firstSide;
  final List<FlashcardElement> cards;
  final String folderName;
  final Flashcard flashcardData;

  const FlashcardsExclusionPage(
      {super.key, required this.cards, required this.folderName, required this.flashcardData, required this.firstSide});

  @override
  State<FlashcardsExclusionPage> createState() => _FlashcardsExclusionPageState();
}

class _FlashcardsExclusionPageState extends State<FlashcardsExclusionPage> {
  _FlashcardsExclusionPageState();
  int cardNow = 0;
  bool sideNow = true;
  // int? randomTranslate;
  List<FlashcardElement> cardKnown = List<FlashcardElement>.empty(growable: true);
  List<FlashcardElement> cardDoesntKnown = List<FlashcardElement>.empty(growable: true);

  List<String> sideContent(String side) {
    if (side == "front") {
      if (widget.firstSide == 0) {
        return widget.cards[cardNow].frontSide;
      } else {
        return widget.cards[cardNow].backSide;
      }
    } else {
      if (widget.firstSide == 0) {
        return widget.cards[cardNow].backSide;
      } else {
        return widget.cards[cardNow].frontSide;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // randomTranslate = randomTranslate ?? Random().nextInt(sideContent("front").length);
    return WillPopScope(
      onWillPop: () => preventFromLosingProgress(context),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("${cardNow + 1}/${widget.cards.length}"),
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
                  child: Stack(
                    children: [
                      Card(
                        color: Theme.of(context).colorScheme.primary,
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Center(
                            child: AutoSizeText(
                              sideNow
                                  ? sideContent("front")[Random().nextInt(sideContent("front").length)]
                                  : sideContent("back").join('/\n'),
                              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontSize: Theme.of(context).textTheme.displayMedium!.fontSize!),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        top: 25,
                        child: Text(
                          (sideNow ^ (widget.firstSide == 1))
                              ? widget.flashcardData.frontSideName
                              : widget.flashcardData.backSideName,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
                ChooseButton(
                  text: "Wiem",
                  color: WidgetStatePropertyAll(Colors.green),
                  constraints: constraints,
                  onPressed: () {
                    whenUserKnow(widget.cards[cardNow]);
                  },
                ),
                ChooseButton(
                  text: "Nie wiem",
                  color: WidgetStatePropertyAll(Colors.red),
                  constraints: constraints,
                  onPressed: () {
                    whenUserDontKnow(widget.cards[cardNow]);
                  },
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
        ..push(
          MaterialPageRoute(
            builder: (context) => FlashcardSummary(
              folderName: widget.folderName,
              knownFlashcards: cardKnown,
              dontKnownFlashcards: cardDoesntKnown,
              flashcardData: widget.flashcardData,
              firstSide: widget.firstSide,
              mode: "exclusion",
            ),
          ),
        );
      return;
    }
    setState(() {
      cardNow++;
      //randomTranslate = Random().nextInt(sideContent("front").length);
      sideNow = true;
    });
  }

  void whenUserDontKnow(FlashcardElement card) {
    cardDoesntKnown.add(card);
    if (cardNow == widget.cards.length - 1) {
      Navigator.of(context)
        ..pop()
        ..push(
          MaterialPageRoute(
            builder: (context) => FlashcardSummary(
              folderName: widget.folderName,
              knownFlashcards: cardKnown,
              dontKnownFlashcards: cardDoesntKnown,
              flashcardData: widget.flashcardData,
              firstSide: widget.firstSide,
              mode: "exclusion",
            ),
          ),
        );
      return;
    }
    setState(() {
      cardNow++;
      sideNow = true;
    });
  }
}
