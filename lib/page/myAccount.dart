import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../global.dart';
import '../component/infoBar.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: double.infinity),
      decoration: BoxDecoration(
        color: Color(0xf0eff5ff),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          PersonInfoBar(infoMap: Provider.of<UserModle>(context).modelJson),
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