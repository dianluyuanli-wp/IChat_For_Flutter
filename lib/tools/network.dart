import 'package:dio/dio.dart';

Dio dio = Dio();

Map apiMap = {
  //  用户登录验证
  'chatVerify': 'chatVerify',
  //  获取用户信息
  'userInfo': 'userInfo',
  //  更新用户信息
  'updateUserInfo': 'updateUserInfo',
  //  查询用户
  'searchName': 'searchName',
  //  获取所有聊天记录（前几条）
  'getAllMessage': 'getAllMessage',
  //  查询更多记录
  'getMoreMessage': 'getMoreMessage',
  //  添加好友
  'addFriend': 'addFriend',
  //  同意好友申请
  'agreeFriendReq': 'agreeFriendReq'
};

String domain = 'http://tangshisanbaishou.xyz/api/';
//String domain = 'http://localhost';

class Network {
  static Future get(String api, Map<String, dynamic> dataMap) async {
    Response res;
    res = await dio.get(domain + apiMap[api], queryParameters: dataMap);
    return res;
  }

  static Future post(String api, Map dataMap) async {
    Response res;
    res = await dio.post(domain + apiMap[api], data: dataMap);
    return res;
  }
}

Future userVerify(String user, String pwd) async{
  Response res;
  res = await Network.post('chatVerify', {'userName': user, 'passWord': pwd});
  return res.toString() == 'verified';
}