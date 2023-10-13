import 'package:flutter/material.dart';
import 'package:la_fiszki/catalogue.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/flashcards_storage.dart';
import 'package:la_fiszki/pages/flashcard_widget.dart';
import 'package:la_fiszki/widgets/loading_screen.dart';

class ChooseFlashcards extends StatefulWidget {
  const ChooseFlashcards({super.key});

  @override
  State<ChooseFlashcards> createState() => _ChooseFlashcardsState();
}

class FlashcardSelectButton extends StatelessWidget {
  final CatalogueElement flashcardData;

  const FlashcardSelectButton({super.key, required this.flashcardData});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          moveToFlashCard(context, flashcardData);
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.zero, side: BorderSide(color: Colors.blue.shade600))),
            fixedSize: MaterialStateProperty.all(Size(250.0, 70.0)),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor: MaterialStateProperty.all(Colors.blue),
            foregroundColor: MaterialStateProperty.all(Colors.black)),
        child: Text(flashcardData.name));
  }

  void moveToFlashCard(BuildContext context, CatalogueElement flashcardData) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FlashcardWidget(
                folderName: flashcardData.folderName,
                futureFlashcard: Flashcard.fromFolderName(flashcardData.folderName))));
  }
}

class FlashcardsLoaded extends StatelessWidget {
  final List<CatalogueElement> flashcardsData;
  const FlashcardsLoaded({super.key, required this.flashcardsData});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            Card(
                shadowColor: Colors.black,
                elevation: 20.0,
                margin: EdgeInsets.all(10.0),
                color: Colors.blue.shade300,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                      children: flashcardsData
                          .map((flashcardData) => FlashcardSelectButton(flashcardData: flashcardData))
                          .toList()),
                )),
          ],
        ),
      ),
    );
  }
}

class _ChooseFlashcardsState extends State<ChooseFlashcards> {
  late Future<List<CatalogueElement>> _getFlashcardsData;

  @override
  Widget build(Object context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
            future: _getFlashcardsData,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                return FlashcardsLoaded(
                  flashcardsData: snapshot.data!,
                );
              } else {
                return LoadingScreen.wholeScreen();
              }
            }));
  }

  @override
  void initState() {
    super.initState();
    _getFlashcardsData = FlashcardsStorage.getFlashcardsDataList();
  }
}
