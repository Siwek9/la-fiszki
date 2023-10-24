import 'package:flutter/material.dart';

class ScreenMessage extends SnackBar {
  ScreenMessage.error({super.key, required String text}) : super(content: Text(text), duration: Duration(seconds: 4));
  ScreenMessage.success({super.key, required String text}) : super(content: Text(text), duration: Duration(seconds: 4));

  void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(this);
  }
}
