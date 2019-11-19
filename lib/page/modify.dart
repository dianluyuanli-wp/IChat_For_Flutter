import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../global.dart';

class Modify extends StatefulWidget {
  @override
  _ModifyState createState() => new _ModifyState();
}

class _ModifyState extends State<Modify> {
  TextEditingController _nickNameController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  bool pwdShow = false;
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool _nameAutoFocus = true;

  Color saveColor = Colors.white; 



  @override
  Widget build(BuildContext context) {
    final Map arg = ModalRoute.of(context).settings.arguments;
    String oldNickname = Provider.of<UserModle>(context).nickName;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: <Widget>[IconButton(
          icon: Icon(Icons.save_alt, color: saveColor),
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
      body: Padding(
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
                    //labelStyle: TextStyle(color: Colors.greenAccent),
                    labelText: 'NickName',
                    hintText: 'Enter your new nickname',
                    //hintStyle: TextStyle(color: Colors.red),
                    prefixIcon: Icon(Icons.notification_important)
                  ),
                  validator: (v) {
                    var result = v.trim().isNotEmpty ? (_nickNameController.text != oldNickname ? null : 'please enter another nickname') : 'required nickname';
                    //  不延迟的话会报渲染过程中重复setState的错
                    Future.delayed(Duration(milliseconds: 200)).then((e) {
                      setState(() {
                        saveColor = (result != null ? Color.fromRGBO(255, 255, 255, .5) : Colors.white);
                      });
                    });
                    return result;
                  },
                ),
                // TextFormField(
                //   controller: _pwdController,
                //   autofocus: !_nameAutoFocus,
                //   decoration: InputDecoration(
                //     // labelStyle: TextStyle(color: Colors.greenAccent),
                //     // hintStyle: TextStyle(color: Colors.greenAccent),
                //     labelText: 'PassWord',
                //     hintText: 'Enter Password',
                //     prefixIcon: Icon(Icons.lock),
                //     suffixIcon: IconButton(
                //       icon: Icon(pwdShow ? Icons.visibility_off : Icons.visibility),
                //       onPressed: () {
                //         setState(() {
                //         pwdShow = !pwdShow; 
                //         });
                //       },
                //     )
                //   ),
                //   obscureText: !pwdShow,
                //   validator: (v) {
                //     return v.trim().isNotEmpty ? null : 'required passWord';
                //   },
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 25),
                //   child: ConstrainedBox(
                //     constraints: BoxConstraints.expand(height: 55),
                //     child: RaisedButton(
                //       color: Theme.of(context).primaryColor,
                //       onPressed: _onLogin,
                //       textColor: Colors.white,
                //       child: Text('Login'),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
    );
  }
}
