import 'package:flutter/material.dart';

class ScreenMessage {
  static SnackBar error(BuildContext context) {
    return SnackBar(duration: Duration(), content: Text("error message"));
  }
}
