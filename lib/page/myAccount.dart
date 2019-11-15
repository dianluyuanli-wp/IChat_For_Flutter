import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../global.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: double.infinity),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          RaisedButton(
            child: Text('退出登录'),
            onPressed: quit,
          )
        ],
      )
    );
  }

  void quit() {
    Provider.of<UserModle>(context).isLogin = false;
  }
}