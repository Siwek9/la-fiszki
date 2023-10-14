import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen {
  static Widget wholeScreen(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.horizontalRotatingDots(color: Theme.of(context).colorScheme.primary, size: 150.0),
    );
  }
}
