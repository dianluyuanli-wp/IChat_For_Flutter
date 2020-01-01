import 'package:flutter/material.dart';
import '../../global.dart';
import '../../tools/utils.dart';

class ChatInputForm extends StatefulWidget {
  ChatInputForm({Key key, @required this.scrollController})
    : super(key: key);
  final ScrollController scrollController;

  @override
  _ChatInputFormState createState() => _ChatInputFormState();
}

class _ChatInputFormState extends State<ChatInputForm> with CommonInterface {
  TextEditingController _messController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool canSend = false;

  @override
  Widget build(BuildContext context) {
    return Form(
            key: _formKey,
            child: Container(
              color: Color(0xfff5f5f5),
              child: TextFormField(
                autofocus: false,
                maxLines: 3,
                minLines: 1,
                controller: _messController,
                onChanged: validateInput,
                decoration: InputDecoration(
                  hintText: 'You wanna to say',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                  ),
                  prefixIcon: Icon(Icons.people),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.message, color: canSend ? Colors.blue : Colors.grey),
                    onPressed: sendMess,
                  )
                ),
              )
            )
          );
  }

    void validateInput(String test) {
    setState(() {
      canSend = test.length > 0;
    });
  }

  void sendMess() {
    if (!canSend) {
      return;
    }
    UserModle myInfo = cUsermodal(context);
    SingleMessage newMess = new SingleMessage(myInfo.user, _messController.text, new DateTime.now().millisecondsSinceEpoch);
    cMesArr(context).addMessRecord(myInfo.sayTo, newMess);
    cTalkingCol(context).rankMark('sender', cUser(context));
    cMysocket(context).emit('chat message', [myInfo.sayTo, myInfo.user, _messController.text]);
    // 保证在组件build的第一帧时才去触发取消清空内容
    WidgetsBinding.instance.addPostFrameCallback((_) {
        _messController.clear();
    });
    //  键盘自动收起
    //FocusScope.of(context).requestFocus(FocusNode());
    widget.scrollController.jumpTo(widget.scrollController.position.maxScrollExtent + 50);
    setState(() {
      canSend = false;
    });
    //showToast('对方开启好友验证，本消息无法送达', context);
  }
}