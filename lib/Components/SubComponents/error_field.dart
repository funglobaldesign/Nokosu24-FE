import 'package:flutter/material.dart';
import 'package:nokosu2023/utils/constants.dart';

class ErrorField extends StatefulWidget {
  final String err;
  final double boxWidth;
  final double boxHeight;
  final Color txtCol;

  const ErrorField(
      {Key? key,
      required this.err,
      this.boxWidth = NumericConsts.defBoxWidth,
      this.boxHeight = NumericConsts.defBoxHeight / 1.3,
      this.txtCol = ThemeColours.txtRed})
      : super(key: key);

  @override
  ErrorFieldState createState() => ErrorFieldState();
}

class ErrorFieldState extends State<ErrorField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.boxWidth,
      height: widget.boxHeight,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          widget.err,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: widget.txtCol,
            fontSize: 10,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
