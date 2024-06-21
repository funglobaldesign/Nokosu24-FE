import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nokosu2023/Components/SubComponents/neumorphism.dart';
import 'package:nokosu2023/Screens/home.dart';
import 'package:nokosu2023/Screens/login.dart';
import 'package:nokosu2023/api/api.dart';
import 'package:nokosu2023/models/models.dart';
import 'package:nokosu2023/providers/form_err_res_provider.dart';
import 'package:nokosu2023/providers/group_provider.dart';
import 'package:nokosu2023/providers/home_state.dart';
import 'package:nokosu2023/providers/info_provider.dart';
import 'package:nokosu2023/providers/locale_provider.dart';
import 'package:nokosu2023/providers/profile_provider.dart';
import 'package:nokosu2023/providers/token_provider.dart';
import 'package:nokosu2023/utils/constants.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Nokosu());
}

class Nokosu extends StatelessWidget {
  Nokosu({Key? key}) : super(key: key);

  final Profile confProfile = Profile();

  Future<void> fetchData() async {
    TokenProvider tkp = TokenProvider();
    int id = await tkp.loadDeviceIdOnly();
    String token = await tkp.loadDeviceTokenOnly();
    confProfile.id = await confirmToken(token, id);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
        ChangeNotifierProvider(create: (context) => FormErrProvider()),
        ChangeNotifierProvider(create: (context) => TokenProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => GroupProvider()),
        ChangeNotifierProvider(create: (context) => GroupsProvider()),
        ChangeNotifierProvider(create: (context) => InfoProvider()),
        ChangeNotifierProvider(create: (context) => InfosProvider()),
        ChangeNotifierProvider(create: (context) => HomeStateProvider()),
      ],
      builder: (context, state) {
        return MaterialApp(
            title: 'Nokosu',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Provider.of<LocaleProvider>(context).locale,
            home: FutureBuilder(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Provider.of<TokenProvider>(context, listen: false)
                        .loadDeviceToken();
                    return confProfile.id == 0
                        ? const LoginPage()
                        : const HomePage();
                  } else {
                    return const CustomSplashScreen();
                  }
                }));
      },
    );
  }
}

class CustomSplashScreen extends StatelessWidget {
  const CustomSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColours.bgBlueWhite,
      body: Center(
        child: SizedBox(
          height: 200,
          width: 200,
          child: Neumo(
            child: SvgPicture.asset(CustIcons.logo),
          ),
        ),
      ),
    );
  }
}
