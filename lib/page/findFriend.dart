import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../global.dart';
import '../tools/utils.dart';
import '../tools/network.dart';

class FindFriend extends StatefulWidget {
  @override
  _FindFriendState createState() => _FindFriendState();
}

class _FindFriendState extends State<FindFriend> {
  TextEditingController _searchController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Provider.of<MySocketIO>(context).mySocket.emit('register', Provider.of<UserModle>(context).user);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Form(
          autovalidate: true,
          key: _formKey,
          child: Container(
            margin: EdgeInsets.only(top: 15),
            child: TextFormField(
              autofocus: false,
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'chatId',
                hintText: 'Search',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    //borderSide: BorderSide.none
                ),
                prefixIcon: Icon(Icons.people),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: serchFriend,
                )
              ),
              validator: (v) {
                return v.trim().isNotEmpty ? null : 'please input the chatId you want to search';
              },
            )
          )
        )
      ],
    );
  }

  void serchFriend() async {
    String searchContent = _searchController.text;
    print(Provider.of<UserModle>(context).user);
    if (searchContent == Provider.of<UserModle>(context).user) {
      showToast('不能搜索自己', context);
      return;
    }
    var res;
    res = await Network.get('searchName', {'searchName': searchContent});
    print(res);
  }
}