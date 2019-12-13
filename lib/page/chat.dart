import 'dart:math';
import 'package:flutter/material.dart';
import '../tools/utils.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../global.dart';
import '../tools/network.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}
class _ChatState extends State<Chat> {
  ScrollController _scrollController = ScrollController(initialScrollOffset: 900.0);
  bool isLoading = false;
  TextEditingController _messController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels <= 10) {
        print(_scrollController.position.minScrollExtent);
        _getMoreMessage();
      }
    });
  }

  int get acculateReqLength {
    String sayTo = Provider.of<UserModle>(context).sayTo;
    SingleMesCollection mesCollection = Provider.of<Message>(context).getUserMesCollection(sayTo);
    int user1flag = mesCollection.user1flag;
    int user2flag = mesCollection.user2flag;
    int diff = max(user1flag, user2flag) - mesCollection.message.length;
    return diff > 15 ? 15 : (diff > 0 ? diff : 0);
  }

  _getMoreMessage() async {
    print('scroll');
    if (!isLoading) {
      if (acculateReqLength == 0) {
        return;
      }
      setState(() {
       isLoading = true;
      });
      String sayTo = Provider.of<UserModle>(context).sayTo;
      SingleMesCollection collection = Provider.of<Message>(context).getUserMesCollection(sayTo);
      var res = await Network.get('getMoreMessage', {
        'currentLength': collection.message.length,
        'toFriend': sayTo,
        'userName': Provider.of<UserModle>(context).user,
        'length': acculateReqLength
      });
      List<SingleMessage> addList = res.data['message'].map<SingleMessage>((item) {
        return SingleMessage.fromJson(item);
      }).toList();
      collection.message.insertAll(0, addList);
      setState(() {
       isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String sayTo = Provider.of<UserModle>(context).sayTo;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // IconButton(
              //   icon: Icon(Icons.find_replace, color: Colors.white),
              //   onPressed: () => Navigator.pop(context),
              // ),
              Transform.translate(
                offset: Offset(-30, 0),
                child: Text('聊天'),
              ),
            ],
          ),
        ),
      ),
      body: Column(children: <Widget>[
          Expanded(
            child: Container(
              color: Color(0xfff5f5f5),
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  //  滚动的菊花
                  if (index == 0) {
                    return acculateReqLength == 0
                    ? Center(
                      child: Text('一一没有更多消息了一一')
                    )
                    : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Center(
                        child: new Opacity(
                          opacity: isLoading ? 1.0 : 0.0,
                          child: new CircularProgressIndicator(),
                        ),
                        //child: new CircularProgressIndicator()
                      ),
                    );
                  }
                  return MessageContent(mesList: Provider.of<Message>(context).getUserMesCollection(sayTo).message, rank:index);
                },
                itemCount: Provider.of<Message>(context).getUserMesCollection(sayTo).message.length,
                controller: _scrollController,
              ),
            )
          ),
          Form(
            key: _formKey,
            child: Container(
              color: Color(0xfff5f5f5),
              //margin: EdgeInsets.only(top: 15),
              child: TextFormField(
                autofocus: false,
                controller: _messController,
                decoration: InputDecoration(
                  // labelText: 'chatId',
                  hintText: 'You wanna to say',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      //borderSide: BorderSide.none
                  ),
                  prefixIcon: Icon(Icons.people),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.message),
                    onPressed: sendMess,
                  )
                ),
                validator: (v) {
                  return v.trim().isNotEmpty ? null : 'please input the chatId you want to search';
                },
              )
            )
          )
        ],
      ),
    );
  }

  void sendMess() {
    print(_messController.text);
  }
}

class MessageContent extends StatelessWidget {
  MessageContent({Key key, this.mesList, this.rank}) : super(key: key);
  final List<SingleMessage> mesList;
  final int rank;

  @override
  Widget build(BuildContext context) {
    UserModle userModel = Provider.of<UserModle>(context);
    String image = userModel.avatar;
    int trueRank = rank - 1;
    SingleMessage info = mesList[trueRank];
    bool showOnLeft = info.owner != userModel.user;
    bool showTimeOrNot = trueRank > 0 ? info.timeStamp - mesList[trueRank - 1].timeStamp > 10 * 60 * 1000 : true;
    return Container(
      child: Column(
        children: <Widget>[
          showTimeOrNot ? Container(
            child: Text(getIimeStringForChat(info.timeStamp), style: TextStyle(
              color: Color(0xffffffff)
            )),
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Color(0xffdadada),
            ),
          ) : null,
          Row(
            textDirection: showOnLeft ? TextDirection.ltr : TextDirection.rtl,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(5),
                child: Image(
                    image: CachedNetworkImageProvider(showOnLeft ? userModel.findFriendInfo(info.owner)['avatar'] : image),
                    height: 30,
                    width: 30,
                    fit: BoxFit.fill
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: showOnLeft ? Color(0xffffffff) : Color(0xff98e165),
                  borderRadius: BorderRadius.circular(3.0)
                ),
                child: Text(info.content),
              )
            ],
          )
        ].where((item) => item != null).toList(),
      ),
    );
  }
}