import 'package:flutter/material.dart';

class NewPageButton extends StatelessWidget {
  final Widget nextPage;
  final String? text;
  final double? height;
  const NewPageButton({super.key, required this.nextPage, this.height, this.text});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: ButtonStyle(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
          fixedSize: WidgetStateProperty.all(Size(MediaQuery.of(context).size.width, height ?? 50))),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => nextPage,
            ));
      },
      child: Text(text ?? "", style: TextStyle(fontSize: MediaQuery.of(context).size.width / 13)),
    );
  }
}
