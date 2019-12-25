import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../global.dart';
import 'chat/talkList.dart';
import 'chat/inputForm.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}
class _ChatState extends State<Chat> with CommonInterface {
  ScrollController _scrollController = ScrollController(initialScrollOffset: 18000);

  @override
  Widget build(BuildContext context) {
    UserModle myInfo = Provider.of<UserModle>(context);
    String sayTo = myInfo.sayTo;

    UserModle newUserModel = cUsermodal(context);
    Message mesArray = Provider.of<Message>(context);
    if(!cMysocket(context).hasListeners('chat message')) {
      cMysocket(context).on('chat message', (msg) {
        String owner = msg['owner'];
        String message = msg['message'];
        SingleMesCollection mesC = mesArray.getUserMesCollection(owner);
        if (mesC.bothOwner == null) {
          mesArray.addItemToMesArray(owner, newUserModel.user, message);
        } else {
          //cTalkingCol(context).message.add(newMess);
          cMesArr(context).addMessRecord(owner, new SingleMessage(owner, message, new DateTime.now().millisecondsSinceEpoch));
          print(mesArray.getLastMessage(owner));
        }
        //print(ModalRoute.of(pc).settings);
        // if (ModalRoute.of(context).settings.name == 'chat') {
        //   mesC.updateMesRank(cMysocket(context), cUser(context));
        // } else {
        //   mesC.rankMark('receiver', owner);
        // }
      });
    }
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

  void flush() {
    setState(() {
      
    });
  }
}