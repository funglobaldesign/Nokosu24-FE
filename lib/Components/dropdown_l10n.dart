import 'package:flutter/material.dart';
import 'package:nokosu2023/Components/SubComponents/neumorphism.dart';
import 'package:nokosu2023/providers/locale_provider.dart';
import 'package:nokosu2023/utils/constants.dart';
import 'package:provider/provider.dart';

class DropdownL10n extends StatefulWidget {
  final bool is3d;
  const DropdownL10n({
    Key? key,
    this.is3d = true,
  }) : super(key: key);

  @override
  DropdownL10nState createState() => DropdownL10nState();
}

class DropdownL10nState extends State<DropdownL10n> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      padding: const EdgeInsets.all(2),
      child: widget.is3d
          ? Neumo(
              child: DropdownButton<Locale>(
                items: const [
                  DropdownMenuItem(
                    value: Locale('en'),
                    child: Text('English'),
                  ),
                  DropdownMenuItem(
                    value: Locale('ja'),
                    child: Text('日本語'),
                  ),
                  DropdownMenuItem(
                    value: Locale('ko'),
                    child: Text('한국어'),
                  ),
                  DropdownMenuItem(
                    value: Locale('zh'),
                    child: Text('中文'),
                  ),
                ],
                onChanged: (newLocale) {
                  Provider.of<LocaleProvider>(context, listen: false)
                      .setLocale(newLocale!);
                },
                value: Provider.of<LocaleProvider>(context).locale,
                underline: Container(),
                dropdownColor: ThemeColours.bgBlueWhite,
                borderRadius: BorderRadius.circular(10.0),
              ),
            )
          : SizedBox(
              child: DropdownButton<Locale>(
                items: const [
                  DropdownMenuItem(
                    value: Locale('en'),
                    child: Text('English'),
                  ),
                  DropdownMenuItem(
                    value: Locale('ja'),
                    child: Text('日本語'),
                  ),
                  DropdownMenuItem(
                    value: Locale('ko'),
                    child: Text('한국어'),
                  ),
                  DropdownMenuItem(
                    value: Locale('zh'),
                    child: Text('中文'),
                  ),
                ],
                onChanged: (newLocale) {
                  Provider.of<LocaleProvider>(context, listen: false)
                      .setLocale(newLocale!);
                },
                value: Provider.of<LocaleProvider>(context).locale,
                underline: Container(),
                dropdownColor: ThemeColours.bgBlueWhite,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
    );
  }
}
