import 'dart:math';
import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/routes/study_pages/flashcards_exclusion_page.dart';
import 'package:la_fiszki/routes/study_pages/flashcards_writing_page.dart';
import 'package:la_fiszki/widgets/loading_screen.dart';

// ignore: unused_import
import 'dart:developer' as dev;

class FlashcardSummary extends StatelessWidget {
  final List<FlashcardElement> knownFlashcards;
  final List<FlashcardElement> dontKnownFlashcards;
  final String folderName;
  final Flashcard flashcardData;
  final String mode;
  final int firstSide;

  const FlashcardSummary({
    super.key,
    required this.knownFlashcards,
    required this.dontKnownFlashcards,
    required this.folderName,
    required this.flashcardData,
    required this.mode,
    required this.firstSide,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => preventFromLosingProgress(context),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text("Gratulacje!",
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight / 2,
                      child: Card(
                        color: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: SummaryDifference(
                            requirement: dontKnownFlashcards.isEmpty,
                            whenFlashcardFinished: Text(
                              "Umiesz już wszystko!\nCzy chcesz rozwiązać te fiszki jeszcze raz?",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            whenFlashcardNotComplete: Text(
                              "Umiesz ${knownFlashcards.length} fiszek!\nPozostało ${dontKnownFlashcards.length} do nauki\nCzy kontynuować naukę?",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SummaryDifference(
                        requirement: dontKnownFlashcards.isEmpty,
                        whenFlashcardFinished: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SizedBox(
                            height: constraints.maxHeight / 7,
                            width: constraints.maxWidth - 25,
                            child: FilledButton(
                              style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                ),
                              ),
                              onPressed: () => openFlashcardFromStart(context),
                              child: Text(
                                "Rozpocznij naukę od początku",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        whenFlashcardNotComplete: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SizedBox(
                            height: constraints.maxHeight / 7,
                            width: constraints.maxWidth - 25,
                            child: FilledButton(
                              style: ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                ),
                              ),
                              onPressed: () => openFlashcardAgain(context),
                              child: Text(
                                "Kontynuuj naukę",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                              ),
                            ),
                          ),
                        )),
                    SummaryDifference(
                      requirement: dontKnownFlashcards.isEmpty,
                      whenFlashcardFinished: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: constraints.maxHeight / 9,
                          width: constraints.maxWidth - 75,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Wróć do menu głównego",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      whenFlashcardNotComplete: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: constraints.maxHeight / 9,
                          width: constraints.maxWidth - 75,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                            onPressed: () {
                              preventFromLosingProgress(context).then(
                                (value) {
                                  if (value == true) {
                                    Navigator.pop(context);
                                  }
                                },
                              );
                            },
                            child: Text(
                              "Wróć do menu głównego",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void openFlashcardAgain(BuildContext context) {
    Random random = Random();
    var shuffleCards = List<FlashcardElement>.from(dontKnownFlashcards);
    shuffleCards.shuffle(random);
    Navigator.of(context)
      ..pop()
      ..push(
        MaterialPageRoute(
          builder: (context) {
            if (mode == "writing") {
              return FlashcardsWritingPage(
                folderName: folderName,
                cards: shuffleCards,
                flashcardData: flashcardData,
                firstSide: firstSide,
              );
            } else {
              return FlashcardsExclusionPage(
                folderName: folderName,
                cards: shuffleCards,
                flashcardData: flashcardData,
                firstSide: firstSide,
              );
            }
          },
        ),
      );
  }

  void openFlashcardFromStart(BuildContext context) {
    Navigator.of(context)
      ..pop()
      ..push(
        MaterialPageRoute(
          builder: (context) => FutureBuilder(
            future: Flashcard.fromFolderName(folderName),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                Random random = Random();
                var shuffleCards = List<FlashcardElement>.from(snapshot.data!.cards);
                shuffleCards.shuffle(random);
                if (mode == "writing") {
                  return FlashcardsWritingPage(
                    folderName: folderName,
                    cards: shuffleCards,
                    flashcardData: snapshot.data!,
                    firstSide: firstSide,
                  );
                } else {
                  return FlashcardsExclusionPage(
                    folderName: folderName,
                    cards: shuffleCards,
                    flashcardData: snapshot.data!,
                    firstSide: firstSide,
                  );
                }
              } else {
                return LoadingScreen();
              }
            },
          ),
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
    return Builder(
      builder: (context) {
        if (requirement) {
          return whenFlashcardFinished;
        } else {
          return whenFlashcardNotComplete;
        }
      },
    );
  }
}
