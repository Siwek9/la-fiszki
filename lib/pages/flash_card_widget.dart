import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';

class FlashCardWidget extends StatelessWidget {
  Flashcard content;
  FlashCardWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text(content.name));
  }
}
