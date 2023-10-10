import 'package:flutter/material.dart';

class FlashcardSummary extends StatelessWidget {
  const FlashcardSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.access_alarms),
          label: Text("siema")),
      appBar: AppBar(),
      persistentFooterButtons: [
        ElevatedButton(onPressed: () {}, child: Text("witam")),
        ElevatedButton(onPressed: () {}, child: Text("witam")),
        ElevatedButton(onPressed: () {}, child: Text("witam")),
        ElevatedButton(onPressed: () {}, child: Text("witam")),
      ],
    );
  }
}
