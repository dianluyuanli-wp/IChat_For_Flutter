// import 'ProfileChangeNotifiler.dart';
import '../global.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

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

  String get avatar => _profile.avatar;
  set avatar(String value) {
    _profile.avatar = value;
    notifyListeners();
  }

  List get friendRequest => _profile.friendRequest;
  set friendRequest(List value) {
    _profile.friendRequest = value;
    notifyListeners();
  }

  List<FriendInfo> get friendsList => _profile.friendsList.map<FriendInfo>((item) => FriendInfo.fromJson(item)).toList();
  set friendsList(List value) {
    _profile.friendsList = value;
    notifyListeners();
  }

  List get friendsListJson => _profile.friendsList;
  set friendsListJson(List value) {
    _profile.friendsList = value;
    notifyListeners();
  }

  String get nickName => _profile.nickName;
  set nickName(String value) {
    _profile.nickName = value;
    notifyListeners();
  }

  void apiUpdate(Map data) {
    _profile.friendRequest = data['friendRequest'];
    _profile.friendsList = data['friendsList'];
    _profile.nickName = data['nickName'];
    _profile.avatar = data['avatar'];
  }

  void addFriendReq(Map message) {
    _profile.friendRequest.add(message);
    notifyListeners();
  }

  Map get modelJson => _profile.toJson();

  String toUser = '123';
  String get sayTo => toUser;
  set sayTo(String value) {
    toUser = value;
    notifyListeners();
  }

  FriendInfo findFriendInfo(name) {
    return friendsList.firstWhere((item) => name == item.user);
  }

  BuildContext toastContext;
}