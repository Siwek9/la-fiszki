import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/pages/flashcard_screen.dart';
import 'package:la_fiszki/widgets/loading_screen.dart';

import 'dart:developer' as dev;

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
            return LoadingScreen.wholeScreen(context);
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
        appBar: AppBar(
          title: Text(content.name),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(onTap: () => startStudying(context), child: Icon(Icons.play_arrow)),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: ListView.builder(
              itemCount: content.cards.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return FlashcardInfo(content: content);
                } else if (index == 1) {
                  return StartStudyingButton(
                    onPressed: () => startStudying(context),
                  );
                } else if (index == 2) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
                    child: Text("Lista Fiszek:",
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(color: Theme.of(context).colorScheme.onBackground, fontWeight: FontWeight.bold)),
                  );
                } else {
                  index -= 3;
                  return CompareElements(
                    left:
                        Text(content.cards[index].frontSide, maxLines: 1, style: Theme.of(context).textTheme.bodyLarge),
                    right:
                        Text(content.cards[index].backSide, maxLines: 1, style: Theme.of(context).textTheme.bodyLarge),
                    compare: Icon(Icons.arrow_forward_sharp),
                  );
                }
              }),
        ));
  }

  void startStudying(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FlashcardScreen(
                  cards: content.cards,
                  folderName: folderName,
                )));
  }
}

class StartStudyingButton extends StatelessWidget {
  const StartStudyingButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 5.0),
        child: ElevatedButton.icon(
          icon: Icon(Icons.play_circle),
          onPressed: onPressed,
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero))),
              backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.secondary),
              foregroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onBackground),
              iconSize: MaterialStatePropertyAll(50),
              padding: MaterialStatePropertyAll(EdgeInsets.all(20))),
          label: Text("Rozpocznij naukę", style: Theme.of(context).textTheme.headlineSmall),
        ));
  }
}

class FlashcardInfo extends StatelessWidget {
  const FlashcardInfo({
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
              style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold)),
          Text(
            content,
            style: Theme.of(context).textTheme.headlineMedium,
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
    // return Flex(
    //   // clipBehavior: Clip.antiAliasWithSaveLayer,
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   direction: Axis.horizontal,
    //   children: [left, compare, right],
    // );
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
    // return ListTile(
    //   title: Icon(Icons.arrow_forward_sharp),

    //   // titleAlignment: ListTileTitleAlignment.center,
    //   leading: Text(content.cards[index].frontSide),
    //   trailing: Text(content.cards[index].backSide),
    //   leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodyLarge,
    // );
  }
}
