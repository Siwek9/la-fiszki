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
          return LoadingScreen();
        }
      },
    );
  }
}

class FlashcardInfoContent extends StatefulWidget {
  final Flashcard content;
  final String folderName;
  const FlashcardInfoContent({super.key, required this.folderName, required this.content});

  @override
  State<FlashcardInfoContent> createState() => _FlashcardInfoContentState();
}

class _FlashcardInfoContentState extends State<FlashcardInfoContent> {
  int side = 0;
  bool randomOrder = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
              child: Text(
                "Wyświetl jako pierwsze:",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            ChooseSide(
              frontSide: widget.content.frontSideName,
              backSide: widget.content.backSideName,
              onSelected: (sideIndex) {
                side = sideIndex;
              },
            ),
            StartStudyingButton(
              onPressed: () => openExclusionPage(context),
              modeName: "Wykluczanie",
            ),
            StartStudyingButton(
              onPressed: () => openWritingPage(context),
              modeName: "Pisanie",
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
          cards: cardsToSend,
          folderName: widget.folderName,
          firstSide: side,
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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardsWritingPage(
          flashcardData: widget.content,
          cards: cardsToSend,
          folderName: widget.folderName,
          firstSide: side,
        ),
      ),
    );
  }
}

class LabeledCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const LabeledCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Checkbox(
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue!);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChooseSide extends StatefulWidget {
  final void Function(int sideIndex) onSelected;
  final String frontSide;
  final String backSide;

  const ChooseSide({
    super.key,
    required this.onSelected,
    required this.frontSide,
    required this.backSide,
  });

  @override
  State<ChooseSide> createState() => _ChooseSideState();
}

class _ChooseSideState extends State<ChooseSide> {
  var selectedSide = [true, false];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: LayoutBuilder(builder: (context, constraints) {
        return ToggleButtons(
          // selectedColor: Colors.red,
          renderBorder: false,
          isSelected: selectedSide,
          onPressed: (index) {
            widget.onSelected(index);
            setState(() {
              if (index == 0) {
                selectedSide = [true, false];
              } else {
                selectedSide = [false, true];
              }
            });
          },
          children: [
            Container(
              decoration: BoxDecoration(
                color:
                    selectedSide[0] ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.onTertiary,
                border: !selectedSide[0]
                    ? Border.all(
                        width: 3.0,
                        color: Theme.of(context).colorScheme.tertiary,
                      )
                    : null,
              ),
              height: constraints.maxHeight,
              width: (constraints.maxWidth / 2),
              child: Center(
                child: Text(
                  widget.frontSide,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: selectedSide[0]
                        ? Theme.of(context).colorScheme.onTertiary
                        : Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color:
                    selectedSide[1] ? Theme.of(context).colorScheme.tertiary : Theme.of(context).colorScheme.onTertiary,
                border: !selectedSide[1]
                    ? Border.all(
                        width: 3.0,
                        color: Theme.of(context).colorScheme.tertiary,
                      )
                    : null,
              ),
              height: constraints.maxHeight,
              width: (constraints.maxWidth / 2),
              child: Center(
                child: Text(
                  widget.backSide,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: selectedSide[1]
                        ? Theme.of(context).colorScheme.onTertiary
                        : Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
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
        icon: Icon(
          Icons.play_circle,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: onPressed,
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.zero))),
          backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary),
          foregroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.onSurface),
          iconSize: WidgetStatePropertyAll(50),
          padding: WidgetStatePropertyAll(EdgeInsets.all(20)),
        ),
        label: Text(
          "Rozpocznij naukę ($modeName)",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
      ),
    );
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
        ),
      ),
    );
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
          Text(
            title,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            content,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ],
      ),
    );
  }
}

class CompareElements extends StatelessWidget {
  const CompareElements(
      {super.key, required this.left, required this.right, this.compare = const Icon(Icons.compare_arrows)});

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
          Expanded(
            child: left,
          ),
          Expanded(
            child: Align(alignment: Alignment.center, child: compare),
          ),
          Expanded(
            child: Align(alignment: Alignment.centerRight, child: right),
          )
        ],
      ),
    );
  }
}
