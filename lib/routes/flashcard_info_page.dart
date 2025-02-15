import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/flashcard_element.dart';
import 'package:la_fiszki/routes/flashcard_main_data.dart';
import 'package:la_fiszki/routes/study_pages/flashcards_writing_page.dart';
import 'package:la_fiszki/routes/study_pages/flashcards_exclusion_page.dart';
import 'package:la_fiszki/saved_set_data.dart';
import 'package:la_fiszki/widgets/floating_action_button_info_page.dart';
import 'package:la_fiszki/widgets/labeled_checkbox.dart';
import 'package:la_fiszki/widgets/loading_screen.dart';
import 'package:la_fiszki/widgets/start_studying_button.dart';

// ignore: unused_import
import 'dart:developer' as dev;

import 'package:la_fiszki/widgets/switch_button.dart';

class FlashcardsInfoPage extends StatelessWidget {
  final Future<(Flashcard, SavedSetData?)> futureFlashcard;
  final String folderName;
  const FlashcardsInfoPage({
    super.key,
    required this.folderName,
    required this.futureFlashcard,
    // required this.saveData,
  });

  @override
  Widget build(BuildContext context) {
    print("seksik");
    return FutureBuilder(
      future: futureFlashcard,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          return FlashcardInfoContent(
            content: snapshot.data!.$1,
            folderName: folderName,
            saveData: snapshot.data!.$2,
          );
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}

class FlashcardInfoContent extends StatefulWidget {
  final Flashcard content;
  final String folderName;
  final SavedSetData? saveData;

  const FlashcardInfoContent({
    super.key,
    required this.folderName,
    required this.content,
    required this.saveData,
  });

  @override
  State<FlashcardInfoContent> createState() => _FlashcardInfoContentState();
}

class _FlashcardInfoContentState extends State<FlashcardInfoContent> {
  int side = 0;
  FlashcardMode mode = FlashcardMode.choosing;
  bool randomOrder = true;

  late SavedSetData? saveData;

  @override
  void initState() {
    super.initState();
    saveData = widget.saveData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButtonInfoPage(
        distance: 84,
        children: _createStartButtons(),
      ),
      appBar: AppBar(
        title: Text(widget.content.name),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              child: Icon(Icons.settings),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: ListView(
          children: [
            FlashcardMainData(
              content: widget.content,
            ),
            LabeledCheckbox(
              label: "Losowa kolejność fiszek:",
              value: randomOrder,
              onChanged: (value) => setState(() {
                randomOrder = value;
              }),
            ),
            SwitchButton(
              title: "Wyświetl jako pierwsze:",
              buttons: [
                widget.content.frontSideName,
                widget.content.backSideName,
              ],
              onSelected: (sideIndex) {
                side = sideIndex;
              },
            ),
            SwitchButton(
              title: "Wybierz rodzaj nauki:",
              buttons: [
                "Wybieranie",
                "Pisanie",
              ],
              onSelected: (sideIndex) {
                switch (sideIndex) {
                  case 0:
                    mode = FlashcardMode.choosing;
                    break;
                  case 1:
                    mode = FlashcardMode.writing;
                    break;
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
              child: Text(
                "Lista Fiszek:",
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ...widget.content.cards.map((card) => CompareElements(
                  left: Text(
                    card.frontSide.join("\n"),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                  right: Text(
                    card.backSide.join(" "),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                  compare: Icon(
                    Icons.arrow_forward_sharp,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  List<Widget> _createStartButtons() {
    var toReturn = List<Widget>.empty(growable: true);
    toReturn.add(StartStudyingButton(
      label: Text("Rozpocznij nową lekcje"),
      icon: Icon(
        Icons.add_circle_outline,
      ),
      onPressed: () {
        startNewGame();
        startLearning();
      },
    ));

    if (saveData != null) {
      toReturn.add(StartStudyingButton(
        label: Text("Kontynuuj naukę"),
        icon: Icon(
          Icons.add_circle_outline,
        ),
        onPressed: () async {
          await loadSavedData();
          startLearning();
        },
      ));
    }
    return toReturn;
  }

  void startLearning() {
    if (saveData == null) {
      startNewGame();
    }

    switch (mode) {
      case FlashcardMode.choosing:
        openExclusionPage(context);
        break;
      case FlashcardMode.writing:
        openWritingPage(context);
        break;
    }
  }

  void startNewGame() {
    saveData = SavedSetData(
      isRandom: randomOrder,
      mode: mode.index,
      reverseSides: side == 2 ? true : false,
      currentRound: 0,
      dataValues: List.generate(widget.content.cards.length, (index) => SavedFlashcardData(id: index, maxRound: 0)),
    );
    if (saveData!.isRandom) {
      Random newRandom = Random();

      int randomMaxValue = 1 << 32;
      int seed = newRandom.nextInt(randomMaxValue);
      saveData!.seed = seed;
    }
    print(jsonEncode(saveData));
  }

  Future<void> loadSavedData() async {
    saveData = saveData ?? await SavedSetData.fromFolderName(widget.folderName);
  }

  void openExclusionPage(BuildContext context) {
    Random random = Random();

    var cardsToSend = List<FlashcardElement>.from(widget.content.cards);
    if (randomOrder) {
      cardsToSend.shuffle(random);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardsExclusionPage(
          flashcardData: widget.content,
          folderName: widget.folderName,
          savedData: saveData!,
          // cards: cardsToSend,
          // firstSide: side,
        ),
      ),
    );
  }

  void openWritingPage(BuildContext context) {
    Random random = Random();
    var cardsToSend = List<FlashcardElement>.from(widget.content.cards);
    if (randomOrder) {
      cardsToSend.shuffle(random);
    }

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => FlashcardsWritingPage(
    //       flashcardData: widget.content,
    //       cards: cardsToSend,
    //       folderName: widget.folderName,
    //       firstSide: side,
    //     ),
    //   ),
    // );
  }
}

enum FlashcardMode {
  choosing,
  writing,
}
