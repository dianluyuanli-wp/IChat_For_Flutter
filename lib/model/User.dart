import 'ProfileChangeNotifiler.dart';

class UserModle extends ProfileChangeNotifier {
  String get user => _user;
  String _user = '22';
  set user(String name) {
    _user = name;
    notifyListeners();
  }

  bool _isLogin = false;
  bool get isLogin => _isLogin;
  set isLogin(bool value) {
    _isLogin = value;
    notifyListeners();
  }
} 