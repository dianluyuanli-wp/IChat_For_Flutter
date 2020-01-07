library global;

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:i_chat/tools/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './tools/network.dart';
import 'package:dio/dio.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

part './model/User.dart';
part './model/FriendInfo.dart';
part './model/Message.dart';

class Profile {
  String user = '';
  bool isLogin = false;
  //  好友申请列表
  List friendRequest = [];
  //  头像
  String avatar = '';
  //  昵称
  String nickName = '';
  //  好友列表
  List friendsList = [];

  Profile();

  Profile.fromJson(Map json) {
    user = json['user'];
    isLogin = json['isLogin'];
    friendRequest = json['friendRequest'];
    avatar = json['avatar'];
    friendsList = json['friendsList'];
    nickName = json['nickName'];
  }

  Map<String, dynamic> toJson() => {
    'user': user,
    'isLogin': isLogin,
    'friendRequest': friendRequest,
    'avatar': avatar,
    'friendsList': friendsList,
    'nickName': nickName
  };
}

class Global {
  static SharedPreferences _prefs;
  static Profile profile = Profile();

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();

    String _profile = _prefs.getString('profile');
    Response message;
    if (_profile != null) {
      try {
        //  如果存在用户，则拉取聊天记录
        Map decodeContent = jsonDecode(_profile != null ? _profile : '');
        profile = Profile.fromJson(decodeContent);
        message = await Network.get('getAllMessage', { 'userName' : decodeContent['user'] });
      } catch (e) {
        print(e);
      }
    }
    String socketIODomain = 'http://tangshisanbaishou.xyz';
    IO.Socket socket = IO.io(socketIODomain, <String, dynamic>{
      'transports': ['websocket'],
      'path': '/mySocket'
    });
    return {
      'messageArray': message != null ? message.data : [],
      'socketIO': socket
    };
  }

  static saveProfile() => _prefs.setString('profile', jsonEncode(profile.toJson()));
}

class MySocketIO {
  IO.Socket mySocket;
  MySocketIO(this.mySocket);
}

//  给其他widget做的抽象类，用来获取数据
abstract class CommonInterface {
  String cUser(BuildContext context) {
    return Provider.of<UserModle>(context).user;
  }
  String cSayto(BuildContext context) {
    return Provider.of<UserModle>(context).sayTo;
  }
  IO.Socket cMysocket(BuildContext context) {
    return Provider.of<MySocketIO>(context).mySocket;
  }
  SingleMesCollection cTalkingCol(BuildContext context) {
    return Provider.of<Message>(context).getUserMesCollection(cSayto(context));
  }
  UserModle cUsermodal(BuildContext context) {
    return Provider.of<UserModle>(context);
  }
  SingleMesCollection cMesCol(BuildContext context, String owner) {
    return Provider.of<Message>(context).getUserMesCollection(owner);
  }
  Message cMesArr(BuildContext context) {
    return Provider.of<Message>(context);
  }
  FriendInfo cFriendInfo(BuildContext context, String name) {
    return cUsermodal(context).friendsList.firstWhere((item) => item.user == name, orElse: () => new FriendInfo.fromJson({}));
  }
}