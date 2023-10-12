import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:developer' as dev;
import 'package:la_fiszki/flashcards_storage.dart';

class Flashcard {
  String name;
  String author;
  String frontSideName;
  String backSideName;
  List<FlashcardElement> cards;

  Flashcard._empty()
      : name = "Unknown",
        author = "Unknown",
        frontSideName = "Default",
        backSideName = "Default",
        cards = List<FlashcardElement>.empty();

  static bool isFlashcard(String fileContent) {
    late dynamic content;
    try {
      content = jsonDecode(fileContent);
    } on FormatException {
      return false;
    }

    if (content?['name'] == null ||
        content?['author'] == null ||
        content?['sideName']['front'] == null ||
        content?['sideName']['back'] == null ||
        content?['cardboards'] == null) return false;

    if (content['cardboards'] is! List) return false;

    if (!content['cardboards']
        .every((element) => FlashcardElement.isFlashcardElement(element))) {
      return false;
    }

    return true;
  }

  static Future<Flashcard> fromFolderName(String folderName) async {
    var flashcard = Flashcard._empty();
    dev.log("siema");
    await flashcard.asyncInit(folderName).catchError((Object error) {
      dev.log(error.toString());
    });
    return flashcard;
  }

  Future<void> asyncInit(String folderName) async {
    var directory = await FlashcardsStorage.getFlashcardsMainDirectory();
    directory = Directory("${directory.path}$folderName");

    File rawFile = File("${directory.path}/raw.json");
    if (!await rawFile.exists()) return Future.error("File not exists");

    String fileContent = await rawFile.readAsString();
    if (!Flashcard.isFlashcard(fileContent)) {
      return Future.error("File is not flashcard");
    }

    var jsonObject = jsonDecode(fileContent);
    name = jsonObject['name'];
    author = jsonObject['author'];
    frontSideName = jsonObject['sideName']['front'];
    backSideName = jsonObject['sideName']['back'];
    dev.log(jsonObject['cardboards'].toString());
    cards = (jsonObject['cardboards'] as List<dynamic>)
        .map((element) => FlashcardElement(
            frontSide: element['front'], backSide: element['back']))
        .toList(growable: false);
  }
}

class FlashcardElement {
  String frontSide;
  String backSide;

  FlashcardElement({required this.frontSide, required this.backSide});

  static bool isFlashcardElement(dynamic element) {
    return element?['front'] != null && element?['back'] != null;
  }
}
