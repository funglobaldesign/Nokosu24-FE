import 'package:flutter/material.dart';

class TutorialPage extends StatelessWidget {
  final Color pageColor;
  final String pageText;

  const TutorialPage({
    Key? key,
    required this.pageColor,
    required this.pageText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: pageColor,
      child: Center(
        child: Text(
          pageText,
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
