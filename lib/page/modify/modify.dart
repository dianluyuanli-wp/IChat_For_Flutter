import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../global.dart';
import 'nickname.dart';
import '../../tools/network.dart';

class Modify extends StatefulWidget {
  @override
  _ModifyState createState() => new _ModifyState();
}

class _ModifyState extends State<Modify> {
  bool canSave = false;
  Map newContent = {
    'newNickname': ''
  };

  void _changeSaveStatus(bool value) {
    //  不延迟的话会报渲染过程中重复setState的错
    Future.delayed(Duration(milliseconds: 200)).then((e) {
      setState(() {
      canSave = value; 
      });
    });
  }

  void modifyContent(String key, String value) {
    // var res;
    // res = await Network.post('updateUserInfo', {
    //   'changeObj': obj,
    // });
    newContent[key] = value;
    print(newContent);
  }

  @override
  Widget build(BuildContext context) {
    final Map arg = ModalRoute.of(context).settings.arguments;
    final Map modifyWidgtMap = {
      'nickName': NickName(handler: _changeSaveStatus, modifyFunc: modifyContent),
    };
    Color saveColor = Colors.white;
    Color canNotSaveColor = Color.fromRGBO(255, 255, 255, 0.5);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[IconButton(
          icon: Icon(Icons.save_alt, color: canSave ? saveColor : canNotSaveColor),
          onPressed: () => {},
        )],
        title: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(arg['text']),
            ],
          ),
        ),
      ),
      body: modifyWidgtMap[arg['keyName']]
    );
  }
}
