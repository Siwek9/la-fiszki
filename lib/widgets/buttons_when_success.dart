import 'package:flutter/material.dart';

class ButtonsWhenSuccess extends StatelessWidget {
  final void Function() whenContinue;

  const ButtonsWhenSuccess({
    super.key,
    required this.whenContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: PhysicalModel(
        elevation: 16.0,
        color: Colors.transparent,
        shadowColor: Colors.black,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: FilledButton(
                style: ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(Size.fromHeight(60)),
                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.secondary.withValues(alpha: 1)),
                  foregroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.onSecondary),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                  ),
                ),
                onPressed: whenContinue,
                child: Text("Kontynuuj"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
