import 'package:flutter/material.dart';
import '../global.dart';
import '../component/infoBar.dart';
import '../tools/network.dart';
import 'myAccount.dart';

class FriendInfoRoute extends StatefulWidget {
  @override
  _FriendInfoState createState() => _FriendInfoState();
}

class _FriendInfoState extends State<FriendInfoRoute> with CommonInterface{
  @override
  Widget build(BuildContext context) {
    UserModle myInfo = cUsermodal(context);
    FriendInfo talkingInfo = myInfo.friendsList.firstWhere((item) => item.user == myInfo.sayTo, orElse: () => FriendInfo.fromJson({
      'userName': '1',
      'avatar': '1',
      'nickName': '1'
    }));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Transform.translate(
                offset: Offset(-30, 0),
                child: Text(myInfo.sayTo),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minWidth: double.infinity),
          decoration: BoxDecoration(
            color: Color(0xf0eff5ff),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                child: PersonInfoBar(infoMap: talkingInfo),
                margin: EdgeInsets.only(top: 15),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Column(
                  children: <Widget>[
                    ModifyItem(text: 'Nickname', keyName: 'nickName', owner: myInfo.sayTo, useBottomBorder: true)
                  ],
                ),
              ),
              Container(
                child: GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 45),
                    constraints: BoxConstraints(
                      minWidth: double.infinity,
                      minHeight: 45
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      border: Border(top: borderStyle, bottom: borderStyle)
                    ),
                    child: Text('Delete Friend', style: TextStyle(color: Colors.red)),
                  ),
                  onTap: deleteFriend
                ),
              ) 
            ],
          )
        )
      )
    );
  }

  void deleteFriend() async {
    bool delete = await deleteDialog();
    if (delete != null) {
      String friendName = cUsermodal(context).sayTo;
      await Network.post('updateUserInfo', {
        'userName': cUser(context),
        'changeObj': { 'delete': {
          'key': 'friendsList',
          'value': friendName
        }}
      });
      cUsermodal(context).friendsListJson.removeWhere((item) => item['userName'] == friendName);
      Navigator.pushNamed(context, '/');
    }
  }

  Future<bool> deleteDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('您确定要删除该好友吗?'),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text('删除'),
              onPressed: () => Navigator.of(context).pop(true),
            )
          ],
        );
      }
    );
  }
}

