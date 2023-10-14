import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            alignment: Alignment.center,
            child: Image.asset("assets/images/logo.png"),
          ),
          NewPageButton(nextPage: ChooseFlashcards(), text: "Otwórz fiszke"),
          ElevatedButton(
            style: ButtonStyle(
              // backgroundColor: MaterialStateColor.resolveWith((states) => Theme.of(context).colorScheme.primary),
              // foregroundColor: MaterialStateColor.resolveWith((states) => Theme.of(context).colorScheme.onPrimary),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
              fixedSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height / 6)),
            ),

            // foregroundColor: MaterialStateColor.resolveWith((states) => Theme.of(context).colorScheme.onTertiary)),
            onPressed: importFlashcardFromFile,
            child: Text("Importuj fiszke", style: TextStyle(fontSize: MediaQuery.of(context).size.width / 13)),
          )
          // HomePageButton(
          //   nextPage: CreateCardboard(),
          //   text: "Stwórz fiszke"
          // ),
        ],
      ),
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
  const NewPageButton({super.key, required this.nextPage, this.text});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
          // backgroundColor: MaterialStateColor.resolveWith((states) => Theme.of(context).colorScheme.primary),
          // foregroundColor: MaterialStateColor.resolveWith((states) => Theme.of(context).colorScheme.onPrimary),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
          fixedSize: MaterialStateProperty.all(
              Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height / 3))),
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
