import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../global.dart';

class FriendList extends StatefulWidget {
  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> with CommonInterface {
  @override
  Widget build(BuildContext context) {
    String iam = cUser(context);
    return Scrollbar(
        child: ListView.separated(
          itemCount: Provider.of<UserModle>(context).friendsList.length,
          itemBuilder: (BuildContext context, int index) {
            //return ListTile(title: Text('$index'), onTap: () => {enterTalk(context)});
            Map friendInfo = cUsermodal(context).friendsList[index];
            int flagDiff = cMesCol(context, friendInfo['userName']).flagDiff(iam);
            return GestureDetector(
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 360,
                  maxHeight: 55
                ),
                decoration: BoxDecoration(
                  color: Colors.black12
                ),
                child: Row(
                  children: <Widget>[
                    Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Container(
                          constraints: BoxConstraints(maxWidth: 40, maxHeight: 40),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: Image(
                            image: CachedNetworkImageProvider(friendInfo['avatar']),
                            width: 40,
                          ),
                        ),
                        flagDiff > 0 ? Positioned(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            constraints: BoxConstraints(
                              minWidth: 13
                            ),
                            child: Text(flagDiff.toString(),
                            textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10
                              ),
                            ),
                            //width: 20,
                            //height: 20,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          top: -5,
                          left: 35
                        ) : null,
                      ].where((item) => item != null).toList(),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 7, 0, 7),
                          child: Text(friendInfo['nickName']),
                        ),
                        Text(Provider.of<Message>(context).getLastMessage(friendInfo['userName']))
                      ],
                    )
                  ],
                ),
              ),
              onTap: () => {enterTalk(context, friendInfo['userName'])}
            );
          },
          separatorBuilder: (BuildContext contet, int index) {
            return index % 2 == 0 ? Divider(color: Colors.blue) : Divider(color: Colors.green,);
          },
        )
      );
  }

  void enterTalk(context, sayTo) {
    cUsermodal(context).sayTo = sayTo;
    cTalkingCol(context).updateMesRank(cMysocket(context), cUser(context));
    //Navigator.of(context).
    Navigator.pushNamed(context, 'chat');
  }
}