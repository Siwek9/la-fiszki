import 'dart:convert';
import 'dart:io';
import 'package:la_fiszki/flashcards_storage.dart';

// import 'dart:developer' as dev;

class Catalogue {
  static Future<File> getFile() async {
    var flashcardsPath = (await FlashcardsStorage.getFlashcardsMainDirectory()).path;
    return File("${flashcardsPath}catalogue.json");
  }

  static Map<String, Map<String, dynamic>> createCatalogueElement({required String folderName, required var json}) {
    return {
      folderName: {'name': json["name"] ?? ""}
    };
  }

  static Future<List<dynamic>> getContent() async {
    var catalogue = await getFile();
    return jsonDecode(await catalogue.readAsString()) ?? List<dynamic>.empty();
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
}

class CatalogueElement {
  CatalogueElement({required this.folderName, required this.name});
  String folderName;
  String name;
  // String author;
}
