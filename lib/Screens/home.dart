import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nokosu2023/Components/bar_bottom.dart';
import 'package:nokosu2023/Components/camera.dart';
import 'package:nokosu2023/Components/bar_top.dart';
import 'package:nokosu2023/Components/loading_overlay.dart';
import 'package:nokosu2023/providers/home_state.dart';
import 'package:nokosu2023/utils/constants.dart';
import 'package:nokosu2023/utils/static_functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<CameraState> cameraKey = GlobalKey();
  late XFile image;

  int flashMode = 0;
  int nextFlashMode = 1;

  late AppLocalizations locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    locale = AppLocalizations.of(context)!;
  }

  @override
  void initState() {
    Provider.of<HomeStateProvider>(context, listen: false).setState(0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: null,
        backgroundColor: ThemeColours.bgBlueWhite,
        body: Stack(
          children: [
            Positioned(
                top: MediaQuery.of(context).size.height * 0.1,
                child: Camera(key: cameraKey)),
            TopBar(
              backBtn: const SizedBox(),
              camkey: cameraKey,
              middleIcon: IconButton(
                icon: flashMode == 1
                    ? SvgPicture.asset(CustIcons.flashauto)
                    : flashMode == 2
                        ? SvgPicture.asset(CustIcons.flash)
                        : SvgPicture.asset(CustIcons.flashno),
                onPressed: () async {
                  final cameraState = cameraKey.currentState;

                  if (cameraState != null) {
                    flashMode = await cameraState.setFlash(nextFlashMode);
                    nextFlashMode = flashMode == 0
                        ? 1
                        : flashMode == 1
                            ? 2
                            : 0;
                    setState(() {});
                  }
                },
              ),
              rightmiddleIcon: const SizedBox(),
              leftmiddleIcon: const SizedBox(),
            ),
            const BottomBar(),
            //Capture button
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.15 - 40,
              left: MediaQuery.of(context).size.width / 2 - 40,
              child: SizedBox(
                width: 80,
                height: 80,
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeColours.bgBlueWhite,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      width: 0,
                      color: Colors.transparent,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6,
                        offset: const Offset(6, 6),
                        color: ThemeColours.shadowDark.withOpacity(0.3),
                      )
                    ],
                  ),
                  child: IconButton(
                    onPressed: () async {
                      OverlayEntry overlayEntry = OverlayEntry(
                          builder: (context) => const LoadingOverlay());

                      Overlay.of(context).insert(overlayEntry);

                      final cameraState = cameraKey.currentState;
                      if (cameraState != null) {
                        image = await cameraState.takePic();

                        await cameraState.setFlash(0);
                        flashMode = 0;
                        nextFlashMode = 1;
                        // ignore: use_build_context_synchronously
                        RedirectFunctions.redirectInfo(context, image.path);
                      }

                      overlayEntry.remove();
                    },
                    icon: SvgPicture.asset(
                      CustIcons.shutter,
                      height: 60,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
