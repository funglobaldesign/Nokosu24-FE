import 'package:flutter/material.dart';
import 'package:nokosu2023/models/models.dart';

class InfoProvider with ChangeNotifier {
  Info _model = Info();

  Info get model => _model;

  void setModel(Info newModel) {
    _model = newModel;
    notifyListeners();
  }
}

class InfosProvider with ChangeNotifier {
  List<Info> _models = [];

  List<Info> get models => _models;

  void setModels(List<Info> newModels) {
    _models = newModels;
    notifyListeners();
  }

  void addModel(Info newModel) {
    _models.add(newModel);
    notifyListeners();
  }
}
