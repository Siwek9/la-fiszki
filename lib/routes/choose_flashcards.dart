import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:la_fiszki/catalogue.dart';
import 'package:la_fiszki/widgets/buttons.dart';
import 'package:la_fiszki/widgets/loading_screen.dart';
// import 'package:la_fiszki/flashcard.dart';
// import 'package:la_fiszki/routes/flashcard_widget.dart';
// import 'package:la_fiszki/flashcards_storage.dart';

class ChooseFlashcards extends StatefulWidget {
  const ChooseFlashcards({super.key});

  @override
  State<ChooseFlashcards> createState() => _ChooseFlashcardsState();
}

class FlashcardsLoaded extends StatelessWidget {
  final List<CatalogueElement> flashcardsData;
  final AsyncCallback onRefresh;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  const FlashcardsLoaded(
      {super.key, required this.flashcardsData, required this.onRefresh, required this.refreshIndicatorKey});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: onRefresh,
      child: ListView.builder(
          itemCount: flashcardsData.length,
          itemBuilder: (context, index) => FlashcardSelectButton(flashcardData: flashcardsData[index])),
    );
  }
}

class _ChooseFlashcardsState extends State<ChooseFlashcards> {
  late Future<List<CatalogueElement>> _getFlashcardsData;
  late GlobalKey<RefreshIndicatorState> refreshIndicator;

  @override
  Widget build(Object context) {
    return Scaffold(
        appBar: AppBar(title: Text("Wybierz fiszkę"), centerTitle: true, actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {
                    refreshIndicator.currentState?.show();
                  },
                  child: Icon(Icons.refresh)))
        ]),
        body: FutureBuilder(
            future: _getFlashcardsData,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                refreshIndicator = GlobalKey<RefreshIndicatorState>();
                return FlashcardsLoaded(
                  refreshIndicatorKey: refreshIndicator,
                  flashcardsData: snapshot.data!,
                  onRefresh: _refreshFlashcard,
                );
              } else {
                return LoadingScreen.wholeScreen(context);
              }
            }));
  }

  @override
  void initState() {
    super.initState();
    _getFlashcardsData = Catalogue.getContent();
  }

  Future<void> _refreshFlashcard() async {
    await Catalogue.refreshFile();
    var newFlashcardData = await Catalogue.getContent();
    setState(() {
      _getFlashcardsData = SynchronousFuture(newFlashcardData);
    });
  }
}
