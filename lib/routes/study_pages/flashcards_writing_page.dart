import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard.dart';
import 'package:la_fiszki/routes/study_pages/flashcard_summary.dart';

// ignore: unused_import
import 'dart:developer' as dev;

import 'package:la_fiszki/widgets/screen_message.dart';

class FlashcardsWritingPage extends StatefulWidget {
  const FlashcardsWritingPage({super.key, required this.cards, required this.folderName, required this.flashcardData});
  final List<FlashcardElement> cards;
  final String folderName;
  final Flashcard flashcardData;

  @override
  State<FlashcardsWritingPage> createState() => _FlashcardsWritingPageState();
}

class _FlashcardsWritingPageState extends State<FlashcardsWritingPage> {
  _FlashcardsWritingPageState();
  int cardNow = 0;
  // bool sideNow = true;
  List<FlashcardElement> cardKnown = List<FlashcardElement>.empty(growable: true);
  List<FlashcardElement> cardDoesntKnown = List<FlashcardElement>.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => preventFromLosingProgress(context),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("$cardNow/${widget.cards.length}"),
        ),
        body: LayoutBuilder(
          builder: (context, BoxConstraints constraints) {
            return Column(
              children: [
                SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight - constraints.maxHeight / 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Theme.of(context).colorScheme.primary,
                      child: Center(
                        child: Flex(
                          direction: Axis.vertical,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.flashcardData.frontSideName,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.onPrimary,
                                      ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  widget.cards[cardNow].frontSide,
                                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                        color: Theme.of(context).colorScheme.onPrimary,
                                      ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  margin: EdgeInsets.all(20),
                                  child: FlashcardTextInputField(
                                    statusValue: FlashcardTextInputStatus.normal,
                                    onSubmit: (value) {
                                      if (value == widget.cards[cardNow].backSide) {
                                        ScreenMessageSnackBar.onSuccess(text: "lol").show(context);

                                        // showModalBottomSheet(
                                        //   // shape: Border.all(),
                                        //   enableDrag: false,
                                        //   useSafeArea: true,
                                        //   context: context,
                                        //   builder: (BuildContext context) {
                                        //     return Container(
                                        //         decoration:
                                        //             BoxDecoration(borderRadius: BorderRadius.zero, color: Colors.white),
                                        //         width: constraints.maxWidth,
                                        //         height: constraints.maxHeight / 2,
                                        //         child: Text("siema"));
                                        //   },
                                        // );
                                        return true;
                                      } else {
                                        ScreenMessageSnackBar.onError(text: "bruh").show(context);
                                        return false;
                                      }
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<bool> preventFromLosingProgress(BuildContext context) async {
    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          title: Text('Wyjście'),
          content: Text('Twoje postępy w tej sesji fiszek nie zostaną zapisane. Czy na pewno chcesz wyjść?'),
          actions: [
            TextButton(
              child: Text('Anuluj'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text('Potwierdź'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
    return shouldPop ?? false;
  }

  void whenUserKnow(FlashcardElement card) {
    cardKnown.add(card);
    if (cardNow == widget.cards.length - 1) {
      Navigator.of(context)
        ..pop()
        ..push(
          MaterialPageRoute(
            builder: (context) => FlashcardSummary(
              folderName: widget.folderName,
              knownFlashcards: cardKnown,
              dontKnownFlashcards: cardDoesntKnown,
              flashcardData: widget.flashcardData,
            ),
          ),
        );
      return;
    }
    setState(() {
      cardNow++;
    });
  }

  void whenUserDontKnow(FlashcardElement card) {
    cardDoesntKnown.add(card);
    if (cardNow == widget.cards.length - 1) {
      Navigator.of(context)
        ..pop()
        ..push(
          MaterialPageRoute(
            builder: (context) => FlashcardSummary(
              folderName: widget.folderName,
              knownFlashcards: cardKnown,
              dontKnownFlashcards: cardDoesntKnown,
              flashcardData: widget.flashcardData,
            ),
          ),
        );
      return;
    }
    setState(() {
      cardNow++;
    });
  }
}

enum FlashcardTextInputStatus { normal, success, error }

class FlashcardTextInputField extends StatefulWidget {
  final bool Function(String) onSubmit;

  final FlashcardTextInputStatus statusValue;

  const FlashcardTextInputField({
    super.key,
    required this.onSubmit,
    required this.statusValue,
  });

  @override
  State<FlashcardTextInputField> createState() => _FlashcardTextInputFieldState();
}

class _FlashcardTextInputFieldState extends State<FlashcardTextInputField> {
  late FocusNode _myFocusNode;
  final ValueNotifier<bool> _myFocusNotifier = ValueNotifier<bool>(false);
  final TextEditingController _myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _myFocusNode = FocusNode();
    _myFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _myFocusNode.removeListener(_onFocusChange);
    _myFocusNode.dispose();
    _myFocusNotifier.dispose();
    _myController.dispose();

    super.dispose();
  }

  void _onFocusChange() {
    _myFocusNotifier.value = _myFocusNode.hasFocus;
  }

  Color setFilledColor(isFocus) {
    if (widget.statusValue == FlashcardTextInputStatus.normal) {
      return isFocus ? Colors.white.withOpacity(0.2) : Colors.transparent;
    } else if (widget.statusValue == FlashcardTextInputStatus.success) {
      return Colors.green.withOpacity(0.2);
    } else {
      return Colors.red.withOpacity(0.2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _myFocusNotifier,
      builder: (context, isFocus, child) {
        return TextField(
          // autocorrect: false,
          controller: _myController,
          onSubmitted: (value) => widget.onSubmit(value),
          focusNode: _myFocusNode,
          autofocus: true,
          enableSuggestions: false,
          keyboardType: TextInputType.emailAddress, // for no autocorrect
          maxLines: 1,
          clipBehavior: Clip.hardEdge,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
          cursorColor: Colors.white,
          cursorOpacityAnimates: true,
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () => widget.onSubmit(_myController.text),
              child: Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                width: 1,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            filled: true,
            fillColor: setFilledColor(isFocus),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7.5),
              borderSide: BorderSide(width: 0, color: Colors.transparent),
            ),
          ),
        );
      },
    );
  }
}
