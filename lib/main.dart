import 'package:flutter/material.dart';
import 'package:i_chat/page/myAccount.dart';
import 'page/logIn.dart';
import 'package:provider/provider.dart';
import 'global.dart';
import 'page/findFriend.dart';
import 'page/modify/modify.dart';
import 'page/friendList.dart';
import 'page/chat.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() => Global.init().then((e) => runApp(MyApp(info: e)));

class MyApp extends StatelessWidget with CommonInterface {

  MyApp({Key key, this.info}) : super(key: key);
  final info;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    UserModle newUserModel = new UserModle();
    Message messList = Message.fromJson(info['messageArray']);
    IO.Socket mysocket = info['socketIO'];
    return MultiProvider(
      providers: [
        //  用户信息
        ListenableProvider<UserModle>.value(value: newUserModel),
        //  websocket 实例
        Provider<MySocketIO>.value(value: new MySocketIO(mysocket)),
        //  聊天信息
        ListenableProvider<Message>.value(value: messList)
      ],
      child: ListenContainer(),
    );
  }
}

class ListenContainer extends StatefulWidget {
  @override
  _ListenContainerState createState() => _ListenContainerState();
}

class _ListenContainerState extends State<ListenContainer> with CommonInterface {
  final GlobalKey<ChatState> myK = GlobalKey<ChatState>();
  @override
  Widget build(BuildContext context) {
    UserModle newUserModel = cUsermodal(context);
    Message mesArray = Provider.of<Message>(context);
    if(!cMysocket(context).hasListeners('chat message')) {
      cMysocket(context).on('chat message', (msg) {
        String owner = msg['owner'];
        String message = msg['message'];
        SingleMesCollection mesC = mesArray.getUserMesCollection(owner);
        if (mesC.bothOwner == null) {
          mesArray.addItemToMesArray(owner, newUserModel.user, message);
        } else {
          cMesArr(context).addMessRecord(owner, new SingleMessage(owner, message, new DateTime.now().millisecondsSinceEpoch));
        }
        //  非聊天环境
        if (myK.currentState == null) {
          cMesCol(context, owner).rankMark('receiver', owner);
        } else {
          //  聊天环境
          cMesCol(context, owner).updateMesRank(cMysocket(context), cUser(context));
          myK.currentState.slideToEnd();
        }
      });
    }
    cMysocket(context).emit('register', newUserModel.user);
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Provider.of<UserModle>(context).isLogin ? MyHomePage() : LogIn(),
          'chat': (context) => Chat(key: myK),
          'modify': (context) => Modify(),
        }
      );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with CommonInterface{
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TitleContent(index: _selectedIndex),
      ),
      body: MiddleContent(index: _selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text('Friends')),
          BottomNavigationBarItem(icon: Icon(Icons.find_in_page), title: Text('Contacts')),
          BottomNavigationBarItem(icon: Icon(Icons.my_location), title: Text('Me')),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; 
    });
  }
}

class MiddleContent extends StatelessWidget {
  MiddleContent({Key key, this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final contentMap = {
      0: FriendList(),
      1: FindFriend(),
      2: MyAccount()
    };
    return contentMap[index];
  }
}

class TitleContent extends StatelessWidget {
  TitleContent({Key key, this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    const contentMap = {
      0: 'IChat',
      1: 'Concats',
      2: 'Me'
    };
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: <Widget>[Text(contentMap[index])]
    );
  }
}
