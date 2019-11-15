import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile {
  String user = '';
  bool isLogin = false;
  List friendRequest = [];
  String avatar = '';
  String nickName = '';
  List friendsList = [];

  Profile();

  Profile.fromJson(Map json) {
    user = json['user'];
    isLogin = json['isLogin'];
  }

  Map<String, dynamic> toJson() => {
    'user': user,
    'isLogin': isLogin
  };
}

class Global {
  static SharedPreferences _prefs;
  static Profile profile = Profile();

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString('profile');
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }
  }

  static saveProfile() => _prefs.setString('profile', jsonEncode(profile.toJson()));
}

class ProfileChangeNotifier extends ChangeNotifier {
  Profile get _profile => Global.profile;

  @override
  void notifyListeners() {
    Global.saveProfile(); //保存Profile变更
    super.notifyListeners();
  }
}

class UserModle extends ProfileChangeNotifier {
  String get user => _profile.user;
  set user(String user) {
    _profile.user = user;
    notifyListeners();
  }

  bool get isLogin => _profile.isLogin;
  set isLogin(bool value) {
    _profile.isLogin = value;
    notifyListeners();
  }
} 