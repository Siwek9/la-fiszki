import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:la_fiszki/catalogue.dart';
import 'package:la_fiszki/routes/list_of_sets_page.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/flashcards_storage.dart';
import 'package:la_fiszki/widgets/buttons.dart';
import 'package:la_fiszki/widgets/screen_message.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: unused_import
import 'dart:developer' as dev;

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeBody(
        importButtonPressed: () => importFlashcardFromFile(
          whenError: (String errorMessage) =>
              ScreenMessage.onError(text: "Wystąpił błąd podczas importowania fiszki ($errorMessage)").show(context),
          whenSuccess: (String flashcardName) =>
              ScreenMessage.onSuccess(text: "Fiszka '$flashcardName' została dodana poprawnie").show(context),
        ),
      ),
    );
  }

  void importFlashcardFromFile(
      {required ValueChanged<String> whenError, required void Function(String) whenSuccess}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (result == null) return;

    File filePicked = File(result.files.single.path ?? "");
    if (!await filePicked.exists()) {
      whenError("Plik nie istnieje");
      return;
    }

    String fileContent = await filePicked.readAsString();
    if (!Flashcard.isFlashcard(fileContent)) {
      whenError("Plik nie jest fiszką");
      return;
    }
    var flashcardFolderName = await FlashcardsStorage.addNewFlashcard(fileContent);

    var catalogueObject =
        Catalogue.createCatalogueElement(folderName: flashcardFolderName, json: jsonDecode(fileContent));
    await Catalogue.addElement(catalogueObject);

    var flashcardName = jsonDecode(fileContent)['name'];
    whenSuccess(flashcardName);
  }
}

class HomeBody extends StatelessWidget {
  final VoidCallback importButtonPressed;

  const HomeBody({super.key, required this.importButtonPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: constraints.maxHeight / 2 - 50,
                  alignment: Alignment.center,
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Image.asset(
                      "assets/images/logo.png",
                      width: constraints.maxWidth - 25,
                      height: constraints.maxHeight - 25,
                      fit: BoxFit.cover,
                    );
                  }),
                ),
                SizedBox(
                    height: 50,
                    width: constraints.maxWidth,
                    child: FilledButton(
                      onPressed: () async {
                        final url = Uri.parse('https:siwek9.github.io/la-fiszki-website');
                        if (await canLaunchUrl(url)) {
                          launchUrl(url, mode: LaunchMode.externalApplication);
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.secondary),
                          foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onSecondary),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.zero))),
                      child: Text("Stwórz fiszkę (Strona Internetowa)"),
                    )),
                // Text("Stwórz fiszke"),
                NewPageButton(
                  nextPage: ListOfSetsPage(),
                  text: "Otwórz fiszke",
                  height: constraints.maxHeight / 3,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                    fixedSize: MaterialStateProperty.all(Size(constraints.maxWidth, constraints.maxHeight / 6)),
                  ),
                  onPressed: importButtonPressed,
                  child: Text("Importuj fiszke", style: TextStyle(fontSize: constraints.maxWidth / 13)),
                ),
                // HomePageButton(
                //   nextPage: CreateFlashcard(),
                //   text: "Stwórz fiszke"
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
