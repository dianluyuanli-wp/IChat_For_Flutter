import 'package:flutter/material.dart';
import 'package:i_chat/page/modify/avatar.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../global.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}
class _ChatState extends State<Chat> {
  ScrollController _scrollController = ScrollController(initialScrollOffset: 900.0);
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.minScrollExtent) {
        print('滑到顶部');
      }
    });
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
      body: Center(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return MessageContent(info: Provider.of<Message>(context).getUserMesCollection(sayTo).message[index]);
          },
          itemCount: Provider.of<Message>(context).getUserMesCollection(sayTo).message.length,
          controller: _scrollController,
        ),
      ),
    );
  }
}

class MessageContent extends StatelessWidget {
  MessageContent({Key key, this.info}) : super(key: key);
  final SingleMessage info;
  @override
  Widget build(BuildContext context) {
    String image = Provider.of<UserModle>(context).avatar;
    return Container(
      child: Column(
        children: <Widget>[
          Text('time'),
          Row(
            children: <Widget>[
              Image(
                  image: CachedNetworkImageProvider(image),
                  height: 50,
                  width: 50,
                  fit: BoxFit.fill
              ),
              Text(info.content)
            ],
          )
        ],
      ),
    );
  }
}