import 'dart:math';
import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/flashcard_element.dart';
import 'package:la_fiszki/flashcards_storage.dart';
import 'package:la_fiszki/routes/study_pages/flashcards_exclusion_page.dart';
import 'package:la_fiszki/routes/study_pages/flashcards_writing_page.dart';
import 'package:la_fiszki/saved_set_data.dart';
import 'package:la_fiszki/widgets/condition_display.dart';
import 'package:la_fiszki/widgets/flashcard_panel.dart';
import 'package:la_fiszki/widgets/loading_screen.dart';
import 'package:la_fiszki/widgets/prevent_from_losing_progress_dialog.dart';
import 'package:la_fiszki/widgets/summary_extra_button.dart';
import 'package:la_fiszki/widgets/summary_main_button.dart';

// ignore: unused_import
import 'dart:developer' as dev;

class FlashcardSummary extends StatelessWidget {
  // final List<FlashcardElement> knownFlashcards;
  // final List<FlashcardElement> doNotKnownFlashcards;
  final String folderName;
  final Flashcard flashcardData;
  final SavedSetData savedData;
  // final String mode;
  // final int firstSide;

  late final List<FlashcardElement> notKnownFlashcards;
  late final int lastStudiedFlashcardsCount;

  FlashcardSummary({
    super.key,
    // required this.knownFlashcards,
    // required this.doNotKnownFlashcards,
    required this.folderName,
    required this.flashcardData,
    // required this.mode,
    // required this.firstSide,
    required this.savedData,
  }) {
    savedData.currentRound++;

    var notKnownFlashcardsIndexes =
        savedData.dataValues.where((value) => value.maxRound == savedData.currentRound).map((value) => value.id);

    notKnownFlashcards = flashcardData.cards.indexed
        .where((value) => notKnownFlashcardsIndexes.contains(value.$1))
        .map((value) => value.$2)
        .toList();

    lastStudiedFlashcardsCount = savedData.dataValues
        .where((value) => value.maxRound == (savedData.currentRound - 1))
        .map((value) => value.id)
        .length;

    if (notKnownFlashcards.isEmpty) {
      FlashcardsStorage.deleteSave(folderName);
    } else {
      FlashcardsStorage.saveProgress(savedData, folderName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => preventFromLosingProgress(context),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "Gratulacje!",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: Column(
                  children: [
                    FlashcardPanel(
                      height: constraints.maxHeight / 2,
                      centerChild: ConditionDisplay(
                        condition: () => notKnownFlashcards.isEmpty,
                        ifTrue: Text(
                          "Umiesz już wszystko!\nCzy chcesz rozwiązać te fiszki jeszcze raz?",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        ifFalse: Text(
                          "Umiesz ${savedData.dataValues.length - notKnownFlashcards.length} (+ $lastStudiedFlashcardsCount) fiszek!\nPozostało ${notKnownFlashcards.length} do nauki\nCzy kontynuować naukę?",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                    ConditionDisplay(
                      condition: () => notKnownFlashcards.isEmpty,
                      ifTrue: SummaryMainButton(
                        text: "Rozpocznij naukę od początku",
                        width: constraints.maxWidth - 25,
                        height: constraints.maxHeight / 7,
                        onPressed: () => openFlashcardFromStart(context),
                      ),
                      ifFalse: SummaryMainButton(
                        text: "Kontynuuj naukę",
                        width: constraints.maxWidth - 25,
                        height: constraints.maxHeight / 7,
                        onPressed: () => openFlashcardAgain(context),
                      ),
                    ),
                    ConditionDisplay(
                      condition: () => notKnownFlashcards.isEmpty,
                      ifTrue: SummaryExtraButton(
                        height: constraints.maxHeight / 9,
                        width: constraints.maxWidth - 75,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      ifFalse: SummaryExtraButton(
                        height: constraints.maxHeight / 9,
                        width: constraints.maxWidth - 75,
                        onPressed: () {
                          preventFromLosingProgress(context).then(
                            (value) {
                              if (value == true && context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                          );
                        },
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
    Navigator.of(context)
      ..pop()
      ..push(
        MaterialPageRoute(
          builder: (context) {
            if (savedData.isRandom) {
              Random newRandom = Random();

              int randomMaxValue = 1 << 32;
              int seed = newRandom.nextInt(randomMaxValue);
              savedData.seed = seed;
            }
            if (savedData.mode == 0) {
              return FlashcardsExclusionPage(
                folderName: folderName,
                flashcardData: flashcardData,
                savedData: savedData,
              );
            } else {
              return FlashcardsExclusionPage(
                folderName: folderName,
                flashcardData: flashcardData,
                savedData: savedData,
              );
              // FIXME
              // return FlashcardsWritingPage(
              //   folderName: folderName,
              //   cards: shuffleCards,
              //   flashcardData: flashcardData,
              //   firstSide: firstSide,
              //   savedData: SavedSetData(currentRound: 1, isRandom: true, mode: 1, reverseSides: true, dataValues: []),
              // );

              // return FlashcardsExclusionPage(
              //   folderName: folderName,
              //   cards: shuffleCards,
              //   flashcardData: flashcardData,
              //   firstSide: firstSide,
              // );
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
                for (var value in savedData.dataValues) {
                  value.maxRound = 0;
                }
                savedData.currentRound = 0;
                if (savedData.isRandom) {
                  Random newRandom = Random();

                  int randomMaxValue = 1 << 32;
                  int seed = newRandom.nextInt(randomMaxValue);
                  savedData.seed = seed;
                }

                FlashcardsStorage.saveProgress(savedData, folderName);

                if (savedData.mode == 0) {
                  return FlashcardsExclusionPage(
                    folderName: folderName,
                    flashcardData: flashcardData,
                    savedData: savedData,
                  );
                } else {
                  return FlashcardsExclusionPage(
                    folderName: folderName,
                    flashcardData: flashcardData,
                    savedData: savedData,
                  );
                  // FIXME
                  // return FlashcardsWritingPage(
                  //   folderName: folderName,
                  //   flashcardData: flashcardData,
                  //   savedData:
                  //       SavedSetData(currentRound: 1, isRandom: true, mode: 1, reverseSides: true, dataValues: []),
                  // );
                  // return FlashcardsExclusionPage(
                  //   folderName: folderName,
                  //   cards: shuffleCards,
                  //   flashcardData: snapshot.data!,
                  //   firstSide: firstSide,
                  // );
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
        return PreventFromLosingProgressDialog();
      },
    );
    return shouldPop ?? false;
  }
}
