import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
        '/': (context) => MyHomePage(),
        'chat': (context) => Chat(),
      }
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
          itemCount: 100,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(title: Text('$index'), onTap: () => {enterTalk(context)});
          },
          separatorBuilder: (BuildContext contet, int index) {
            return index % 2 == 0 ? Divider(color: Colors.blue) : Divider(color: Colors.green,);
          },
        )
      ),
      1: Text('找朋友'),
      2: Text('我自己')
    };
    return contentMap[index];
  }

  void enterTalk(context) {
    Navigator.pushNamed(context, 'chat');
    print('enter Talk !!!!');
  }
}

class TitleContent extends StatelessWidget {
  TitleContent({Key key, this.index}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    const contentMap = {
      0: '好基友',
      1: '找朋友',
      2: '我自己'
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
