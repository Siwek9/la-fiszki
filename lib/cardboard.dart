import 'dart:core';

class Cardboard {
  String name;

  Cardboard(this.name);
}

// class CardboardsStorage {
//   Future<List<Cardboard>> getCardboardsList() async {
//     final path = await _localPath;
//     var cardboardsList = await 

//     return cardboardsList;
//   }

//   Future<String> get _localPath async {
//     final directory = await getApplicationDocumentsDirectory();

//     return directory.path;
//   }

//   Future<File> get _localFile async {
//     final path = await _localPath;
//     return File('$path/counter.txt');
//   }

//   Future<File> add(int counter) async {
//     final file = await _localFile;

//     // Write the file
//     return file.writeAsString('$counter');
//   }
// }