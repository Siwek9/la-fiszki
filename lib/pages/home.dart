import 'dart:convert';
import 'dart:io';
// import 'dart:js_util';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:la_fiszki/pages/choose_flashcards.dart';
import 'package:la_fiszki/flashcard.dart';

import '../flashcards_storage.dart';

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
          HomePageButton(nextPage: ChooseFlashcards(), text: "Otwórz fiszke"),
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

    // var flashcardObject = jsonDecode(fileContent);

    // var flashcardName = flashcardObject['name'];

    var flashcardsMainDir = await FlashcardsStorage.getFlashcardsMainDirectory();
    var folderName = "";
    late Directory newFlashcardDir;
    do {
      folderName = randomFolderName();
      newFlashcardDir = Directory("${flashcardsMainDir.path}$folderName/");
    } while (await newFlashcardDir.exists());

    File newFlashcardFile = File("${newFlashcardDir.path}raw.json");
    await newFlashcardFile.create(recursive: true);
    fileContent = jsonEncode(flashcardObject); // compress the data
    await newFlashcardFile.writeAsString(fileContent);

    var catalogueObject = Catalogue.getCatalogueElement(folderName: folderName, json: jsonDecode(fileContent));

    await Catalogue.addElement(catalogueObject);
    // var catalogue = await FlashcardsStorage.getCatalogue();

    // List<dynamic> catalogueJsonObject = jsonDecode(await catalogue.readAsString()) ?? List<dynamic>.empty();
    // catalogueJsonObject.add(catalogueObject);
    // await catalogue.writeAsString(jsonEncode(catalogueJsonObject));
    dev.log("nice");
  }

  String randomFolderName() {
    var rand = Random();
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(20, (index) => chars[rand.nextInt(chars.length)]).join();
  }
}

class HomePageButton extends StatelessWidget {
  final Widget nextPage;
  final String? text;
  const HomePageButton({super.key, required this.nextPage, this.text});

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
