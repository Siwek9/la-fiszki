import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../flashcards_storage.dart';
import 'flash_card_widget.dart';

class ChooseFlashcards extends StatefulWidget {
  const ChooseFlashcards({super.key});

  @override
  State<ChooseFlashcards> createState() => _ChooseFlashcardsState();
}

class _ChooseFlashcardsState extends State<ChooseFlashcards> {
  late Future<List<String>> _getFlashcardsName;
  late List<String> flashcardsName;

  @override
  void initState() {
    super.initState();

    _getFlashcardsName = FlashcardsStorage.getFlashcardsNameList();
  }

  @override
  Widget build(Object context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
            future: _getFlashcardsName,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return FlashcardsLoaded(
                  flashcardsName: snapshot.data ?? List<String>.empty(),
                );
              } else {
                return LoadingScreen();
              }
            }));
  }
}

class FlashcardsLoaded extends StatelessWidget {
  final List<String> flashcardsName;
  const FlashcardsLoaded({super.key, required this.flashcardsName});

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
                      children: flashcardsName
                          .map((flashcardName) => ElevatedButton(
                              onPressed: () {
                                moveToFlashCard(context, flashcardName);
                              },
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero, side: BorderSide(color: Colors.blue.shade600))),
                                  fixedSize: MaterialStateProperty.all(Size(250.0, 70.0)),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                                  foregroundColor: MaterialStateProperty.all(Colors.black)),
                              child: Text(flashcardName)))
                          .toList()),
                )),
          ],
        ),
      ),
    );
  }

  void moveToFlashCard(BuildContext context, String flashcardName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FlashCardWidget(content: Flashcard("jupi")),
        ));
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.horizontalRotatingDots(color: Colors.blue.shade900, size: 150.0),
    );
  }
}
