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
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: FilledButton(
                style: ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(Size.fromHeight(50)),
                  backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.secondary.withOpacity(1)),
                  foregroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onSecondary),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
