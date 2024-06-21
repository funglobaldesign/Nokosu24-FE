import 'package:flutter/material.dart';
import 'package:nokosu2023/Components/SubComponents/neumorphism.dart';
import 'package:nokosu2023/models/models.dart';
import 'package:nokosu2023/utils/constants.dart';
import 'package:nokosu2023/utils/static_functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PreviewPage extends StatefulWidget {
  final Image image;
  final Info info;
  final bool isUpdate;

  const PreviewPage({
    Key? key,
    required this.image,
    required this.info,
    this.isUpdate = false,
  }) : super(key: key);

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late AppLocalizations locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    locale = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: ThemeColours.bgBlueWhite,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.085),
              Container(
                padding: const EdgeInsets.all(7),
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height * 0.65
                        : MediaQuery.of(context).size.width * 1.65,
                width: MediaQuery.of(context).size.width * 0.95,
                decoration: BoxDecoration(
                  color: ThemeColours.bgBlueWhite,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 0,
                    color: Colors.transparent,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      offset: const Offset(-6, -6),
                      color: ThemeColours.shadowDark.withOpacity(0.3),
                    ),
                    BoxShadow(
                      blurRadius: 6,
                      offset: const Offset(6, 6),
                      color: ThemeColours.shadowDark.withOpacity(0.3),
                    )
                  ],
                ),
                child: ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: SizedBox(
                        width: 1,
                        child: widget.image,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                child: Row(
                  mainAxisAlignment: widget.isUpdate
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
                  children: [
                    if (!widget.isUpdate)
                      SizedBox(
                          height: 70,
                          width: 70,
                          child: Neumo(
                              child: IconButton(
                                  color: Colors.red,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: Text(locale.photodel),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(locale.cancel),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();

                                                RedirectFunctions.redirectHome(
                                                    context);
                                              },
                                              child: Text(locale.ok),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.close)))),
                    SizedBox(
                      height: 70,
                      width: 70,
                      child: Neumo(
                        child: IconButton(
                          color: Colors.green,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.check),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
