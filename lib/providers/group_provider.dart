import 'package:flutter/material.dart';
import 'package:nokosu2023/models/models.dart';

class GroupProvider with ChangeNotifier {
  Group _model = Group();

  Group get model => _model;

  void setModel(Group newModel) {
    _model = newModel;
    notifyListeners();
  }
}

class GroupsProvider with ChangeNotifier {
  List<Group> _models = [];

  List<Group> get models => _models;

  void setModels(List<Group> newModels) {
    _models = newModels;
    notifyListeners();
  }

  void addModel(Group newModel) {
    _models.add(newModel);
    notifyListeners();
  }
}
