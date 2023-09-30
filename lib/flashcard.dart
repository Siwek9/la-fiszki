import 'dart:core';
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Flashcard {
  String name;

  Flashcard(this.name);

  static bool isFlashcard(String name) {
    return true;
  }
}

class FlashcardsStorage {
  static Future<List<String>> getFlashcardsNameList() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    var flashcardsDirectory =
        Directory("${documentDirectory.path}/la_fiszki/flashcards/");

    log(flashcardsDirectory.path);
    if (!await flashcardsDirectory.exists()) {
      flashcardsDirectory = await flashcardsDirectory.create(recursive: true);
    }
    var flashcardsFileSystemEntityList =
        flashcardsDirectory.listSync().toList(growable: false);

    var flashcardsName = flashcardsFileSystemEntityList.map((e) {
      return basenameWithoutExtension(e.path);
    }).toList();

    log(flashcardsName.toString());

    return flashcardsName;
  }

  static Future<Flashcard> getFlashcardByName(String name) async {
    return Flashcard("temp");
  }
}
