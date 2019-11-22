import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../global.dart';

class NickName extends StatefulWidget {
  NickName({Key key, @required this.handler, @required this.modifyFunc}) 
    : super(key: key);
  final ValueChanged<bool> handler;
  final modifyFunc;
  //final void ValueChanged<String, String> modifyFunc;
  //var modifyFunc;

  @override
  _NickNameState createState() => _NickNameState();
}

class _NickNameState extends State<NickName> {
  TextEditingController _nickNameController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _nameAutoFocus = true;

  @override
  Widget build(BuildContext context) {
    String oldNickname = Provider.of<UserModle>(context).nickName;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        autovalidate: true,
        child: Column(
          children: <Widget>[
            TextFormField(
              autofocus: _nameAutoFocus,
              controller: _nickNameController,
              decoration: InputDecoration(
                labelText: 'NickName',
                hintText: 'Enter your new nickname',
                prefixIcon: Icon(Icons.notification_important)
              ),
              validator: (v) {
                var result = v.trim().isNotEmpty ? (_nickNameController.text != oldNickname ? null : 'please enter another nickname') : 'required nickname';
                widget.handler(result == null);
                widget.modifyFunc('nickName', _nickNameController.text);
                return result;
              },
            ),
          ],
        ),
      ),
    );
  }
}