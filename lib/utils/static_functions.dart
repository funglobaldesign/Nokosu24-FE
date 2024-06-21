import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:nokosu2023/Components/SubComponents/info_render.dart';
import 'package:nokosu2023/Screens/info_view.dart';
import 'package:nokosu2023/Screens/folders.dart';
import 'package:nokosu2023/Screens/home.dart';
import 'package:nokosu2023/Screens/info.dart';
import 'package:nokosu2023/Screens/infos_folder.dart';
import 'package:nokosu2023/Screens/login.dart';
import 'package:nokosu2023/Screens/password.dart';
import 'package:nokosu2023/Screens/profile.dart';
import 'package:nokosu2023/Screens/registration.dart';
import 'package:nokosu2023/Screens/tutorial.dart';
import 'package:nokosu2023/api/api.dart';
import 'package:nokosu2023/models/models.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:nokosu2023/providers/profile_provider.dart';
import 'package:nokosu2023/utils/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:screenshot/screenshot.dart';
import 'package:http/http.dart' as http;

abstract class RedirectFunctions {
  static void redirectprofile(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  static void redirectRegistration(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationPage()),
    );
  }

  static void redirectResetPassword(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PasswordPage()),
    );
  }

  static void redirectLogin(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  static void redirectHome(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  static void redirectTutorial(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TutorialScreen()),
    );
  }

  static void redirectInfo(context, String path) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InfoPage(
                image: path,
              )),
    );
  }

  static void redirectFolders(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FolderScreen()),
    );
  }

  static void redirectInfoFolders(context, Group group) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InfoFolderScreen(group: group)),
    );
  }

  static void redirectInfoView(context, Info info, Image image) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => InfoView(info: info, image: image)),
    );
  }
}

abstract class Gallery {
  static Future<int> saveImage(Uint8List imageData, String folderName) async {
    try {
      Directory dir = await getTemporaryDirectory();
      String fileName =
          '${DateFormat('yyyyMMddHHmmssSSS').format(DateTime.now())}.jpg';
      String filePath = '${dir.path}/$fileName';
      File imageFile = File(filePath);
      await imageFile.writeAsBytes(imageData);
      await GallerySaver.saveImage(filePath, albumName: folderName);
      return 0;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return 1;
    }
  }

  static Future<int> saveFolder(
      context, List<Info> infos, String group, AppLocalizations locale) async {
    try {
      ScreenshotController screenshotController = ScreenshotController();
      for (var info in infos) {
        Fluttertoast.showToast(
          msg: '${locale.saving} ${info.topic!}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: ThemeColours.bgWhite,
          textColor: ThemeColours.txtGrey,
          fontSize: 16.0,
        );

        await apiGetProfile(context, info.createdBy!);
        late Uint8List infoRenderedImageData;
        late Image infoImg;
        Image creatorpfp = Image.asset(Imgs.pfp);
        String creatroName =
            Provider.of<ProfileProvider>(context, listen: false)
                .profile
                .user!
                .username!;
        String pfp =
            Provider.of<ProfileProvider>(context, listen: false).profile.url!;
        if (pfp.isNotEmpty) {
          final response = await http.get(Uri.parse(pfp));
          if (response.statusCode == 200) {
            final imageData = response.bodyBytes;
            creatorpfp = Image.memory(
              imageData,
              fit: BoxFit.cover,
            );
          }
        }
        final response = await http.get(Uri.parse(info.url!));
        if (response.statusCode == 200) {
          final imageData = response.bodyBytes;
          infoImg = Image.memory(
            imageData,
            fit: BoxFit.cover,
          );
        }
        await screenshotController
            .captureFromWidget(
          InfoRender.getRenderer(info, creatroName, creatorpfp, infoImg),
        )
            .then((capturedImage) {
          infoRenderedImageData = capturedImage;
        });

        await saveImage(
            infoRenderedImageData, '${DeviseMemory.foldername}/$group');
      }

      return 0;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return 1;
    }
  }
}
