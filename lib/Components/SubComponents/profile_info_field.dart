import 'package:flutter/material.dart';
import 'package:nokosu2023/utils/constants.dart';

class InfoField extends StatefulWidget {
  final String txt1;
  final String txt2;

  const InfoField({
    Key? key,
    required this.txt1,
    required this.txt2,
  }) : super(key: key);

  @override
  InfoFieldState createState() => InfoFieldState();
}

class InfoFieldState extends State<InfoField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          '${widget.txt1} : ${widget.txt2}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: ThemeColours.txtBlack,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
