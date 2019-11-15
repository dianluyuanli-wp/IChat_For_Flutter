import 'package:dio/dio.dart';

Dio dio = Dio();

Map apiMap = {
  //  用户登录验证
  'chatVerify': 'chatVerify',
  //  获取用户信息
  'userInfo': 'userInfo'
};

String domain = 'http://tangshisanbaishou.xyz/api/';

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