import 'dart:io';

class Catalogue {
  // static const file = getFile();

  static Future<File> getFile() async {
    var flashcardsPath = (await getFlashcardsMainDirectory()).path;
    return File("${flashcardsPath}catalogue.json");
  }

  static var createCatalogueElement({required String folderName, required var json}) {
    // String flashcardName = json["name"] ?? "";
    return {
      folderName: {
        'name': json["name"] ?? ""
      }
    }
  }


  static var getContent() async {
    var catalogue = await getFile();
    return jsonDecode(await catalogue.readAsString()) ?? List<dynamic>.empty();
  }

  static bool addElement(var element) async {
    var content = getContent();
    content.add(element);
    var catalogue = await getFile();
    await catalogue.writeAsString(jsonEncode(content));
  }
  

}
