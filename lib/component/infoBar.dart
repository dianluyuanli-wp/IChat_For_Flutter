import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PersonInfoBar extends StatelessWidget {
  PersonInfoBar({
    @required this.infoMap
  });

  final Map infoMap;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffffffff)
      ),
      child: Row(
        children: <Widget>[
          Image(
            image: CachedNetworkImageProvider(infoMap['avatar']),
            height: 70,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsetsDirectional.only(bottom: 8),
                child: Text(infoMap['nickName']),
              ),
              Text('chatId: ' + infoMap['user'])
            ],
          )
        ],
      ),
    );
  }
}