import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:la_fiszki/catalogue.dart';
import 'package:la_fiszki/widgets/flashcard_select_button.dart';
import 'package:la_fiszki/widgets/loading_screen.dart';

class ListOfSetsPage extends StatefulWidget {
  const ListOfSetsPage({super.key});

  @override
  State<ListOfSetsPage> createState() => _ListOfSetsPageState();
}

class _ListOfSetsPageState extends State<ListOfSetsPage> {
  late Future<List<CatalogueElement>> _getFlashcardsData;
  late GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wybierz fiszkę"),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                if (refreshIndicatorKey != null) refreshIndicatorKey?.currentState?.show();
              },
              child: Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _getFlashcardsData,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
            return FlashcardsLoaded(
              refreshIndicatorKey: refreshIndicatorKey!,
              flashcardsData: snapshot.data!,
              onRefresh: _refreshFlashcard,
              onFlashcardDeleted: _softRefreshFlashcard,
            );
          } else {
            return LoadingScreen();
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getFlashcardsData = Catalogue.getContent();
  }

  Future<void> _refreshFlashcard() async {
    await Catalogue.refreshFile();
    var newFlashcardData = await Catalogue.getContent();

    // refresh indicator looks better when is appearing for longer
    await Future.delayed(Duration(milliseconds: 200));

    setState(() {
      _getFlashcardsData = SynchronousFuture(newFlashcardData);
    });
  }

  Future<void> _softRefreshFlashcard() async {
    var newFlashcardData = await Catalogue.getContent();

    setState(() {
      _getFlashcardsData = SynchronousFuture(newFlashcardData);
    });
  }
}

class FlashcardsLoaded extends StatelessWidget {
  final List<CatalogueElement> flashcardsData;
  final AsyncCallback onRefresh;
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey;
  final AsyncCallback onFlashcardDeleted;

  const FlashcardsLoaded(
      {super.key,
      required this.flashcardsData,
      required this.onRefresh,
      required this.refreshIndicatorKey,
      required this.onFlashcardDeleted});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: onRefresh,
      child: ListView.builder(
          itemCount: flashcardsData.length,
          itemBuilder: (context, index) => FlashcardSelectButton(
                flashcardData: flashcardsData[index],
                onFlashcardDeleted: onFlashcardDeleted,
              )),
    );
  }
}
