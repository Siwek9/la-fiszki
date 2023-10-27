import 'package:flutter/material.dart';

class ScreenMessageSnackBar extends SnackBar {
  ScreenMessageSnackBar.onError({super.key, required String text})
      : super(content: Text(text), duration: Duration(seconds: 4));
  ScreenMessageSnackBar.onSuccess({super.key, required String text})
      : super(content: Text(text), duration: Duration(seconds: 4));

  void show(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(this);
  }
}

class ScreenMessageModalBottomSheet {
  // showModalBottomSheet
}
