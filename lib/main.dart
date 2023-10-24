import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:la_fiszki/catalogue.dart';
import 'package:la_fiszki/routes/home.dart';
import 'package:la_fiszki/widgets/loading_screen.dart';

// ignore: unused_import
import 'dart:developer' as dev;

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
      ),
      home: initialState(),
      title: 'La Fiszki',
    );
  }

  Widget initialState() {
    return FutureBuilder(future: initData(), builder: initStructure);
  }

  Widget initStructure(context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return Home();
    } else {
      return LoadingScreen.wholeScreen(context);
    }
  }

  Future<void> initData() async {
    File catalogue = await Catalogue.getFile();

    if (!await catalogue.exists()) {
      catalogue = await catalogue.create(recursive: true);

      await Catalogue.refreshFile();
      // await catalogue.writeAsString(jsonEncode(List.empty()));
    }
  }
}
