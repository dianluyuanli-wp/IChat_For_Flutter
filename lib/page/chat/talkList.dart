import 'dart:math';
import 'package:flutter/material.dart';
import '../../tools/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../global.dart';
import '../../tools/network.dart';

class TalkList extends StatefulWidget {
  TalkList({Key key, @required this.scrollController})
  : super(key: key);
  final ScrollController scrollController;
  @override
  _TalkLitState createState() => _TalkLitState();
}

class _TalkLitState extends State<TalkList> with CommonInterface {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      // if (widget.scrollController.position.pixels == 10) {
      //   _getMoreMessage();
      // }
    });
    //widget.scrollController.jumpTo(widget.scrollController.position.maxScrollExtent);
  }

  int get acculateReqLength {
    SingleMesCollection mesCollection = cTalkingCol(context);
    int user1flag = mesCollection.user1flag;
    int user2flag = mesCollection.user2flag;
    int currentMesLength = mesCollection.message.length;
    int diff = max(user1flag ?? currentMesLength, user2flag ?? currentMesLength) - currentMesLength;
    return diff > 15 ? 15 : (diff > 0 ? diff : 0);
  }

  _getMoreMessage() async {
    if (!isLoading) {
      if (acculateReqLength == 0) {
        return;
      }
      setState(() {
       isLoading = true;
      });
      SingleMesCollection collection = cTalkingCol(context);
      var res = await Network.get('getMoreMessage', {
        'currentLength': collection.message.length,
        'toFriend': cSayto(context),
        'userName': cUser(context),
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
    SingleMesCollection mesCol = cTalkingCol(context);
    return Expanded(
            child: Container(
              color: Color(0xfff5f5f5),
              child: NotificationListener<OverscrollNotification>(
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
                        ),
                      );
                    }
                    return MessageContent(mesList: mesCol.message, rank:index);
                  },
                  itemCount: mesCol.message.length + 1,
                  controller: widget.scrollController,
                ),
                onNotification: (OverscrollNotification notification) {
                  if (widget.scrollController.position.pixels <= 10) {
                    _getMoreMessage();
                  }
                  return true;
                },
              )
            )
          );
  }
}

class MessageContent extends StatelessWidget with CommonInterface {
  MessageContent({Key key, this.mesList, this.rank}) : super(key: key);
  final List<SingleMessage> mesList;
  final int rank;

  @override
  Widget build(BuildContext context) {
    UserModle userModel = cUsermodal(context);
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
                constraints: BoxConstraints(maxWidth: 240),
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