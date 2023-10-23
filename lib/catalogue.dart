import 'dart:convert';
import 'dart:io';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/flashcards_storage.dart';

import 'dart:developer' as dev;

import 'package:path/path.dart';

// import 'package:path/path.dart';

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
    dev.log(await catalogue.readAsString());
    var catalogueContent =
        (jsonDecode(await catalogue.readAsString()) as List<dynamic>).map((e) => e as Map<String, dynamic>).toList();
    // var catalogueContent =
    //     jsonDecode(await catalogue.readAsString()) as List<Map<String, dynamic>>? ?? List<Map<String, dynamic>>.empty();
    dev.log(
        catalogueContent.map((catalogueElement) => CatalogueElement.fromJson(catalogueElement)).toList().toString());
    return catalogueContent.map((catalogueElement) => CatalogueElement.fromJson(catalogueElement)).toList();
  }

  static Future<bool> addElement(var element) async {
    var content = await getContent();
    content.add(element);
    var catalogue = await getFile();
    await catalogue.writeAsString(jsonEncode(content));
    return true;
  }

  static bool isCatalogueElement(element) {
    return element is Map<String, dynamic>;
  }

  static Future<void> refreshFile() async {
    var catalogue = await getFile();
    if (await catalogue.exists()) {
      await catalogue.delete();
    }
    List<CatalogueElement> newCatalogueContent = List<CatalogueElement>.empty(growable: true);

    var fileStreamList = await (await FlashcardsStorage.getFlashcardsMainDirectory()).list().toList();
    for (var folder in fileStreamList) {
      File rawFile = File("${folder.path}/raw.json");
      dev.log(rawFile.path);
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
      // if (jsonDecode(fileContent)['name'] == "Zwierzątka") {
      //   await folder.delete(recursive: true);
      // }
    }

    await catalogue.create();
    catalogue.writeAsString(jsonEncode(newCatalogueContent));
    // var fileStreamList = FlashcardsStorage.getFlashcardsMainDirectory().get
  }
}

class CatalogueElement {
  CatalogueElement({required this.folderName, required this.name});
  CatalogueElement.fromJson(Map<String, dynamic> json) {
    folderName = json.keys.first;
    name = json[folderName].toString();
    dev.log("$folderName $name");
  }

  late String folderName;
  late String name;

  Map toJson() => {folderName: name};

  // String author;
}
