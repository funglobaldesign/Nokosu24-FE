import 'package:flutter/material.dart';
import 'package:nokosu2023/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenProvider extends ChangeNotifier {
  String _token = "";
  int _id = 0;
  String get token => _token;
  int get id => _id;

  TokenProvider() {
    loadDeviceToken();
  }

  Future<void> setToken(String token, int id) async {
    await _saveDeviceToken(token, id);
    notifyListeners();
  }

  Future<int> loadDeviceIdOnly() async {
    final prefs = await SharedPreferences.getInstance();
    _id = prefs.getInt(DeviseMemory.userID) ?? 0;
    return _id;
  }

  Future<String> loadDeviceTokenOnly() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(DeviseMemory.authToken) ?? "";
    return _token;
  }

  Future<void> loadDeviceToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(DeviseMemory.authToken) ?? "";
    _id = prefs.getInt(DeviseMemory.userID) ?? 0;
    notifyListeners();
  }

  Future<void> _saveDeviceToken(String token, int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(DeviseMemory.authToken, token);
    await prefs.setInt(DeviseMemory.userID, id);
    _token = token;
    _id = id;
  }
}
