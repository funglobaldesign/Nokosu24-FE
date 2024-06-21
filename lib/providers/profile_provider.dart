import 'package:flutter/material.dart';
import 'package:nokosu2023/models/models.dart';

class ProfileProvider with ChangeNotifier {
  Profile _profile = Profile();

  Profile get profile => _profile;

  void setModel(Profile newModel) {
    _profile = newModel;
    notifyListeners();
  }
}
