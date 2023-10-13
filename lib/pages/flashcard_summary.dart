import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/pages/flashcard_screen.dart';
import 'package:la_fiszki/widgets/loading_screen.dart';
import 'dart:developer' as dev;

class FlashcardSummary extends StatelessWidget {
  const FlashcardSummary({super.key, required this.knownFlashcards, required this.dontKnownFlashcards, required this.folderName});

  final List<FlashcardElement> knownFlashcards;
  final List<FlashcardElement> dontKnownFlashcards;
  final String folderName;
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
                child: Builder(builder: (context) {
                  if (dontKnownFlashcards.isEmpty) {
                    return Text("Umiesz już wszystko!\nCzy chcesz rozwiązać je jeszcze raz?");
                  } else {
                    // Navigator siema = Navigator.;
                    return Text("Umiesz ${knownFlashcards.length} fiszek!\nPozostało ${dontKnownFlashcards.length} do nauki\nCzy kontynuować naukę?");
                  }
                }),
              ),
              ElevatedButton(onPressed: () {
                if (dontKnownFlashcards.isEmpty) {
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
                                return LoadingScreen.wholeScreen();
                              }
                            })));
                } else {
                  Navigator.of(context)
                    ..pop()
                    ..push(MaterialPageRoute(builder: (context) => FlashcardScreen(folderName: folderName, cards: dontKnownFlashcards)));
                }
              }, child: Builder(builder: (context) {
                if (dontKnownFlashcards.isEmpty) {
                  return Text("Rozpocznij naukę od początku");
                } else {
                  return Text("Kontynuuj naukę");
                }
              })),
              ElevatedButton(
                  onPressed: () {
                    if (dontKnownFlashcards.isNotEmpty) {
                      preventFromLosingProgress(context).then((value) {
                        if (value == true) {
                          Navigator.pop(context);
                        }
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Wróć do menu głównego")),
            ],
          ),
        ),
      )),
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
}
