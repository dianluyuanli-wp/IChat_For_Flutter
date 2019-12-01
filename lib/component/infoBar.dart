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
          Container(
            height: 70,
            padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
            child: Image(
              image: CachedNetworkImageProvider(infoMap['avatar']),
              height: 50,
              width: 50,
              fit: BoxFit.fill
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsetsDirectional.only(bottom: 8),
                child: Text(infoMap['nickName'] ?? 'dddd'),
              ),
              Text('chatId: ' + infoMap['user'])
            ],
          )
        ],
      ),
    );
  }
}