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

class ProfileChangeNotifier extends ChangeNotifier {
  Profile get _profile => Global.profile;

  @override
  void notifyListeners() {
    Global.saveProfile(); //保存Profile变更
    super.notifyListeners();
  }
}

class FriendInfo {
  String user;
  String nickName;
  String avatar;
  List friendsList;

  FriendInfo.fromJson(Map json) {
    user = json['userName'];
    nickName = json['nickName'];
    avatar = json['avatar'];
    friendsList = json['friendsList']??[];
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
}

class MySocketIO {
  IO.Socket mySocket;
  MySocketIO(this.mySocket);
}

class MessageNotifier extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

class SingleMessage {
  String owner;
  String content;
  int timeStamp;

  SingleMessage(this.owner, this.content, this.timeStamp);

  SingleMessage.fromJson(Map json) {
    owner = json['owner'];
    content = json['content'];
    timeStamp = json['timeStamp'];
  }
}

class SingleMesCollection {
  String bothOwner;
  List<SingleMessage> message = [];
  int user1flag = 0;
  int user2flag = 0;

  //  空白构造函数
  SingleMesCollection();

  //  根据参数构造函数
  SingleMesCollection.fromMes(String sender, String receiver, String content) {
    bothOwner = sender.compareTo(receiver) > 0 ? receiver + '@' + sender : sender + '@' + receiver;
    user1flag = isFirst(bothOwner, sender) ? 1 : 0;
    user2flag = isFirst(bothOwner, sender) ? 0 : 1;
    message = [new SingleMessage(sender, content, new DateTime.now().millisecondsSinceEpoch)];
  }

  //  根据json的构造函数
  SingleMesCollection.fromJson(Map json) {
    bothOwner = json['bothOwner'];
    message = json['message'].map<SingleMessage>((item) {
      return SingleMessage.fromJson(item);
    }).toList();
    user1flag = json['user1_flag'];
    user2flag = json['user2_flag'];
  }

  //  根据身份更新消息计数(同步本地)
  void rankMark(String identity, String athor) {
    if (identity == 'sender') {
      if (isFirst(bothOwner, athor)) {
        user1flag += 1;
      } else {
        user2flag += 1;
      }
    } else {
      int updateNum = max(user1flag, user1flag) + 1;
      if (isFirst(bothOwner, athor)) {
        user1flag = updateNum;
      } else {
        user2flag = updateNum;
      }
    }
  }
  //  本地计数统一并通知远端同步
  void updateMesRank(IO.Socket mysocket, String user) {
    mysocket.emit('updateMessRank', [user, bothOwner.replaceAll(user, '').replaceAll('@', '')]);
    if (isFirst(bothOwner, user)) {
      user1flag = user2flag;
    } else {
      user2flag = user1flag;
    }
  }

  int flagDiff(owner) {
    return (isFirst(bothOwner, owner) ? -1 : 1) * (user1flag - user2flag);
  }
}

class Message extends MessageNotifier {
  Message();
  List<SingleMesCollection> messageArray;
  void assignFromJson(List json) {
    messageArray = json.map((item) {
      return SingleMesCollection.fromJson(item);
    }).toList();
  }

  Message.fromJson(List json) {
    messageArray = json.map<SingleMesCollection>((item) {
      return SingleMesCollection.fromJson(item);
    }).toList();
  }
  //  获得最后一条信息
  String getLastMessage(String name) {
    return messageArray.firstWhere((item) => (item.bothOwner.contains(name)), orElse: () => new SingleMesCollection()).message.last.content;
  }
  //  获取与某人的聊天记录
  SingleMesCollection getUserMesCollection(String name) {
    return messageArray.firstWhere((item)  {
      return item.bothOwner.contains(name);
      }, orElse: () => new SingleMesCollection());
  }
  //  添加一个新的聊天记录
  void addItemToMesArray(String sender, String receiver, String content) {
    messageArray.add(SingleMesCollection.fromMes(sender, receiver, content));
  }

  void addMessRecord(String sayTo, SingleMessage mes) {
    getUserMesCollection(sayTo).message.add(mes);
    notifyListeners();
  }
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