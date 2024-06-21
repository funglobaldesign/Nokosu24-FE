import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nokosu2023/Components/SubComponents/error_field.dart';
import 'package:nokosu2023/Components/SubComponents/neumorphism.dart';
import 'package:nokosu2023/Components/button_submit.dart';
import 'package:nokosu2023/Components/dropdown_l10n.dart';
import 'package:nokosu2023/Components/input_field.dart';
import 'package:nokosu2023/Components/loading_overlay.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nokosu2023/api/api.dart';
import 'package:nokosu2023/utils/constants.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController formErrorController = TextEditingController();
  Color txtCol = ThemeColours.txtRed;

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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                  InputField(
                    label: locale.email,
                    controller: emailController,
                    prefixicon: SvgPicture.asset(CustIcons.mail),
                  ),
                  ErrorField(
                    err: formErrorController.text,
                    txtCol: txtCol,
                  ),
                  ButtonSubmit(
                    text: locale.submit,
                    onPressed: () async {
                      if (emailController.text.isNotEmpty) {
                        OverlayEntry overlayEntry = OverlayEntry(
                            builder: (context) => const LoadingOverlay());

                        Overlay.of(context).insert(overlayEntry);

                        int err =
                            await apigetMail(context, emailController.text);

                        if (err == Errors.none) {
                          formErrorController.text = locale.checkemail;
                          txtCol = ThemeColours.txtBlack;
                        } else {
                          formErrorController.text = locale.noemail;
                          txtCol = ThemeColours.txtRed;
                        }
                        setState(() {});

                        overlayEntry.remove();
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const DropdownL10n(),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            const Positioned(
              top: 55,
              left: 25,
              width: 42,
              height: 42,
              child: Neumo(
                child: SizedBox(),
              ),
            ),
            Positioned(
              top: 57,
              left: 27,
              width: 40,
              height: 40,
              child: IconButton(
                icon: const Icon(Icons.arrow_circle_left_outlined),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
