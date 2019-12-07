import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../global.dart';

class FriendList extends StatefulWidget {
  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        child: ListView.separated(
          itemCount: Provider.of<UserModle>(context).friendsList.length,
          itemBuilder: (BuildContext context, int index) {
            //return ListTile(title: Text('$index'), onTap: () => {enterTalk(context)});
            Map friendInfo = Provider.of<UserModle>(context).friendsList[index];
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
                    Image(
                      image: CachedNetworkImageProvider(friendInfo['avatar']),
                      width: 50,
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
    Provider.of<UserModle>(context).sayTo = sayTo;
    Navigator.pushNamed(context, 'chat');
  }
}