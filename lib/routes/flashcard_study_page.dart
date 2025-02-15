import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/flashcard_element.dart';
import 'package:la_fiszki/flashcards_storage.dart';
import 'package:la_fiszki/routes/flashcard_summary.dart';
import 'package:la_fiszki/saved_set_data.dart';
import 'package:la_fiszki/widgets/prevent_from_losing_progress_dialog.dart';

class FlashcardStudyPage extends StatefulWidget {
  const FlashcardStudyPage({
    super.key,
    required this.folderName,
    required this.flashcardData,
    required this.savedData,
  });

  final String folderName;
  final Flashcard flashcardData;
  final SavedSetData savedData;

  @override
  State<StatefulWidget> createState() => FlashcardStudyPageState();
}

class FlashcardStudyPageState<T extends FlashcardStudyPage> extends State<T> {
  int cardNow = 0;
  bool sideNow = true;

  int numberCardKnown = 0;
  int numberCardNotKnown = 0;

  List<(int, FlashcardElement)> studiedCards = List<(int, FlashcardElement)>.empty(growable: true);

  String get mode {
    return "none";
  }

  @override
  void initState() {
    super.initState();

    print(widget.savedData.dataValues.toString());
    var studiedCardsIndexes = widget.savedData.dataValues
        .where((value) => value.maxRound >= widget.savedData.currentRound)
        .map((value) => value.id);

    print(studiedCardsIndexes.length);

    studiedCards = widget.flashcardData.cards.indexed
        .where((value) => studiedCardsIndexes.contains(value.$1))
        // .map((value) => value.$2)
        .toList();

    if (widget.savedData.isRandom) {
      Random random = Random(widget.savedData.seed!);
      studiedCards.shuffle(random);
    }

    for (var i = 0; i < studiedCards.length; i++) {
      if (widget.savedData.dataValues[studiedCards[i].$1].maxRound == widget.savedData.currentRound) {
        cardNow = i;
        break;
      }
    }

    print(studiedCards.toString());
  }

  @override
  Widget build(BuildContext context, {Widget? child}) {
    return WillPopScope(
      onWillPop: () => preventFromLosingProgress(context),
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("${cardNow + 1}/${studiedCards.length}"),
          ),
          body: child),
    );
  }

  List<String> sideContent(String side) {
    if (side == "front") {
      if (!widget.savedData.reverseSides) {
        return studiedCards[cardNow].$2.frontSide;
      } else {
        return studiedCards[cardNow].$2.backSide;
      }
    } else {
      if (!widget.savedData.reverseSides) {
        return studiedCards[cardNow].$2.backSide;
      } else {
        return studiedCards[cardNow].$2.frontSide;
      }
    }
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

  void whenUserKnow(FlashcardElement card) {
    numberCardKnown++;
    if (cardNow == studiedCards.length - 1) {
      Navigator.of(context)
        ..pop()
        ..push(
          MaterialPageRoute(
            builder: (context) => FlashcardSummary(
              folderName: widget.folderName,
              flashcardData: widget.flashcardData,
              savedData: widget.savedData,
              // knownFlashcards: cardKnown,
              // doNotKnownFlashcards: cardDoesNotKnown,
              // firstSide: 1,
              // mode: mode,
            ),
          ),
        );
      return;
    }
    setState(() {
      cardNow++;
      sideNow = true;
    });

    if ((cardNow - 1) % 5 == 0) {
      FlashcardsStorage.trySaveProgress(widget.savedData, widget.folderName);
    }
  }

  void whenUserDoNotKnow(FlashcardElement card) {
    numberCardNotKnown++;
    widget.savedData.dataValues[studiedCards[cardNow].$1].maxRound++;
    if (cardNow == studiedCards.length - 1) {
      Navigator.of(context)
        ..pop()
        ..push(
          MaterialPageRoute(
            builder: (context) => FlashcardSummary(
              folderName: widget.folderName,
              flashcardData: widget.flashcardData,
              savedData: widget.savedData,
              // knownFlashcards: cardKnown,
              // doNotKnownFlashcards: cardDoesNotKnown,
              // firstSide: 1,
              // mode: mode,
            ),
          ),
        );
      return;
    }
    setState(() {
      cardNow++;
      sideNow = true;
    });

    if ((cardNow - 1) % 5 == 0) {
      FlashcardsStorage.trySaveProgress(widget.savedData, widget.folderName);
    }
  }
}
