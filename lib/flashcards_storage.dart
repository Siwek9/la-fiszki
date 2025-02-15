import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:la_fiszki/saved_set_data.dart';
import 'package:path_provider/path_provider.dart';

// ignore: unused_import
import 'dart:developer' as dev;

class FlashcardsStorage {
  static Directory? _flashcardStorageDirectory;

  static Future<File> getRawFile(String folderName) async {
    var directory = await getFlashcardsMainDirectory();
    return File("${directory.path}$folderName/raw.json");
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

  static Future<void> deleteFlashcard(String folderName) async {
    var flashcardsMainDir = await getFlashcardsMainDirectory();

    var flashcardFolder = Directory("${flashcardsMainDir.path}$folderName");

    if (await flashcardFolder.exists()) {
      await flashcardFolder.delete(recursive: true);
    }
  }

  static String _randomFolderName() {
    var rand = Random();
    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(20, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  static bool _isSaving = false;

  static Future<void> trySaveProgress(SavedSetData savedData, String folderName) async {
    if (_isSaving) return;

    _isSaving = true;

    print(jsonEncode(savedData));

    var flashcardsMainDir = await getFlashcardsMainDirectory();

    var flashcardSave = File("${flashcardsMainDir.path}$folderName/save.json");

    if (!await flashcardSave.exists()) {
      await flashcardSave.create();
    }

    await flashcardSave.writeAsString(jsonEncode(savedData));

    _isSaving = false;
  }

  static Future<void> saveProgress(SavedSetData savedData, String folderName) async {
    while (_isSaving) {}

    _isSaving = true;

    print(jsonEncode(savedData));

    var flashcardsMainDir = await getFlashcardsMainDirectory();

    var flashcardSave = File("${flashcardsMainDir.path}$folderName/save.json");

    if (!await flashcardSave.exists()) {
      await flashcardSave.create();
    }

    await flashcardSave.writeAsString(jsonEncode(savedData));

    _isSaving = false;
  }

  static Future<void> deleteSave(String folderName) async {
    while (_isSaving) {}

    _isSaving = true;

    print("remove save");

    var flashcardsMainDir = await getFlashcardsMainDirectory();

    var flashcardSave = File("${flashcardsMainDir.path}$folderName/save.json");

    if (await flashcardSave.exists()) {
      await flashcardSave.delete();
    }

    _isSaving = false;
  }
}
