import 'package:flutter/material.dart';
import 'package:nokosu2023/utils/constants.dart';

class TPage extends StatelessWidget {
  final String img;
  const TPage({
    Key? key,
    required this.img,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColours.bgBlueWhite,
      body: Center(
        child: Image.asset(
          img,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
