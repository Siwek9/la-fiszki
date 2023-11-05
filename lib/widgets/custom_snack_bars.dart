import 'package:flutter/material.dart';

class CustomSnackBars extends SnackBar {
  CustomSnackBars.onError({super.key, required String text})
      : super(content: Text(text), duration: Duration(seconds: 4));
  CustomSnackBars.onSuccess({super.key, required String text})
      : super(content: Text(text), duration: Duration(seconds: 4));

  void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(this);
  }
}

class ScreenMessageModalBottomSheet {
  // showModalBottomSheet
}
