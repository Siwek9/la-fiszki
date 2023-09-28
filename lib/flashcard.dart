import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Flashcard {
  String name;

  Flashcard(this.name);
}

class FlashcardsStorage {
  void getFlashcardsNameList() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    var flashcardsDirectory =
        Directory("${documentDirectory.path}/la_fiszki/flashcards/");
    // var cardboardDirectory = Directory(directory.path);
    if (!await flashcardsDirectory.exists()) {
      flashcardsDirectory = await flashcardsDirectory.create(recursive: true);
    }
    List flashcards = await flashcardsDirectory.list();
    // List flashcards = await flashcardsDirectory.list();
    // File file = File('${flashcardsDirectory.path}/siema.json');
    // print(await file.readAsString());
    // dynamic cardboardcontent = json.decoder.convert(await file.readAsString());
    // log(cardboardcontent.toString());
    // log("siema");
  }
}
