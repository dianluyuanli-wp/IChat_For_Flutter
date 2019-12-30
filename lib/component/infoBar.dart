import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../global.dart';
import '../tools/network.dart';
import '../tools/utils.dart';

class PersonInfoBar extends StatelessWidget {
  PersonInfoBar({
    @required this.infoMap,
    this.useButton = false
  });

  final infoMap;
  final bool useButton;
  @override
  Widget build(BuildContext context) {
    print(useButton);
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffffffff)
      ),
      child: Row(
        children: <Widget>[
          Container(
            height: 70,
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: Image(
              image: CachedNetworkImageProvider(infoMap.avatar),
              height: 50,
              width: 50,
              fit: BoxFit.fill
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsetsDirectional.only(bottom: 8),
                child: Text(infoMap.nickName ?? 'dddd'),
              ),
              Text('chatId: ' + infoMap.user)
            ],
          ),
          useButton ? ButtonGroup(type: 'search', target: infoMap.user) : null
          //ButtonGroup(type: 'search', target: infoMap.user)
        ].where((item) => item != null).toList(),
      ),
    );
  }
}

class ButtonGroup extends StatefulWidget {
  ButtonGroup({Key key, @required this.type, @required this.target })
  : super(key: key);
  final String type;
  final String target;
  @override
  _ButtonGroupState createState() => _ButtonGroupState();
}

class _ButtonGroupState extends State<ButtonGroup> with CommonInterface {
  @override
  Widget build(BuildContext context) {
    bool inFriendsList = cUsermodal(context).friendsList.firstWhere((item) => item.user == widget.target, orElse: () => new FriendInfo.fromJson({})).user != null;
    return Container(
            child: widget.type == 'search' ?
              Container(
                child: inFriendsList ?
                Container(
                  width: 70,
                  height: 30,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 120),
                  decoration: BoxDecoration(
                    color: Color(0xfff5f5f5),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Color(0xFF999999), width: 1)
                  ),
                  child: Text('Added', style: TextStyle(color: Color(0xff999999)),) 
                )
                : Container(
                  margin: EdgeInsets.only(left: 120),
                  child: FlatButton(
                    color: Colors.blue,
                    child: Text('Add', style: TextStyle(color: Color(0xffffffff)),),
                    onPressed: addFriend,
                  ),
                )
              )
              : Row(
                children: <Widget>[
                  FlatButton(
                    child: Text('Added'),
                    onPressed: () {},
                  )
                ],
              ),
          );
  }

  void addFriend() async {
    //await Network.get('searchName', {'searchName': searchContent});
    var res = await Network.get('addFriend', {'userName': cUser(context), 'friendName': widget.target});
    if (res.data == 'friend request success!') {
      showToast('请求发送成功', context);
      cMysocket(context).emit('informFriend', { 'type': 'addReq', 'friendName': widget.target, 'IAm': cUser(context)});
    } else if (res.data == 'A friend request has been sent') {
      showToast('好友请求已发送，请勿重复发送', context);
    }
  }
}