import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:la_fiszki/catalogue.dart';
import 'package:la_fiszki/pages/home.dart';
// import 'package:la_fiszki/flashcards_storage.dart';

// import 'dart:developer' as dev;

void main() {
  runApp(const LaFiszki());
}

class LaFiszki extends StatelessWidget {
  const LaFiszki({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.light),
      ),
      home: FutureBuilder(
          future: initApp(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Home();
            } else {
              return Scaffold(body: Text("ERROR 1"));
            }
          })),
      title: 'La Fiszki',
    );
  }

  Future<void> initApp() async {
    // var flashcardsDir = await FlashcardsStorage.getFlashcardsMainDirectory();
    File catalogue = await Catalogue.getFile();

    // TODO Remove before release
    // await catalogue.delete();
    // await flashcardsDir.delete(recursive: true);
    // dev.log("[initApp()]: ${await catalogue.readAsString()}");

    if (!await catalogue.exists()) {
      // dev.log("[initApp()]: " "katalog nie istnieje");
      catalogue = await catalogue.create(recursive: true);

      // TODO Read folders with flashcards and save them in the catalogue
      await catalogue.writeAsString(jsonEncode(List.empty()));

      // dev.log("[initApp()]: ${await catalogue.readAsString()}");
      // dev.log("[initApp()]: ${(await flashcardsDir.list().toList()).map((e) => e.path)}");
    }
  }
}
