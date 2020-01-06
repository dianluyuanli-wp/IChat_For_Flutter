class FriendInfo {
  String user;
  String nickName;
  String avatar;
  List friendsList;
  FriendInfo();

  FriendInfo.fromJson(Map json) {
    user = json['userName'];
    nickName = json['nickName'];
    avatar = json['avatar'];
    friendsList = json['friendsList']??[];
  }
}