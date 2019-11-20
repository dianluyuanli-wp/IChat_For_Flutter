import 'package:flutter/material.dart';
import 'package:i_chat/page/myAccount.dart';
import 'page/logIn.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import 'model/User.dart';
import 'global.dart';
import 'page/modify/modify.dart';

void main() => Global.init().then((e) => runApp(MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<UserModle>.value(value: new UserModle())
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
          //MyHomePage(),
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
      0: Scrollbar(
        child: ListView.separated(
          itemCount: Provider.of<UserModle>(context).friendsList.length,
          itemBuilder: (BuildContext context, int index) {
            //return ListTile(title: Text('$index'), onTap: () => {enterTalk(context)});
            Map friendInfo = Provider.of<UserModle>(context).friendsList[index];
            return GestureDetector(
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 360,
                  maxHeight: 55
                ),
                decoration: BoxDecoration(
                  color: Colors.black12
                ),
                child: Row(
                  children: <Widget>[
                    Image(
                      image: CachedNetworkImageProvider(friendInfo['avatar']),
                      width: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 7, 0, 7),
                          child: Text(friendInfo['nickName']),
                        ),
                        Text('大家好1111111111111')
                      ],
                    )
                  ],
                ),
              ),
              onTap: () => {enterTalk(context)}
            );
          },
          separatorBuilder: (BuildContext contet, int index) {
            return index % 2 == 0 ? Divider(color: Colors.blue) : Divider(color: Colors.green,);
          },
        )
      ),
      1: Text('找朋友'),
      2: MyAccount()
    };
    return contentMap[index];
  }

  void enterTalk(context) {
    Navigator.pushNamed(context, 'chat');
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

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        child: Text('小明和女神聊天'),
      ),
    );
  }
}
