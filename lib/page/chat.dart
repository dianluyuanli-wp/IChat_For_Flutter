import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../global.dart';
import 'chat/talkList.dart';
import 'chat/inputForm.dart';

class Chat extends StatefulWidget {
  Chat({Key key})
  : super(key: key);
  @override
  ChatState createState() => ChatState();
}
class ChatState extends State<Chat> with CommonInterface {
  ScrollController _scrollController = ScrollController(initialScrollOffset: 18000);

  @override
  Widget build(BuildContext context) {
    UserModle myInfo = Provider.of<UserModle>(context);
    String sayTo = myInfo.sayTo;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Transform.translate(
                offset: Offset(-10, 0),
                child: Text(cFriendInfo(context, sayTo).nickName),
              ),
              Transform.translate(
                offset: Offset(80, 0),
                child: IconButton(
                  icon: Icon(Icons.attach_file, color: Colors.white),
                  onPressed: toFriendInfo,
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(children: <Widget>[
          TalkList(scrollController: _scrollController),
          ChatInputForm(scrollController: _scrollController)
        ],
      ),
    );
  }

  void toFriendInfo() {
    // cUsermodal(context).sayTo = sayTo;
    // cTalkingCol(context).updateMesRank(cMysocket(context), cUser(context));
    //Navigator.of(context).
    Navigator.pushNamed(context, 'friendInfo');
  }

  void slideToEnd() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent + 40);
  }
}