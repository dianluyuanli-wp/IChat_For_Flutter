import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import '../global.dart';
import '../tools/network.dart';

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
    var res;
    // res = await dio.post('http://tangshisanbaishou.xyz/api/chatVerify', data: {
    //   'userName': _unameController.text,
    //   'passWord': _pwdController.text
    // });
    res = await Network.post('chatVerify', {
      'userName': _unameController.text,
      'passWord': _pwdController.text
    });
    Provider.of<UserModle>(context).user = _unameController.text;
    if (res.toString() == 'verified') {
      Provider.of<UserModle>(context).isLogin = true;
    } else {
      Toast.show('账号密码错误', context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    }
  }
}