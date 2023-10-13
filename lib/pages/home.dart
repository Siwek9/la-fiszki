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
          Image.asset("assets/images/logo.png"),
          NewPageButton(nextPage: ChooseFlashcards(), text: "Otwórz fiszke"),
          ElevatedButton(
            onPressed: importFlashcardFromFile,
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.green[800]),
            ),
            child: Text("Importuj fiszke",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  // backgroundColor: Colors.green
                )),
          ),
          // HomePageButton(
          //   nextPage: CreateCardboard(),
          //   text: "Stwórz fiszke"
          // ),
        ],
      ),
    ));
  }

  void importFlashcardFromFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
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
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => nextPage,
            ));
      },
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.green[800]),
      ),
      child: Text(text ?? "",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            // backgroundColor: Colors.green
          )),
    );
  }
}
