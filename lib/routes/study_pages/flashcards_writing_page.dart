import 'dart:math';

import 'package:flutter/material.dart';
import 'package:la_fiszki/flashcard_element.dart';
import 'package:la_fiszki/routes/flashcard_study_page.dart';
import 'package:la_fiszki/widgets/flashcard_panel.dart';
import 'package:la_fiszki/widgets/flashcard_side_text.dart';
import 'package:la_fiszki/widgets/flashcard_text_content.dart';
import 'package:la_fiszki/widgets/flashcard_text_input_field.dart';
import 'package:la_fiszki/widgets/writing_answer_button_part.dart';
import 'package:la_fiszki/widgets/writing_answer_buttons.dart';

// ignore: unused_import
import 'dart:developer' as dev;

class FlashcardsWritingPage extends FlashcardStudyPage {
  const FlashcardsWritingPage({
    super.key,
    required List<FlashcardElement> cards,
    required super.folderName,
    required super.flashcardData,
    required int firstSide,
    required super.savedData,
  });

  @override
  State createState() => _FlashcardsWritingPageState();
}

class _FlashcardsWritingPageState extends FlashcardStudyPageState<FlashcardsWritingPage> {
  _FlashcardsWritingPageState();

  FlashcardTextInputStatus statusValue = FlashcardTextInputStatus.normal;
  String? oldAnswer;
  String? hintText;
  String? prefixText;
  final TextEditingController _myController = TextEditingController();

  @override
  String get mode {
    return "writing";
  }

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context, {Widget? child}) {
    return super.build(
      context,
      child: LayoutBuilder(builder: (context, BoxConstraints constraints) {
        return Column(
          children: [
            FlashcardPanel(
              height: constraints.maxHeight - constraints.maxHeight / 4,
              topChild:
                  FlashcardSideText(1 == 0 ? widget.flashcardData.frontSideName : widget.flashcardData.backSideName),
              centerChild: FlashcardTextContent(sideContent("front")[Random().nextInt(sideContent("front").length)]),
              bottomChild: FlashcardTextInputField(
                prefixText: prefixText,
                hintText: hintText,
                controller: _myController,
                statusValue: statusValue,
                onSubmit: (value) {
                  if (statusValue == FlashcardTextInputStatus.normal) {
                    if (sideContent("back").contains(((prefixText ?? "") + value))) {
                      setState(() {
                        statusValue = FlashcardTextInputStatus.success;
                      });
                      return true;
                    } else {
                      setState(() {
                        oldAnswer = value;
                        prefixText = null;
                        _myController.text = "";
                        hintText = hintText ?? sideContent("back")[Random().nextInt(sideContent("back").length)];
                        statusValue = FlashcardTextInputStatus.error;
                      });
                      return false;
                    }
                  } else if (statusValue == FlashcardTextInputStatus.error) {
                    if (sideContent("back").contains(value)) {
                      whenUserDoNotKnow(studiedCards[cardNow].$2);
                      return true;
                    } else {
                      return false;
                    }
                  } else {
                    whenUserKnow(studiedCards[cardNow].$2);
                    return true;
                  }
                },
              ),
            ),
            Builder(builder: (context) {
              if (statusValue == FlashcardTextInputStatus.normal) {
                return WritingAnswerButtons(buttons: [
                  WritingAnswerButtonPart(
                    text: "Nie wiem",
                    onPressed: () {
                      setState(() {
                        prefixText = null;
                        _myController.text = "";
                        hintText = sideContent("back")[Random().nextInt(sideContent("back").length)];
                        statusValue = FlashcardTextInputStatus.error;
                      });
                    },
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                    size: 1,
                  ),
                  WritingAnswerButtonPart(
                    text: "Podpowiedź",
                    onPressed: () {
                      setState(() {
                        prefixText = prefixText ??
                            sideContent("back")[Random().nextInt(sideContent("back").length)].characters.first;
                      });
                    },
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.85),
                    size: 1,
                  ),
                  WritingAnswerButtonPart(
                    text: "Sprawdź",
                    onPressed: () {
                      setState(() {
                        if (sideContent("back").contains(((prefixText ?? "") + _myController.text))) {
                          setState(() {
                            statusValue = FlashcardTextInputStatus.success;
                          });
                        } else {
                          setState(() {
                            prefixText = null;
                            oldAnswer = _myController.text;
                            hintText = hintText ?? sideContent("back")[Random().nextInt(sideContent("back").length)];
                            _myController.text = "";
                            statusValue = FlashcardTextInputStatus.error;
                          });
                        }
                      });
                    },
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(1),
                    size: 2,
                  ),
                ]);
              } else if (statusValue == FlashcardTextInputStatus.success) {
                return WritingAnswerButtons(buttons: [
                  WritingAnswerButtonPart(
                    text: "Kontynuuj",
                    onPressed: () {
                      whenUserKnow(studiedCards[cardNow].$2);
                    },
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(1),
                    size: 1,
                  ),
                ]);
              } else {
                return WritingAnswerButtons(buttons: [
                  WritingAnswerButtonPart(
                    text: "Miałem Racje",
                    onPressed: () {
                      if (oldAnswer != null && oldAnswer != "") {
                        setState(() {
                          _myController.text = oldAnswer!;
                          statusValue = FlashcardTextInputStatus.success;
                        });
                      }
                    },
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                    size: 1,
                  ),
                  WritingAnswerButtonPart(
                    text: "Kontynuuj",
                    onPressed: () {
                      if (sideContent("back").contains(((prefixText ?? "") + _myController.text))) {
                        whenUserDoNotKnow(studiedCards[cardNow].$2);
                      }
                    },
                    backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(1),
                    size: 2,
                  ),
                ]);
              }
            })
          ],
        );
      }),
    );
  }
}
