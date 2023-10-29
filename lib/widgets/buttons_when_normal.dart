import 'package:flutter/material.dart';

class ButtonsWhenNormal extends StatelessWidget {
  final void Function() whenHint;

  final void Function() whenDontKnow;

  final void Function() whenSubmit;

  const ButtonsWhenNormal({
    super.key,
    required this.whenHint,
    required this.whenDontKnow,
    required this.whenSubmit,
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
              flex: 1,
              child: FilledButton(
                style: ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(Size.fromHeight(50)),
                  backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.secondary.withOpacity(0.7)),
                  foregroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onSecondary),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                  ),
                ),
                onPressed: whenDontKnow,
                child: OverflowBox(
                  alignment: Alignment.center,
                  maxWidth: double.infinity,
                  child: Text(
                    "Nie wiem",
                    softWrap: false,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: FilledButton(
                style: ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(Size.fromHeight(50)),
                  backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.secondary.withOpacity(0.85)),
                  foregroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onSecondary),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                ),
                onPressed: whenHint,
                child: OverflowBox(
                  alignment: Alignment.center,
                  maxWidth: double.infinity,
                  child: Text(
                    "Podpowiedź",
                    softWrap: false,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: FilledButton(
                style: ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(Size.fromHeight(50)),
                  backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.secondary.withOpacity(1)),
                  foregroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onSecondary),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                  ),
                ),
                onPressed: whenSubmit,
                child: Text("Sprawdź"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
