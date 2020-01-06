import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../global.dart';
import 'chat/talkList.dart';
import 'chat/inputForm.dart';
import '../tools/utils.dart';

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
    cUsermodal(context).toastContext = context;
    //  更新桌面icon
    updateBadger(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(cFriendInfo(context, sayTo).nickName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.white),
            onPressed: toFriendInfo,
          )
        ],
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