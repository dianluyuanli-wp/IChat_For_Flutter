import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../global.dart';

class PersonInfoBar extends StatelessWidget {
  PersonInfoBar({
    @required this.infoMap
  });

  final infoMap;
  @override
  Widget build(BuildContext context) {
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
          ButtonGroup(type: 'search', target: infoMap.user)
        ],
      ),
    );
  }
}

class ButtonGroup extends StatefulWidget {
  ButtonGroup({Key key, @required this.type, @required this.target})
  : super(key: key);
  final String type;
  final String target;
  @override
  _ButtonGroupState createState() => _ButtonGroupState();
}

class _ButtonGroupState extends State<ButtonGroup> with CommonInterface {
  @override
  Widget build(BuildContext context) {
    bool inFriendsList = cUsermodal(context).friendsList.firstWhere((item) => item.user == widget.target) != null;
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
                    onPressed: () {},
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
}