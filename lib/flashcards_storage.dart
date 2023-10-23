import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:la_fiszki/catalogue.dart';
import 'package:path_provider/path_provider.dart';

// import 'dart:developer' as dev;

class FlashcardsStorage {
  static Directory? _flashcardStorageDirectory;

  static Future<List<CatalogueElement>> getFlashcardsDataList() async {
    var flashcardsDirectory = await getFlashcardsMainDirectory();
    if (!await flashcardsDirectory.exists()) {
      flashcardsDirectory = await flashcardsDirectory.create(recursive: true);
    }
    // var flashcardsFileSystemEntityList = flashcardsDirectory.listSync().toList(growable: false);

    List<CatalogueElement> catalogueContent = await Catalogue.getContent();

    // var flashcardsDirectories = flashcardsFileSystemEntityList.where((flashcardFile) => catalogueContent
    //     .any((element) => Catalogue.isCatalogueElement(element) && element.folderName == basename(flashcardFile.path)));

    // var flashcardsData = flashcardsDirectories
    //     .map((e) => CatalogueElement(
    //         name: catalogueContent.firstWhere((content) => content.folderName == (basename(e.path))).name,
    //         folderName: basename(e.path)))
    //     .toList();
    return catalogueContent;
  }

  static Future<Directory> getFlashcardsMainDirectory() async {
    if (_flashcardStorageDirectory != null) {
      return _flashcardStorageDirectory ?? Directory("");
    }
    var documentDir = await getApplicationDocumentsDirectory();
    _flashcardStorageDirectory = Directory("${documentDir.path}/la_fiszki/flashcards/");
    return _flashcardStorageDirectory ?? Directory("");
  }

  static Future<String> addNewFlashcard(String fileContent) async {
    var flashcardsMainDir = await getFlashcardsMainDirectory();

    var folderName = "";
    late Directory newFlashcardDir;
    do {
      folderName = _randomFolderName();
      newFlashcardDir = Directory("${flashcardsMainDir.path}$folderName/");
    } while (await newFlashcardDir.exists());

    File newFlashcardFile = File("${newFlashcardDir.path}raw.json");
    await newFlashcardFile.create(recursive: true);
    fileContent = jsonEncode(jsonDecode(fileContent)); // compress the data
    await newFlashcardFile.writeAsString(fileContent);

    return folderName;
  }

  static String _randomFolderName() {
    var rand = Random();
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(20, (index) => chars[rand.nextInt(chars.length)]).join();
  }
}
