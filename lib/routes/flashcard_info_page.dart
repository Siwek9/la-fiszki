import 'dart:math';
import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/routes/study_pages/flashcards_writing_page.dart';
import 'package:la_fiszki/routes/study_pages/flashcards_exclusion_page.dart';
import 'package:la_fiszki/widgets/loading_screen.dart';

// ignore: unused_import
import 'dart:developer' as dev;

class FlashcardsInfoPage extends StatelessWidget {
  final Future<Flashcard> futureFlashcard;
  final String folderName;
  const FlashcardsInfoPage({super.key, required this.folderName, required this.futureFlashcard});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureFlashcard,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            return FlashcardInfoContent(
              content: snapshot.data!,
              folderName: folderName,
            );
          } else {
            return LoadingScreen.wholeScreen(context);
          }
        });
  }
}

class FlashcardInfoContent extends StatelessWidget {
  final Flashcard content;
  final String folderName;
  const FlashcardInfoContent({super.key, required this.folderName, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(content.name),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(onTap: () => openExclusionPage(context), child: Icon(Icons.play_arrow)),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: ListView.builder(
              itemCount: content.cards.length + 4,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return FlashcardMainData(content: content);
                } else if (index == 1) {
                  return StartStudyingButton(onPressed: () => openExclusionPage(context), modeName: "Wykluczanie");
                } else if (index == 2) {
                  return StartStudyingButton(onPressed: () => openWritingPage(context), modeName: "Pisanie");
                } else if (index == 3) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
                    child: Text("Lista Fiszek:",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(color: Theme.of(context).colorScheme.onBackground, fontWeight: FontWeight.bold)),
                  );
                } else {
                  index -= 4;
                  return CompareElements(
                    left: Text(content.cards[index].frontSide,
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Theme.of(context).colorScheme.onPrimary)),
                    right: Text(content.cards[index].backSide,
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Theme.of(context).colorScheme.onPrimary)),
                    compare: Icon(
                      Icons.arrow_forward_sharp,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  );
                }
              }),
        ));
  }

  void openExclusionPage(BuildContext context) {
    Random random = Random();
    var shuffleCards = List<FlashcardElement>.from(content.cards);
    shuffleCards.shuffle(random);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FlashcardsExclusionPage(
                  flashcardData: content,
                  cards: shuffleCards,
                  folderName: folderName,
                )));
  }

  void openWritingPage(BuildContext context) {
    Random random = Random();
    var shuffleCards = List<FlashcardElement>.from(content.cards);
    shuffleCards.shuffle(random);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FlashcardsWritingPage(
                  flashcardData: content,
                  cards: shuffleCards,
                  folderName: folderName,
                )));
  }
}

class StartStudyingButton extends StatelessWidget {
  final String modeName;

  const StartStudyingButton({super.key, required this.onPressed, required this.modeName});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: ElevatedButton.icon(
          icon: Icon(Icons.play_circle, color: Theme.of(context).colorScheme.onPrimary),
          onPressed: onPressed,
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero))),
              backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.secondary),
              foregroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onBackground),
              iconSize: MaterialStatePropertyAll(50),
              padding: MaterialStatePropertyAll(EdgeInsets.all(20))),
          label: Text("Rozpocznij naukę ($modeName)",
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.headlineSmall!.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
        ));
  }
}

class FlashcardMainData extends StatelessWidget {
  const FlashcardMainData({
    super.key,
    required this.content,
  });

  final Flashcard content;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(vertical: 5.0),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleAndContent(
                  title: "Nazwa Fiszek",
                  content: content.name,
                ),
                TitleAndContent(
                  title: "Autor",
                  content: content.author,
                ),
                TitleAndContent(
                  title: "Ilość Fiszek",
                  content: content.cards.length.toString(),
                ),
                TitleAndContent(
                  title: "Pierwsza Strona",
                  content: content.frontSideName,
                ),
                TitleAndContent(
                  title: "Druga Strona",
                  content: content.backSideName,
                ),
              ],
            )));
  }
}

class TitleAndContent extends StatelessWidget {
  const TitleAndContent({super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title,
              textAlign: TextAlign.left,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold)),
          Text(
            content,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          )
        ],
      ),
    );
  }
}

class CompareElements extends StatelessWidget {
  const CompareElements(
      {super.key, required this.left, required this.right, this.compare = const Icon(Icons.compare_arrows)
      // required this.content,
      });

  // final Flashcard content;

  final Widget left;
  final Widget right;
  final Widget compare;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(child: left),
          Expanded(child: Align(alignment: Alignment.center, child: compare)),
          Expanded(child: Align(alignment: Alignment.centerRight, child: right))
        ],
      ),
    );
  }
}
