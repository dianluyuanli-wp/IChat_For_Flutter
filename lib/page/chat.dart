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
              // IconButton(
              //   icon: Icon(Icons.find_replace, color: Colors.white),
              //   onPressed: flush,
              // ),
              Transform.translate(
                offset: Offset(-30, 0),
                child: Text(sayTo),
              ),
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

  void slideToEnd() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent + 40);
  }
}