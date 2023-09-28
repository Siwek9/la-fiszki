import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChooseFlashcards extends StatefulWidget {
  ChooseFlashcards({super.key});

  @override
  State<ChooseFlashcards> createState() => _ChooseFlashcardsState();
}

class _ChooseFlashcardsState extends State<ChooseFlashcards> {
  late Future<List<String>> _getFlashcardsName;
  late List<String> flashcardsName;

  @override
  void initState() {
    super.initState();

    _getFlashcardsName = FlashcardsStorage.getFlashcardsNameList();
  }

  @override
  Widget build(Object context) {
    return Scaffold(
        body: FutureBuilder(
            future: _getFlashcardsName,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SafeArea(
                  child: Center(
                    child: Column(
                        children: (snapshot.data ?? List<String>.empty())
                            .map((e) => Text(e))
                            .toList()),
                  ),
                );
              } else {
                return LoadingAnimationWidget.horizontalRotatingDots(
                    color: Colors.black, size: 200.0);
              }
            }));
  }
}
