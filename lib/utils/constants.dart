import 'package:flutter/material.dart';

abstract class APILinks {
  static const String base = "https://nokosu.onrender.com/api/";
  // "http://127.0.0.1:8000/api/";
  // "https://globaldesign2023backend.onrender.com/api/";

  static const String maps = 'https://www.google.com/maps/search/?api=1&query=';
}

abstract class ThemeColours {
  // Background colours
  static const Color bgBlueWhite = Color(0xFFEBF3FF);
  static const Color bgWhite = Color(0xFFFFFFFF);

  // Text colours
  static const Color txtBlack = Color(0xFF000000);
  static const Color txtGrey = Color(0x77777777);
  static const Color txtRed = Colors.red;
  static const Color txtWhite = Colors.white;

  // Icon Colours
  static const Color iconBlack = Color(0x88000000);
  static const Color iconblue = Color(0xFF7AA8FF);

  // Shadow Colours
  static const Color shadowDark = Color(0x88555555);
  static const Color shadowLight = Color(0xFFFFFFFF);

  // Flip Button
  static const Color negative = Color(0xFF91BDFF);
  static const Color positive = Color(0xFFFF9191);

  //Others
  static const Color scrollBar = Color(0xAA777777);
  static const Color doneBtn = Color(0xFF2F4266);
}

abstract class NumericConsts {
  static const double defBoxWidth = 250;
  static const double defBoxHeight = 55;
}

abstract class CustIcons {
  static const String logo = 'assets/icons/nokosu_logo.svg';
  static const String globe = 'assets/icons/globe.svg';

  // Categories
  static const String cultural = 'assets/icons/cultural.svg';
  static const String culturalnon = 'assets/icons/cultural_no.svg';
  static const String emotional = 'assets/icons/emotional.svg';
  static const String emotionalnon = 'assets/icons/emotional_no.svg';
  static const String physical = 'assets/icons/physical.svg';
  static const String physicalnon = 'assets/icons/physical_no.svg';
  static const String positive = 'assets/icons/positive.svg';
  static const String negative = 'assets/icons/negative.svg';

  // Form icons
  static const String comment = 'assets/icons/comment.svg';
  static const String groups = 'assets/icons/groups.svg';
  static const String mail = 'assets/icons/mail.svg';
  static const String location = 'assets/icons/place.svg';
  static const String topic = 'assets/icons/topic.svg';
  static const String username = 'assets/icons/username.svg';
  static const String firstname = 'assets/icons/first_name.svg';
  static const String lastname = 'assets/icons/last_name.svg';
  static const String lock = 'assets/icons/password_unlock.svg';
  static const String lockconf = 'assets/icons/password_lock.svg';

  // nav icons
  static const String camera = 'assets/icons/camera.svg';
  static const String gallery = 'assets/icons/gallery.svg';
  static const String shutter = 'assets/icons/shutter_mark.svg';
  static const String tutorial = 'assets/icons/tutorial.svg';
  static const String profile = 'assets/icons/profile.svg';
  static const String flash = 'assets/icons/flash.svg';
  static const String flashno = 'assets/icons/flash_no.svg';
  static const String flashauto = 'assets/icons/flash_auto.svg';
}

abstract class Imgs {
  static const String folder = 'assets/imgs/folder.png';
  static const String pfp = 'assets/imgs/pfp.png';
  static const String logo = 'assets/imgs/pfp.png';

  static const String p1 = 'assets/imgs/tutorial/1.png';
  static const String p2 = 'assets/imgs/tutorial/2.png';
  static const String p3 = 'assets/imgs/tutorial/3.png';
  static const String p4 = 'assets/imgs/tutorial/4.png';
  static const String p5 = 'assets/imgs/tutorial/5.png';
}

abstract class DeviseMemory {
  static const String locale = 'nokosulocale';
  static const String authToken = 'authtoken';
  static const String userID = 'userid';
  static const String foldername = 'Nokosu';
}

abstract class Errors {
  static const int none = 0;
  static const int badreq = 1;
  static const int unAuth = 2;
  static const int unknown = 3;
}
