import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/widgets/loading_screen.dart';

class FlashcardWidget extends StatelessWidget {
  final Future<Flashcard> futureFlashcard;
  // late Flashcard content;
  const FlashcardWidget({super.key, required this.futureFlashcard});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureFlashcard,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return FlashcardContentWidget(content: snapshot.data!);
          } else {
            return LoadingScreen.wholeScreen();
          }
        });
    // return Scaffold(body: Text(content.name));
  }
}

class FlashcardContentWidget extends StatelessWidget {
  final Flashcard content;
  const FlashcardContentWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Card(
          child: Column(
            children: [
              Text(content.name),
              Text(content.author),
              Text(content.frontSideName),
              Text(content.cards.map((e) => e.backSide).toString())
            ],
          ),
        ),
      ),
    );
  }
}
