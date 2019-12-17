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

class MyApp extends StatelessWidget {

  MyApp({Key key, this.info}) : super(key: key);
  final info;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // IO.Socket socket = IO.io('http://tangshisanbaishou.xyz', <String, dynamic>{
    //   'transports': ['websocket'],
    //   'path': '/mySocket'
    // });
    // socket.emit('register', 'wang');
    //print(info);
    return MultiProvider(
      providers: [
        //  用户信息
        ListenableProvider<UserModle>.value(value: new UserModle()),
        //  websocket 实例
        Provider<MySocketIO>.value(value: new MySocketIO(info['socketIO'])),
        //  聊天信息
        ListenableProvider<Message>.value(value: Message.fromJson(info['messageArray']))
      ],
      child: MaterialApp(
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
          'chat': (context) => Chat(),
          'modify': (context) => Modify(),
        }
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
