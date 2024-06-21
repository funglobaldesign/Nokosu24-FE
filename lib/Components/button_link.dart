import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nokosu2023/utils/constants.dart';

class ButtonLink extends StatefulWidget {
  final String textLabel;
  final String textLink;
  final Function onPressed;

  const ButtonLink({
    Key? key,
    required this.textLabel,
    required this.textLink,
    required this.onPressed,
  }) : super(key: key);

  @override
  ButtonLinkState createState() => ButtonLinkState();
}

class ButtonLinkState extends State<ButtonLink> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: RichText(
      text: TextSpan(
        text: widget.textLabel,
        style: const TextStyle(
          color: ThemeColours.txtBlack,
        ),
        children: <TextSpan>[
          const TextSpan(
            text: ' ',
          ),
          TextSpan(
              text: widget.textLink,
              style: const TextStyle(
                color: ThemeColours.txtBlack,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = widget.onPressed as GestureTapCallback?),
        ],
      ),
    ));
  }
}
