import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/pages/flashcard_screen.dart';
import 'package:la_fiszki/widgets/loading_screen.dart';

class FlashcardSummary extends StatelessWidget {
  final List<FlashcardElement> knownFlashcards;

  final List<FlashcardElement> dontKnownFlashcards;
  final String folderName;
  const FlashcardSummary(
      {super.key, required this.knownFlashcards, required this.dontKnownFlashcards, required this.folderName});
  // final List<FlashcardElement> wholeFlashcard;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => preventFromLosingProgress(context),
      child: Scaffold(
          body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Card(
                child: SummaryDifference(
                    requirement: dontKnownFlashcards.isEmpty,
                    whenFlashcardFinished: Text("Umiesz już wszystko!\nCzy chcesz rozwiązać je jeszcze raz?"),
                    whenFlashcardNotComplete: Text(
                        "Umiesz ${knownFlashcards.length} fiszek!\nPozostało ${dontKnownFlashcards.length} do nauki\nCzy kontynuować naukę?")),
              ),
              SummaryDifference(
                  requirement: dontKnownFlashcards.isEmpty,
                  whenFlashcardFinished: ElevatedButton(
                      onPressed: () => openFlashcardFromStart(context), child: Text("Rozpocznij naukę od początku")),
                  whenFlashcardNotComplete:
                      ElevatedButton(onPressed: () => openFlashcardAgain(context), child: Text("Kontynuuj naukę"))),
              SummaryDifference(
                requirement: dontKnownFlashcards.isEmpty,
                whenFlashcardFinished: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Wróć do menu głównego")),
                whenFlashcardNotComplete: ElevatedButton(
                    onPressed: () {
                      preventFromLosingProgress(context).then((value) {
                        if (value == true) {
                          Navigator.pop(context);
                        }
                      });
                    },
                    child: Text("Wróć do menu głównego")),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void openFlashcardAgain(BuildContext context) {
    Navigator.of(context)
      ..pop()
      ..push(
          MaterialPageRoute(builder: (context) => FlashcardScreen(folderName: folderName, cards: dontKnownFlashcards)));
  }

  void openFlashcardFromStart(BuildContext context) {
    Navigator.of(context)
      ..pop()
      ..push(MaterialPageRoute(
          builder: (context) => FutureBuilder(
              future: Flashcard.fromFolderName(folderName),
              builder: (context, snapshot) {
                dev.log("Zmienna: $folderName");
                if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                  return FlashcardScreen(folderName: folderName, cards: snapshot.data!.cards);
                } else {
                  return LoadingScreen.wholeScreen(context);
                }
              })));
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
}

class SummaryDifference extends StatelessWidget {
  final bool requirement;

  final Widget whenFlashcardFinished;
  final Widget whenFlashcardNotComplete;
  const SummaryDifference({
    super.key,
    required this.requirement,
    required this.whenFlashcardFinished,
    required this.whenFlashcardNotComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (requirement) {
        return whenFlashcardFinished;
      } else {
        return whenFlashcardNotComplete;
      }
    });
  }
}
