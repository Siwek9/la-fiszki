import 'dart:convert';
import 'dart:io';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/flashcards_storage.dart';
import 'package:path/path.dart';

// ignore: unused_import
import 'dart:developer' as dev;

class Catalogue {
  static Future<File> getFile() async {
    var flashcardsPath = (await FlashcardsStorage.getFlashcardsMainDirectory()).path;
    return File("${flashcardsPath}catalogue.json");
  }

  static CatalogueElement createCatalogueElement({required String folderName, required var json}) {
    return CatalogueElement(folderName: folderName, name: json['name'] ?? "");
  }

  static Future<List<CatalogueElement>> getContent() async {
    var catalogue = await getFile();
    var catalogueContent =
        (jsonDecode(await catalogue.readAsString()) as List<dynamic>).map((e) => e as Map<String, dynamic>).toList();
    return catalogueContent.map((catalogueElement) => CatalogueElement.fromJson(catalogueElement)).toList();
  }

  static Future<bool> addElement(CatalogueElement element) async {
    var content = await getContent();
    content.add(element);
    var catalogue = await getFile();
    await catalogue.writeAsString(jsonEncode(content));
    return true;
  }

  // TODO add usecases for this function
  static bool isJsonCatalogueElement(element) {
    if (!element is Map<String, dynamic>) return false;

    var elementTyped = element as Map<String, dynamic>;
    if (elementTyped.keys.length != 1) return false;
    if (elementTyped[elementTyped.keys.first]['name'] == null) return false;

    return true;
  }

  static Future<void> refreshFile() async {
    var catalogue = await getFile();
    if (await catalogue.exists()) {
      await catalogue.delete();
    }
    List<CatalogueElement> newCatalogueContent = List<CatalogueElement>.empty(growable: true);

    var fileStreamList = await (await FlashcardsStorage.getFlashcardsMainDirectory()).list().toList();
    for (var folder in fileStreamList) {
      File rawFile = await FlashcardsStorage.getRawFile(basename(folder.path));

      if (!await rawFile.exists()) {
        folder.delete(recursive: true);
        continue;
      }
      String fileContent = await rawFile.readAsString();
      if (!Flashcard.isFlashcard(fileContent)) {
        folder.delete(recursive: true);
        continue;
      }
      newCatalogueContent
          .add(CatalogueElement(folderName: basename(folder.path), name: jsonDecode(fileContent)['name'] ?? ""));
    }

    await catalogue.create();
    catalogue.writeAsString(jsonEncode(newCatalogueContent));
  }
}

class CatalogueElement {
  CatalogueElement({required this.folderName, required this.name});
  CatalogueElement.fromJson(Map<String, dynamic> json) {
    folderName = json.keys.first;
    name = json[folderName].toString();
  }

  late String folderName;
  late String name;

  Map toJson() => {folderName: name};
}
