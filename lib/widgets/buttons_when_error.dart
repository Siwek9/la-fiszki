import 'package:flutter/material.dart';

class ButtonsWhenError extends StatelessWidget {
  final void Function() whenRewritten;

  final void Function() whenWasRight;

  const ButtonsWhenError({
    super.key,
    required this.whenRewritten,
    required this.whenWasRight,
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
              flex: 1,
              child: FilledButton(
                style: ButtonStyle(
                  fixedSize: MaterialStatePropertyAll(Size.fromHeight(60)),
                  backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.secondary.withOpacity(0.7)),
                  foregroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onSecondary),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        bottomLeft: Radius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                onPressed: whenWasRight,
                child: OverflowBox(
                  alignment: Alignment.center,
                  maxWidth: double.infinity,
                  child: Text(
                    "Miałem racje",
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
                  fixedSize: MaterialStatePropertyAll(Size.fromHeight(60)),
                  backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.secondary.withOpacity(1)),
                  foregroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.onSecondary),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                onPressed: whenRewritten,
                child: Text("Kontynuuj"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
