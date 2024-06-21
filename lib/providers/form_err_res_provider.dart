import 'package:flutter/material.dart';
import 'package:nokosu2023/models/models.dart';

class FormErrProvider with ChangeNotifier {
  UserRegResponse _userRegResponse = UserRegResponse();

  UserRegResponse get userRegResponse => _userRegResponse;

  void setModel(UserRegResponse newModel) {
    _userRegResponse = newModel;
    notifyListeners();
  }
}
