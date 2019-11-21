import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../global.dart';
import 'nickname.dart';
import 'password.dart';
import 'package:toast/toast.dart';
import '../../tools/network.dart';

class Modify extends StatefulWidget {
  @override
  _ModifyState createState() => new _ModifyState();
}

class _ModifyState extends State<Modify> {
  bool canSave = false;
  Map newContent = {
    'nickName': ''
  };

  void _changeSaveStatus(bool value) {
    //  不延迟的话会报渲染过程中重复setState的错
    Future.delayed(Duration(milliseconds: 200)).then((e) {
      if(mounted) {
        setState(() {
          canSave = value; 
        });
      }
    });
  }

  void modifyContent(String key, String value) async{
    newContent[key] = value;
  }

  void updateInfo(String key ) async {
    if (!canSave) {
      return ;
    }
    var res;
    Map reqObj = {
      'userName': Provider.of<UserModle>(context).user,
      'changeObj': { key: newContent[key]}
    };
    print(reqObj);
    res = await Network.post('updateUserInfo', reqObj);
    print(newContent[key]);
    if (key == 'nickName') {
      Provider.of<UserModle>(context).nickName = newContent[key];
    }
    if (res.toString() == 'success') {
      Toast.show('修改成功', context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map arg = ModalRoute.of(context).settings.arguments;
    final Map modifyWidgtMap = {
      'nickName': NickName(handler: _changeSaveStatus, modifyFunc: modifyContent),
      'passWord': Password(handler: _changeSaveStatus, modifyFunc: modifyContent)
    };
    Color saveColor = Colors.white;
    Color canNotSaveColor = Color.fromRGBO(255, 255, 255, 0.5);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[IconButton(
          icon: Icon(Icons.save_alt, color: canSave ? saveColor : canNotSaveColor),
          onPressed: () => updateInfo(arg['keyName']),
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
