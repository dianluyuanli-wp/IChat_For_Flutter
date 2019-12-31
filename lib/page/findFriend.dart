import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../global.dart';
import '../tools/utils.dart';
import '../tools/network.dart';
import '../component/infoBar.dart';

class FindFriend extends StatefulWidget {
  @override
  _FindFriendState createState() => _FindFriendState();
}

class _FindFriendState extends State<FindFriend> with CommonInterface {
  TextEditingController _searchController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  List<FriendInfo> resultList = [];

  @override
  Widget build(BuildContext context) {
    List<FriendInfo> friendReqList = cUsermodal(context).friendRequest.map<FriendInfo>((item) => FriendInfo.fromJson(item)).toList();
    return Container(
      color: Color(0xfff0eff5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Form(
            autovalidate: true,
            key: _formKey,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15),
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
          ),
          resultList.length > 0 ? Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return PersonInfoBar(infoMap: resultList[index], useButton: true, type: 'search',);
              },
              itemCount: resultList.length,
            )
          ) : null,
          friendReqList.length > 0 ? Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return PersonInfoBar(infoMap: friendReqList[index], useButton: true, type: 'friendReq');
              },
              itemCount: friendReqList.length,
            ),
          ) : null,
        ].where((item) => item != null).toList(),
      )
    );
  }

  void serchFriend() async {
    String searchContent = _searchController.text;
    if (searchContent == Provider.of<UserModle>(context).user) {
      showToast('不能搜索自己', context);
      return;
    }
    var res;
    res = await Network.get('searchName', {'searchName': searchContent});
    print(res.data);
    resultList = res.data.map<FriendInfo>((item) => FriendInfo.fromJson(item)).toList();
    print(res);
  }
}