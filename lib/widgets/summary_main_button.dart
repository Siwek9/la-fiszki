import 'package:flutter/material.dart';

class SummaryMainButton extends StatelessWidget {
  const SummaryMainButton({
    super.key,
    required this.text,
    required this.width,
    required this.height,
    required this.onPressed,
  });
  final String text;
  final double width;
  final double height;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        height: height,
        width: width,
        child: FilledButton(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ),
      ),
    );
  }
}
