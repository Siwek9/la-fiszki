import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/pages/flashcard_screen.dart';
import 'package:la_fiszki/widgets/loading_screen.dart';

class FlashcardWidget extends StatelessWidget {
  final Future<Flashcard> futureFlashcard;
  final String folderName;
  // late Flashcard content;
  const FlashcardWidget({super.key, required this.folderName, required this.futureFlashcard});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureFlashcard,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            return FlashcardContentWidget(
              content: snapshot.data!,
              folderName: folderName,
            );
          } else {
            return LoadingScreen.wholeScreen();
          }
        });
    // return Scaffold(body: Text(content.name));
  }
}

class FlashcardContentWidget extends StatelessWidget {
  final Flashcard content;
  final String folderName;
  const FlashcardContentWidget({super.key, required this.folderName, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Card(
                child: Column(
                  children: [
                    Text(content.name),
                    Text(content.author),
                    Text(content.frontSideName),
                    Text(content.cards.map((e) => e.backSide).toString())
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FlashcardScreen(
                                  cards: content.cards,
                                  folderName: folderName,
                                )));
                  },
                  child: Text("Rozpocznij naukę"))
            ],
          ),
        ),
      ),
    );
  }
}
