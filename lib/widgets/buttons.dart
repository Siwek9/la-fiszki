import 'package:flutter/material.dart';
import 'package:la_fiszki/catalogue.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/routes/flashcard_info_page.dart';

class NewPageButton extends StatelessWidget {
  final Widget nextPage;
  final String? text;
  final double? height;
  const NewPageButton({super.key, required this.nextPage, this.height, this.text});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
          fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width, height ?? 50))),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => nextPage,
            ));
      },
      child: Text(text ?? "", style: TextStyle(fontSize: MediaQuery.of(context).size.width / 13)),
    );
  }
}

class FlashcardSelectButton extends StatelessWidget {
  final CatalogueElement flashcardData;

  const FlashcardSelectButton({super.key, required this.flashcardData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.background, width: 2))),
      child: FilledButton(
          onPressed: () {
            moveToFlashCard(context, flashcardData);
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
            fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width, 80.0)),
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
}

class ChooseButton extends StatelessWidget {
  const ChooseButton(
      {super.key, required this.text, required this.color, required this.constraints, required this.onPressed});
  final String text;
  final MaterialStateProperty<Color> color;
  final BoxConstraints constraints;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: constraints.maxHeight / 2,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: color,
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
