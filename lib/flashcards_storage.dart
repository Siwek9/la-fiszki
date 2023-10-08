import 'dart:developer' as dev;
import 'dart:io';
import 'package:la_fiszki/catalogue.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FlashcardsStorage {
  static Directory? _flashcardStorageDirectory;

  static Future<List<CatalogueElement>> getFlashcardsDataList() async {
    var flashcardsDirectory = await getFlashcardsMainDirectory();
    if (!await flashcardsDirectory.exists()) {
      flashcardsDirectory = await flashcardsDirectory.create(recursive: true);
    }
    var flashcardsFileSystemEntityList =
        flashcardsDirectory.listSync().toList(growable: false);

    List<dynamic> catalogueContent = await Catalogue.getContent();

    var flashcardsDirectories = flashcardsFileSystemEntityList
        .where((flashcardFile) => catalogueContent.any((element) =>
            // Catalogue.isCatalogueElement(element) &&
            element.keys.contains(basename(flashcardFile.path))));

    // String directoryName;
    var flashcardsData = flashcardsDirectories
        .map((e) => CatalogueElement(
            name: catalogueContent.firstWhere((content) =>
                    content.keys.contains(basename(e.path)))[basename(e.path)]
                ['name'] as String,
            folderName: basename(e.path)))
        .toList();
    dev.log("siema");

    dev.log(flashcardsData.map((e) => e.name).toString());
    return flashcardsData;
  }

  // static Future<Flashcard> getFlashcardByName(String name) async {
  //   return Flashcard("temp");
  // }

  static Future<Directory> getFlashcardsMainDirectory() async {
    dev.log(_flashcardStorageDirectory?.path ?? "");
    if (_flashcardStorageDirectory != null) {
      return _flashcardStorageDirectory ?? Directory("");
    }

    // bool isFutureDone = false;
    // getApplicationDocumentsDirectory().then((response) => {
    //       flashcardStorageDirectory = Directory("${response.path}la_fiszki/"),
    //       log(flashcardStorageDirectory?.path ?? ""),
    //       isFutureDone = true
    //     });

    // while (!isFutureDone) {}
    var documentDir = await getApplicationDocumentsDirectory();
    _flashcardStorageDirectory =
        Directory("${documentDir.path}/la_fiszki/flashcards/");
    return _flashcardStorageDirectory ?? Directory("");
    //  = documentDirectory;
    // return flashcardStorageDirectory ?? Directory("");
  }
}
