import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nokosu2023/Components/SubComponents/neumorphism.dart';
import 'package:nokosu2023/Components/SubComponents/profile_info_field.dart';
import 'package:nokosu2023/Components/button_submit.dart';
import 'package:nokosu2023/Components/dropdown_l10n.dart';
import 'package:nokosu2023/Components/loading_overlay.dart';
import 'package:nokosu2023/api/api.dart';
import 'package:nokosu2023/models/models.dart';
import 'package:nokosu2023/providers/profile_provider.dart';
import 'package:nokosu2023/providers/token_provider.dart';
import 'package:nokosu2023/utils/constants.dart';
import 'package:nokosu2023/utils/static_functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AppLocalizations locale;
  Profile profile = Profile();
  bool profileReady = false;
  late Image pfp;

  Future<void> getProfile() async {
    await apiGetProfile(
        context, Provider.of<TokenProvider>(context, listen: false).id);
  }

  @override
  void initState() {
    getProfile().then((_) async {
      pfp = Image.asset(Imgs.pfp);
      profile = Provider.of<ProfileProvider>(context, listen: false).profile;

      profileReady = true;
      String p =
          // ignore: use_build_context_synchronously
          Provider.of<ProfileProvider>(context, listen: false).profile.url!;

      if (p.isNotEmpty) {
        final response = await http.get(Uri.parse(p));
        if (response.statusCode == 200) {
          final imageData = response.bodyBytes;
          pfp = Image.memory(
            imageData,
            fit: BoxFit.cover,
          );
        }
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    locale = AppLocalizations.of(context)!;
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: null,
        backgroundColor: ThemeColours.bgBlueWhite,
        body: profileReady
            ? Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.1,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: Column(
                          children: [
                            Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.transparent),
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 6,
                                      offset: Offset(-6, -6),
                                      color: ThemeColours.shadowLight,
                                    ),
                                    BoxShadow(
                                      blurRadius: 6,
                                      offset: Offset(6, 6),
                                      color: ThemeColours.shadowDark,
                                    ),
                                  ]),
                              child: ClipOval(child: pfp),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              '${profile.user!.last_name!} ${profile.user!.first_name!}',
                              style: const TextStyle(
                                color: ThemeColours.txtBlack,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              child: Column(
                                children: [
                                  InfoField(
                                      txt1: locale.username,
                                      txt2: profile.user!.username!),
                                  InfoField(
                                      txt1: locale.email,
                                      txt2: profile.user!.email!),
                                  InfoField(
                                      txt1: locale.accstatus,
                                      txt2: profile.user!.is_superuser!
                                          ? locale.admin
                                          : profile.user!.is_staff!
                                              ? locale.staff
                                              : locale.regular),
                                  InfoField(
                                      txt1: locale.djoined,
                                      txt2: DateFormat('yyyy/MM/dd')
                                          .format(profile.user!.date_joined!)),
                                  InfoField(
                                      txt1: locale.lastlogin,
                                      txt2: DateFormat('yyyy/MM/dd HH:mm')
                                          .format(profile.user!.last_login!)),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 50),
                                    height: 120,
                                    width: 120,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        color: ThemeColours.bgBlueWhite,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 6,
                                            offset: Offset(-6, -6),
                                            color: ThemeColours.shadowLight,
                                          ),
                                          BoxShadow(
                                            blurRadius: 6,
                                            offset: Offset(6, 6),
                                            color: ThemeColours.shadowDark,
                                          ),
                                        ]),
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          CustIcons.username,
                                          height: 50,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          locale.editprof,
                                          style: const TextStyle(
                                            color: ThemeColours.txtBlack,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            decoration: TextDecoration.none,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 50),
                                    height: 120,
                                    width: 120,
                                    padding: const EdgeInsets.only(top: 20),
                                    decoration: BoxDecoration(
                                        color: ThemeColours.bgBlueWhite,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [
                                          BoxShadow(
                                            blurRadius: 6,
                                            offset: Offset(-6, -6),
                                            color: ThemeColours.shadowLight,
                                          ),
                                          BoxShadow(
                                            blurRadius: 6,
                                            offset: Offset(6, 6),
                                            color: ThemeColours.shadowDark,
                                          ),
                                        ]),
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          CustIcons.globe,
                                          height: 50,
                                        ),
                                        const DropdownL10n(
                                          is3d: false,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 30),
                            ButtonSubmit(
                              text: locale.logout,
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text(locale.logoutconf),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(locale.no),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            OverlayEntry overlayEntry =
                                                OverlayEntry(
                                                    builder: (context) =>
                                                        const LoadingOverlay());
                                            Overlay.of(context)
                                                .insert(overlayEntry);
                                            int e = await apiLogout(context);
                                            overlayEntry.remove();
                                            if (e == Errors.none) {
                                              // ignore: use_build_context_synchronously
                                              Provider.of<TokenProvider>(
                                                      context,
                                                      listen: false)
                                                  .setToken('', 0);
                                              // ignore: use_build_context_synchronously
                                              RedirectFunctions.redirectLogin(
                                                  context);
                                            } else {
                                              Fluttertoast.showToast(
                                                msg: locale.errcrs,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                    ThemeColours.bgWhite,
                                                textColor: ThemeColours.txtGrey,
                                                fontSize: 16.0,
                                              );
                                            }
                                          },
                                          child: Text(locale.yes),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            const SizedBox(
                              height: 50,
                            )
                          ],
                        )),
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
              )
            : const LoadingOverlay(),
      ),
    );
  }
}
