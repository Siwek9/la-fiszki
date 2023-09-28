import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:la_fiszki/pages/choose_flashcards.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/logo.png"),
          HomePageButton(nextPage: ChooseFlashcards(), text: "Otwórz fiszke"),
          ElevatedButton(
            onPressed: importFlashcardFromFile,
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.green[800]),
            ),
            child: Text("Importuj fiszke",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  // backgroundColor: Colors.green
                )),
          ),
          // HomePageButton(
          //   nextPage: CreateCardboard(),
          //   text: "Stwórz fiszke"
          // ),
        ],
      ),
    ));
  }

  void importFlashcardFromFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path ?? "");
      if (file.existsSync()) {
        var directory = await getApplicationDocumentsDirectory();
        var cardboardDirectory =
            Directory('${directory.path}/la_fiszki/flashcards/');
        var res = "";

        if (await cardboardDirectory.exists()) {
          res = cardboardDirectory.path;
        } else {
          final Directory appDocDirNewFolder =
              await cardboardDirectory.create(recursive: true);
          res = appDocDirNewFolder.path;
        }
        final File file2 = File('$res${basename(file.path)}');
        log(file2.path);
        await file2.writeAsString(await file.readAsString());
      }
    } else {
      // User canceled the picker
    }
  }
}

class HomePageButton extends StatelessWidget {
  final Widget nextPage;
  final String? text;
  const HomePageButton({super.key, required this.nextPage, this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => nextPage,
            ));
      },
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.green[800]),
      ),
      child: Text(text ?? "",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            // backgroundColor: Colors.green
          )),
    );
  }
}
