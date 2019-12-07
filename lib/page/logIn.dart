import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../tools/utils.dart';
import '../global.dart';
import '../tools/network.dart';
import 'package:dio/dio.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => new _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  bool pwdShow = false;
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _nameAutoFocus = true;

  @override
  void initState() {
    _unameController.text = Global.profile.user;
    if (_unameController.text != null) {
      _nameAutoFocus = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    //var gm = GmLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: Text('登录'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidate: true,
            child: Column(
              children: <Widget>[
                TextFormField(
                  autofocus: _nameAutoFocus,
                  controller: _unameController,
                  decoration: InputDecoration(
                    //labelStyle: TextStyle(color: Colors.greenAccent),
                    labelText: 'UserName',
                    hintText: 'Enter your name',
                    //hintStyle: TextStyle(color: Colors.red),
                    prefixIcon: Icon(Icons.person)
                  ),
                  validator: (v) {
                    return v.trim().isNotEmpty ? null : 'required userName';
                  },
                ),
                TextFormField(
                  controller: _pwdController,
                  autofocus: !_nameAutoFocus,
                  decoration: InputDecoration(
                    // labelStyle: TextStyle(color: Colors.greenAccent),
                    // hintStyle: TextStyle(color: Colors.greenAccent),
                    labelText: 'PassWord',
                    hintText: 'Enter Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(pwdShow ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                        pwdShow = !pwdShow; 
                        });
                      },
                    )
                  ),
                  obscureText: !pwdShow,
                  validator: (v) {
                    return v.trim().isNotEmpty ? null : 'required passWord';
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(height: 55),
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: _onLogin,
                      textColor: Colors.white,
                      child: Text('Login'),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      )
    );
  }

  void _onLogin () async {
    String userName = _unameController.text;
    UserModle globalStore = Provider.of<UserModle>(context);
    Message globalMessage = Provider.of<Message>(context);
    globalStore.user = userName;
    Map<String, String> name = { 'userName' : userName };
    if (await userVerify(_unameController.text, _pwdController.text)) {
      Response info = await Network.get('userInfo', name);
      globalStore.apiUpdate(info.data);
      globalStore.isLogin = true;
      //  重新登录的时候也要拉取聊天记录
      Response message = await Network.get('getAllMessage', name);
      globalMessage.assignFromJson(message.data);
    } else {
      showToast('账号密码错误', context);
    }
  }
}