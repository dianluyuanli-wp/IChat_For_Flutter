import 'package:flutter/material.dart';
import 'package:i_chat/page/myAccount.dart';
import 'page/logIn.dart';
import 'package:provider/provider.dart';
import 'global.dart';
import 'page/findFriend.dart';
import 'page/modify/modify.dart';
import 'page/friendList.dart';
import 'page/chat.dart';
import './page/friendInfo.dart';
import 'tools/utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() => Global.init().then((e) => runApp(MyApp(info: e)));

class MyApp extends StatelessWidget with CommonInterface {
  MyApp({Key key, this.info}) : super(key: key);
  final info;
  // This widget is the root of your application.
  //  根容器，用来初始化provider
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
      child: ContextContainer(),
    );
  }
}

class ContextContainer extends StatefulWidget {
  @override
  _ContextContainerState createState() => _ContextContainerState();
}

class _ContextContainerState extends State<ContextContainer> with CommonInterface {
  //  上下文容器，主要用来注册登记和传递根上下文
  @override
  Widget build(BuildContext context) {
    cMysocket(context).emit('register', cUser(context));
    return ListenContainer(rootContext: context);
  }
}

class ListenContainer extends StatefulWidget {
  ListenContainer({Key key, this.rootContext})
  : super(key: key);

  final BuildContext rootContext;
  @override
  _ListenContainerState createState() => _ListenContainerState();
}

class _ListenContainerState extends State<ListenContainer> with CommonInterface {
  //  用来记录chat组件是否存在的全局key
  final GlobalKey<ChatState> myK = GlobalKey<ChatState>();
  //  注册路由的组件，删好友每次pop的时候都会到这里，上下文都会刷新
  @override
  Widget build(BuildContext context) {
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
          '/': (context) => Provider.of<UserModle>(context).isLogin ? MyHomePage(myK: myK, originCon: widget.rootContext, toastContext: context) : LogIn(),
          'chat': (context) => Chat(key: myK),
          'modify': (context) => Modify(),
          'friendInfo': (context) => FriendInfoRoute()
        }
      );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.myK, this.originCon, this.toastContext})
  : super(key: key);

  final GlobalKey<ChatState> myK;
  final BuildContext originCon;
  final BuildContext toastContext;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with CommonInterface{
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    registerNotification();
    return Scaffold(
      appBar: AppBar(
        title: TitleContent(index: _selectedIndex),
      ),
      body: MiddleContent(index: _selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text('Friends')),
          BottomNavigationBarItem(
            icon: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Icon(Icons.find_in_page),
                cUsermodal(context).friendRequest.length > 0 ? Positioned(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  left: 15,
                  top: -2,
                ) : null,
              ].where((item) => item != null).toList()
            ),
            title: Text('Contacts')),
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

  void registerNotification() {
    //  这里的上下文必须要用根上下文，因为listencontainer组件本身会因为路由重建，导致上下文丢失，全局监听事件报错找不到组件树
    BuildContext rootContext = widget.originCon;
    UserModle newUserModel = cUsermodal(rootContext);
    Message mesArray = Provider.of<Message>(rootContext);
    //  聊天信息
    if(!cMysocket(rootContext).hasListeners('chat message')) {
      cMysocket(rootContext).on('chat message', (msg) {
        String owner = msg['owner'];
        String message = msg['message'];
        SingleMesCollection mesC = mesArray.getUserMesCollection(owner);
        if (mesC.bothOwner == null) {
          mesArray.addItemToMesArray(owner, newUserModel.user, message);
        } else {
          cMesArr(rootContext).addMessRecord(owner, new SingleMessage(owner, message, new DateTime.now().millisecondsSinceEpoch));
        }
        //  非聊天环境
        if (widget.myK.currentState == null) {
          cMesCol(rootContext, owner).rankMark('receiver', owner);
        } else {
          //  聊天环境
          cMesCol(rootContext, owner).updateMesRank(cMysocket(rootContext), cUser(rootContext));
          widget.myK.currentState.slideToEnd();
        }
        updateBadger(rootContext);
      });
    }
    //  系统通知
    if(!cMysocket(rootContext).hasListeners('system notification')) {
      cMysocket(rootContext).on('system notification', (msg) {
        String type = msg['type'];
        Map message = msg['message'] == 'msg' ? {} : msg['message'];
        Map notificationMap = {
          'NOT_YOUR_FRIEND': () { showToast('对方开启好友验证，本消息无法送达', cUsermodal(rootContext).toastContext); },
          'NEW_FRIEND_REQ': () {
            cUsermodal(rootContext).addFriendReq(message);
          },
          'REQ_AGREE': () {
            if (cUsermodal(rootContext).friendsList.firstWhere((item) => item.user == message['userName'], orElse: () => null) == null) {
              cUsermodal(rootContext).friendsListJson.insert(0, { 'userName': message['userName'], 'nickName': message['nickName'], 'avatar': message['avatar'] });
              cUsermodal(rootContext).notifyListeners();
            }
          }
        };
        notificationMap[type]();
      });
    }
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
