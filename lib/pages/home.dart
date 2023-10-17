import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:la_fiszki/catalogue.dart';
import 'package:la_fiszki/pages/choose_flashcards.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/flashcards_storage.dart';

// import 'dart:developer' as dev;

class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: constraints.maxHeight / 2,
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/logo.png",
                  width: constraints.maxWidth - 25,
                  height: constraints.maxHeight / 2 - 25,
                  fit: BoxFit.cover,
                ),
              ),
              NewPageButton(
                nextPage: ChooseFlashcards(),
                text: "Otwórz fiszke",
                height: constraints.maxHeight / 3,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                  fixedSize: MaterialStateProperty.all(Size(constraints.maxWidth, constraints.maxHeight / 6)),
                ),
                onPressed: importFlashcardFromFile,
                child: Text("Importuj fiszke", style: TextStyle(fontSize: constraints.maxWidth / 13)),
              )
              // HomePageButton(
              //   nextPage: CreateCardboard(),
              //   text: "Stwórz fiszke"
              // ),
            ],
          ),
        );
      }),
    ));
  }

  void importFlashcardFromFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (result == null) return;

    File filePicked = File(result.files.single.path ?? "");
    if (!await filePicked.exists()) return;

    String fileContent = await filePicked.readAsString();
    if (!Flashcard.isFlashcard(fileContent)) return;
    var flashcardFolderName = await FlashcardsStorage.addNewFlashcard(fileContent);

    var catalogueObject =
        Catalogue.createCatalogueElement(folderName: flashcardFolderName, json: jsonDecode(fileContent));
    await Catalogue.addElement(catalogueObject);
  }
}

class NewPageButton extends StatelessWidget {
  final Widget nextPage;
  final String? text;
  final double? height;
  const NewPageButton({super.key, required this.nextPage, this.height, this.text});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
          // backgroundColor: MaterialStateColor.resolveWith((states) => Theme.of(context).colorScheme.primary),
          // foregroundColor: MaterialStateColor.resolveWith((states) => Theme.of(context).colorScheme.onPrimary),
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
