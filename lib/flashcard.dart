import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:la_fiszki/flashcards_storage.dart';

import 'dart:developer' as dev;

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
        cards = List<FlashcardElement>.from({
          FlashcardElement(frontSide: [""], backSide: [""])
        });

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

    if (!content['cardboards'].every((element) => FlashcardElement.isFlashcardElement(element))) {
      return false;
    }

    return true;
  }

  static Future<Flashcard> fromFolderName(String folderName) async {
    var flashcard = Flashcard._empty();
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
    cards = (jsonObject['cardboards'] as List<dynamic>)
        .map((card) => FlashcardElement(frontSide: stringToList(card['front']), backSide: stringToList(card['back'])))
        .toList(growable: false);
  }
}

List<String> stringToList(dynamic element) {
  if (element is String) {
    return [element];
  } else {
    List<String> toReturn = (element as List<dynamic>).map((e) => e as String).toList();
    return toReturn;
  }
}

class FlashcardElement {
  List<String> frontSide;
  List<String> backSide;

  FlashcardElement({required this.frontSide, required this.backSide});

  static bool isFlashcardElement(dynamic element) {
    return element?['front'] != null && element?['back'] != null;
  }
}
