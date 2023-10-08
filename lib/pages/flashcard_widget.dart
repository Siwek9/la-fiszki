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
            return Scaffold(
              body: SafeArea(
                child: Card(
                  child: Column(
                    children: [
                      Text(snapshot.data!.name),
                      Text(snapshot.data!.author),
                      Text(snapshot.data!.frontSideName)
                    ],
                  ),
                ),
              ),
            );
          } else {
            return LoadingScreen.wholeScreen();
          }
        });
    // return Scaffold(body: Text(content.name));
  }
}
