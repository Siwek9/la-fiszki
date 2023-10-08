import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen {
  static Widget wholeScreen() {
    return Center(
      child: LoadingAnimationWidget.horizontalRotatingDots(
          color: Colors.blue.shade900, size: 150.0),
    );
  }
}
