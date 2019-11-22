import 'package:flutter/material.dart';

class Password extends StatefulWidget {
  Password({Key key, @required this.handler, @required this.modifyFunc}) 
    : super(key: key);
  final ValueChanged<bool> handler;
  final modifyFunc;

  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  TextEditingController _originalPWController = new TextEditingController();
  TextEditingController _newPWController = new TextEditingController();
  TextEditingController _newPWAgainController = new TextEditingController();

  bool pwdShow = false;
  bool newPwdShow = false;
  bool newPwdAgainShow =  false;

  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _nameAutoFocus = true;

  @override
  Widget build(BuildContext context) {
    widget.handler(true);
    bool noEmpty() => _originalPWController.text.trim().isNotEmpty && _newPWController.text.trim().isNotEmpty && _newPWAgainController.text.trim().isNotEmpty;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(
            children: <Widget>[
              TextFormField(
                autofocus: _nameAutoFocus,
                controller: _originalPWController,
                decoration: InputDecoration(
                  labelText: 'original PassWord',
                  hintText: 'Enter your old PassWord',
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
                  widget.handler(noEmpty());
                  widget.modifyFunc('originPassWord', _originalPWController.text);
                  return v.trim().isNotEmpty ? null : 'please enter old PassWord';
                },
              ),
              TextFormField(
                autofocus: _nameAutoFocus,
                controller: _newPWController,
                decoration: InputDecoration(
                  labelText: 'new PassWord',
                  hintText: 'Enter your new PassWord',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(newPwdShow ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        newPwdShow = !newPwdShow; 
                      });
                    },
                  )
                ),
                obscureText: !newPwdShow,
                validator: (v) {
                  widget.handler(noEmpty());
                  widget.modifyFunc('passWord', _newPWController.text);
                  return v.trim().isNotEmpty ? null : 'please enter new PassWord';
                },
              ),
              TextFormField(
                autofocus: _nameAutoFocus,
                controller: _newPWAgainController,
                decoration: InputDecoration(
                  labelText: 'new PassWord again',
                  hintText: 'Enter your new PassWord again',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(newPwdAgainShow ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        newPwdAgainShow = !newPwdAgainShow; 
                      });
                    },
                  )
                ),
                obscureText: !newPwdAgainShow,
                validator: (v) {
                  widget.handler(noEmpty());
                  widget.modifyFunc('newPassWordAgain', _newPWAgainController.text);
                  return v.trim().isNotEmpty ? null : 'please enter new PassWord again';
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}