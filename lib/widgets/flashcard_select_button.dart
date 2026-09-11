import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:la_fiszki/catalogue.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/flashcards_storage.dart';
import 'package:la_fiszki/routes/flashcard_info_page.dart';

// ignore: unused_import
import 'dart:developer' as dev;

class FlashcardSelectButton extends StatelessWidget {
  final CatalogueElement flashcardData;
  final AsyncCallback onFlashcardDeleted;

  const FlashcardSelectButton({super.key, required this.flashcardData, required this.onFlashcardDeleted});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.surface, width: 2))),
      child: FilledButton(
          onPressed: () {
            moveToFlashCard(context, flashcardData);
          },
          onLongPress: () {
            showFlashcardDialog(context);
          },
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            fixedSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width, 80.0)),
          ),
          child: Text(flashcardData.name, style: TextStyle(fontSize: 20))),
    );
  }

  void moveToFlashCard(BuildContext context, CatalogueElement flashcardData) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FlashcardsInfoPage(
                folderName: flashcardData.folderName,
                futureFlashcard: Flashcard.fromFolderName(flashcardData.folderName))));
  }

  void showFlashcardDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
            title: Text(
              flashcardData.name,
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  tileColor: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  contentPadding: EdgeInsets.all(12.0),
                  title: Text("Usuń fiszkę", textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
                  onTap: () {
                    FlashcardsStorage.deleteFlashcard(flashcardData.folderName)
                        .then((_) => Catalogue.deleteElement(flashcardData.folderName))
                        .then((_) => onFlashcardDeleted());
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        });
  }
}
