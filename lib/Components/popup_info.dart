import 'package:flutter/material.dart';

class PopupInfo extends StatefulWidget {
  final String title;
  final String info;

  const PopupInfo({
    Key? key,
    required this.title,
    required this.info,
  }) : super(key: key);

  @override
  PopupInfoState createState() => PopupInfoState();
}

class PopupInfoState extends State<PopupInfo> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Text(widget.info),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
