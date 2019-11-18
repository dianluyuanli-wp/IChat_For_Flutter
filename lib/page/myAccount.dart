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
          Container(
            child: PersonInfoBar(infoMap: Provider.of<UserModle>(context).modelJson),
            margin: EdgeInsets.only(top: 15),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Column(
              children: <Widget>[
                ModifyItem(text: 'Nickname', keyName: 'nickName'),
                ModifyItem(text: 'Avatar', keyName: 'nickName'),
                ModifyItem(text: 'Password', keyName: 'nickName', useBottomBorder: true)
              ],
            ),
          ),
          Container(
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 45),
                constraints: BoxConstraints(
                  minWidth: double.infinity,
                  minHeight: 45
                ),
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  border: Border(top: borderStyle, bottom: borderStyle)
                ),
                child: Text('Log Out', style: TextStyle(color: Colors.red)),
              ),
              onTap: quit,
            ) 
          )
        ],
      )
    );
  }

  void quit() {
    Provider.of<UserModle>(context).isLogin = false;
  }
}

var borderStyle = BorderSide(color: Color(0xffd4d4d4), width: 1.0);

class ModifyItem extends StatelessWidget {
  ModifyItem({this.text, this.keyName, this.useBottomBorder = false});
  final String text;
  final String keyName;
  final bool useBottomBorder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.centerLeft,
        //  有了color就不能使用decoration属性，这二者二选一
        //color: Color(0xffffffff),
        constraints: BoxConstraints(
          minWidth: double.infinity,
          minHeight: 45
        ),
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          border: Border(top: borderStyle, bottom: useBottomBorder ? borderStyle: BorderSide.none)
        ),
        padding: EdgeInsets.only(left: 10),
        child: Text(text),
      ),
      onTap: modify,
    );
  }
}

void modify() {
  
}