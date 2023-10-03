import 'dart:developer';
import 'dart:io';
import 'package:la_fiszki/flashcard.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FlashcardsStorage {
  static Future<List<String>> getFlashcardsNameList() async {
    var flashcardsDirectory = await getFlashcardsMainDirectory();

    if (!await flashcardsDirectory.exists()) {
      flashcardsDirectory = await flashcardsDirectory.create(recursive: true);
    }
    var flashcardsFileSystemEntityList = flashcardsDirectory.listSync().toList(growable: false);

    var flashcardsName = flashcardsFileSystemEntityList.map((e) {
      return basenameWithoutExtension(e.path);
    }).toList();

    log(flashcardsName.toString());

    return flashcardsName;
  }

  static Future<Flashcard> getFlashcardByName(String name) async {
    return Flashcard("temp");
  }

  static Future<Directory> getFlashcardsMainDirectory() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    return Directory("${documentDirectory.path}/la_fiszki/flashcards/");
  }

  static Future<File> getCatalogue() async {
    var flashcardsPath = (await getFlashcardsMainDirectory()).path;
    return File("${flashcardsPath}catalogue.json");
  }
}
