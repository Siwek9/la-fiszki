import 'dart:convert';
import 'dart:io';
import 'package:la_fiszki/flashcards_storage.dart';

// ignore: unused_import
import 'dart:developer' as dev;

class SavedSetData {
  SavedSetData({
    required this.isRandom,
    required this.mode,
    required this.reverseSides,
    required this.currentRound,
    required this.dataValues,
    this.seed,
  });
  bool isRandom;
  int? seed;
  int mode;
  bool reverseSides;
  int currentRound;
  List<SavedFlashcardData> dataValues;

  Map toJson() => <String, dynamic>{
        "isRandom": isRandom,
        "reverseSides": reverseSides,
        "seed": seed,
        "mode": mode,
        "currentRound": currentRound,
        "dataValues": [...dataValues],
      };

  SavedSetData._empty()
      : isRandom = false,
        mode = 0,
        reverseSides = false,
        currentRound = 0,
        dataValues = List<SavedFlashcardData>.empty();

  static bool isSavedSetData(String fileContent) {
    late dynamic content;
    try {
      content = jsonDecode(fileContent);
    } on FormatException {
      return false;
    }

    if (content?['isRandom'] == null ||
        content?['reverseSides'] == null ||
        content?['mode'] == null ||
        content?['currentRound'] == null ||
        (content?['isRandom'] == true && content?['seed'] == null) ||
        content?['dataValues'] == null) return false;

    if (content['dataValues'] is! List) return false;

    if (!content['dataValues'].every((element) => SavedFlashcardData.isSavedFlashcardData(element))) {
      return false;
    }

    return true;
  }

  static Future<SavedSetData?> fromFolderName(String folderName) async {
    SavedSetData? savedSetData = SavedSetData._empty();
    await savedSetData.asyncInit(folderName).catchError((Object error) {
      print(error.toString());
      savedSetData = null;
    });
    return savedSetData;
  }

  Future<void> asyncInit(String folderName) async {
    var directory = await FlashcardsStorage.getFlashcardsMainDirectory();
    directory = Directory("${directory.path}$folderName");
    print("${directory.path}save.json");
    File rawFile = File("${directory.path}/save.json");
    if (!await rawFile.exists()) return Future.error("File do not exists");
    print("-1");
    String fileContent = await rawFile.readAsString();
    if (!SavedSetData.isSavedSetData(fileContent)) {
      return Future.error("File is not set's saved data");
    }

    print("0");

    var jsonObject = jsonDecode(fileContent);
    print("1");
    isRandom = jsonObject['isRandom'];
    print("2");
    reverseSides = jsonObject['reverseSides'];
    print("3");
    mode = jsonObject['mode'];
    print("4");
    seed = jsonObject['seed'];
    print("5");
    currentRound = jsonObject['currentRound'];
    print("6");
    dataValues = (jsonObject['dataValues'] as List<dynamic>)
        .map((value) => SavedFlashcardData(id: value['id'], maxRound: value['maxRound']))
        .toList(growable: false);
    print("7");
  }
}

class SavedFlashcardData {
  SavedFlashcardData({
    required this.id,
    required this.maxRound,
  });
  int id;
  int maxRound;

  static bool isSavedFlashcardData(dynamic fileContent) {
    // late dynamic content;
    // try {
    //   content = jsonDecode(fileContent);
    // } on FormatException {
    //   return false;
    // }

    if (fileContent?['id'] == null || fileContent?['maxRound'] == null) return false;

    return true;
  }

  Map toJson() => <String, dynamic>{
        "id": id,
        "maxRound": maxRound,
      };
}
