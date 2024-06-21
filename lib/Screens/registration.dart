import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nokosu2023/Components/SubComponents/error_field.dart';
import 'package:nokosu2023/Components/SubComponents/neumorphism.dart';
import 'package:nokosu2023/Components/button_submit.dart';
import 'package:nokosu2023/Components/dropdown_l10n.dart';
import 'package:nokosu2023/Components/input_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nokosu2023/Components/loading_overlay.dart';
import 'package:nokosu2023/api/api.dart';
import 'package:nokosu2023/models/models.dart';
import 'package:nokosu2023/providers/form_err_res_provider.dart';
import 'package:nokosu2023/utils/constants.dart';
import 'package:nokosu2023/utils/static_functions.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController password1Controller = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  TextEditingController formErrorController = TextEditingController();
  bool loginSuccess = false;

  final ScrollController _scrollController = ScrollController();

  late AppLocalizations locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    locale = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    final formErrProvider =
        Provider.of<FormErrProvider>(context).userRegResponse;
    return Scaffold(
      appBar: null,
      backgroundColor: ThemeColours.bgBlueWhite,
      body: SingleChildScrollView(
        child: Stack(children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 100,
                ),
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Neumo(
                    child: Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(CustIcons.logo),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: RawScrollbar(
                    controller: _scrollController,
                    thumbColor: ThemeColours.scrollBar,
                    radius: const Radius.circular(50),
                    thickness: 8.5,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16.0),
                      physics: const ClampingScrollPhysics(),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(
                              height: 20,
                            ),
                            InputField(
                              label: locale.username,
                              controller: usernameController,
                              prefixicon: SvgPicture.asset(CustIcons.username),
                              err: formErrProvider.username!.message!,
                            ),
                            InputField(
                              label: locale.email,
                              controller: emailController,
                              prefixicon: SvgPicture.asset(CustIcons.mail),
                              err: formErrProvider.email!.message!,
                            ),
                            InputField(
                              label: locale.firstname,
                              controller: firstNameController,
                              prefixicon: SvgPicture.asset(CustIcons.firstname),
                              err: formErrProvider.first_name!.message!,
                            ),
                            InputField(
                              label: locale.lastname,
                              controller: lastNameController,
                              prefixicon: SvgPicture.asset(CustIcons.lastname),
                              err: formErrProvider.last_name!.message!,
                            ),
                            InputField(
                              label: locale.password,
                              controller: password1Controller,
                              ispasswordField: true,
                              prefixicon: SvgPicture.asset(CustIcons.lock),
                              err: formErrProvider.password1!.message!,
                            ),
                            InputField(
                              label: locale.passwordconf,
                              controller: password2Controller,
                              ispasswordField: true,
                              prefixicon: SvgPicture.asset(CustIcons.lockconf),
                              err: formErrProvider.password2!.message!,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                ErrorField(err: formErrorController.text),
                ButtonSubmit(
                  text: locale.register,
                  onPressed: () async {
                    OverlayEntry overlayEntry = OverlayEntry(
                        builder: (context) => const LoadingOverlay());

                    Overlay.of(context).insert(overlayEntry);

                    if (usernameController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        firstNameController.text.isEmpty ||
                        lastNameController.text.isEmpty ||
                        password1Controller.text.isEmpty ||
                        password2Controller.text.isEmpty) {
                      formErrorController.text = locale.allFieldsRequired;
                    } else {
                      UserReg data = UserReg(
                        username: usernameController.text,
                        email: emailController.text,
                        first_name: firstNameController.text,
                        last_name: lastNameController.text,
                        password1: password1Controller.text,
                        password2: password2Controller.text,
                      );

                      int err = await apiRegister(context, data);

                      if (err == Errors.badreq) {
                        formErrorController.text = locale.errfix;
                      } else if (err == Errors.unAuth) {
                        formErrorController.text = locale.errunauth;
                      } else if (err == Errors.unknown) {
                        formErrorController.text = locale.errcrs;
                      } else {
                        formErrorController.text = "";
                        loginSuccess = true;
                      }
                    }

                    overlayEntry.remove();
                    setState(() {});
                    if (loginSuccess) {
                      // ignore: use_build_context_synchronously
                      RedirectFunctions.redirectHome(context);
                    }
                  },
                ),
                const SizedBox(
                  height: 25,
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
        ]),
      ),
    );
  }
}
