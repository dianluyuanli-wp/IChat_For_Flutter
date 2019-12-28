import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../global.dart';
import 'nickname.dart';
import 'password.dart';
import 'avatar.dart';
import '../../tools/utils.dart';
import '../../tools/network.dart';

class Modify extends StatefulWidget {
  @override
  _ModifyState createState() => new _ModifyState();
}

class _ModifyState extends State<Modify> with CommonInterface{
  bool canSave = false;
  Map newContent = {
    'nickName': '',
    'originPassWord': '',
    'passWord': '',
    'newPassWordAgain': '',
    'avatar': ''
  };

  //  控制是否能够提交与高亮状态
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

  //  给map赋值
  void modifyContent(String key, String value) async{
    newContent[key] = value;
  }

  Map updateOjb(String key) {
    if (key == 'nickName' && infoOwner != cUser(context)) {
      return {
        'userName': cUser(context),
        'changeObj': { 'fridendNickName':{
          'newNickName': newContent[key],
          'friend': infoOwner
        }}
      };
    } else {
      return {
        'userName': Provider.of<UserModle>(context).user,
        'changeObj': { key: newContent[key]}
      };
    }
  }

  void updateInfo(String key ) async {
    if (!canSave) {
      return ;
    }
    if (key == 'passWord') {
      if (newContent['passWord'] != newContent['newPassWordAgain']) {
        showToast('两次新密码输入不一致', context);
        return;
      }
      if (!await userVerify(Provider.of<UserModle>(context).user, newContent['originPassWord'])) {
        showToast('老密码错误', context);
        return;
      }
    }
    var res;
    res = await Network.post('updateUserInfo', updateOjb(key));
    if (key == 'nickName') {
      if (infoOwner == cUser(context)) {
        Provider.of<UserModle>(context).nickName = newContent[key];
      } else {
        cUsermodal(context).friendsListJson.firstWhere((item) => item['userName'] == infoOwner)['nickName'] = newContent[key];
      }
    }
    if (key == 'avatar') {
      Provider.of<UserModle>(context).avatar = res.data['data']['imgUrl'];
    }
    if (res.data['status'].toString() == 'success') {
      showToast('修改成功', context);
    }
  }

  get infoOwner {
    Map temp =  ModalRoute.of(context).settings.arguments;
    return temp['owner'];
  }

  @override
  Widget build(BuildContext context) {
    final Map arg = ModalRoute.of(context).settings.arguments;
    final Map modifyWidgtMap = {
      'nickName': NickName(handler: _changeSaveStatus, modifyFunc: modifyContent, target: arg['owner']),
      'passWord': Password(handler: _changeSaveStatus, modifyFunc: modifyContent),
      'avatar': Avatar(handler: _changeSaveStatus, modifyFunc: modifyContent)
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
