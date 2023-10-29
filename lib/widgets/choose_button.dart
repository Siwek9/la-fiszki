import 'package:flutter/material.dart';

class ChooseButton extends StatelessWidget {
  const ChooseButton(
      {super.key, required this.text, required this.color, required this.constraints, required this.onPressed});
  final String text;
  final MaterialStateProperty<Color> color;
  final BoxConstraints constraints;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: constraints.maxHeight / 2,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: color,
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
