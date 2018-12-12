//import 'package:firebase_core/firebase_core.dart';
//import 'package:talkmonkey/fb_config.dart';
import 'package:flutter/material.dart';
import 'package:talkmonkey/game_page.dart';

//
//Future<Null> configure() async {
//  final FirebaseApp app = await FirebaseApp.configure(
//    name: 'TalkMonkey',
//    options: options,
//  );
//
//  assert(app != null);
//  print('Configured $app');
//}

Future main() async {
//  await configure();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speak Monkey',
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
        primarySwatch: Colors.red,
        primaryColor: Color(0xFFFF6783),
      ),
      home: MyHomePage(title: 'Speak Monkey'),
      routes: {'/game/level1': (context) => GamePage()},
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
//            Text(
//              'You have pushed the button this many times:',
//            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.display1,
//            ),
            SizedBox(
              height: 30.0,
            ),

            Expanded(
              child: ListView.builder(
                itemBuilder: (context, i) => (i == 0)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            Text('Learn to speak Monkey',
                                style: TextStyle(
                                    fontSize: 26.0, color: Color(0xFF47A787)))
                          ])
                    : LevelListItem(i: i),
                itemCount: 6,
                shrinkWrap: true,
              ),
            )
          ],
        ),
      ), //This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class LevelListItem extends StatelessWidget {
  final int i;

  const LevelListItem({Key key, this.i}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextStyle styleTitle = TextStyle(color: Colors.white, fontSize: 26.0);
    TextStyle styleSub = TextStyle(color: Colors.white70, fontSize: 20.0);

    return InkWell(
        onTap: () => Navigator.of(context).pushNamed('/game/level1'),
        child: new Container(
            height: 120.0,
            margin: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 24.0,
            ),
            child: Card(
              color: Color(0xFF4d6ff8),
              child: new Stack(
                children: <Widget>[
                  Container(
                    height: 124.0,
                    margin: new EdgeInsets.only(left: 46.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Level ${(i).toString()}',
                            style: styleTitle,
                            textAlign: TextAlign.center,
                          ),
                          (i == 1)
                              ? Text(
                                  'The Approach',
                                  style: styleSub,
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  'Comming Soon',
                                  style: styleSub,
                                  textAlign: TextAlign.center,
                                ),
                        ]),
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: new BorderRadius.circular(8.0),
                      boxShadow: <BoxShadow>[
//                        new BoxShadow(
//                          color: Colors.black12,
//                          blurRadius: 2.0,
//                          offset: new Offset(0.0, 1.0),
//                        ),
                      ],
                    ),
                  ),
                  Container(
//  margin: new EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.bottomRight,
                    child: (i == 1)
                        ? new Image(
                            image: new AssetImage('assets/level1.png'),
                            fit: BoxFit.contain,
                          )
                        : SizedBox(),
                  ),
                  Container(
                    height: 124.0,
                    margin: new EdgeInsets.only(left: 46.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Level ${(i).toString()}',
                            style: styleTitle,
                            textAlign: TextAlign.center,
                          ),
                          (i == 1)
                              ? Text(
                                  'The Approach',
                                  style: styleSub,
                                  textAlign: TextAlign.center,
                                )
                              : Text(
                                  'Comming Soon',
                                  style: styleSub,
                                  textAlign: TextAlign.center,
                                ),
                        ]),
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: new BorderRadius.circular(8.0),
                      boxShadow: <BoxShadow>[
//                        new BoxShadow(
//                          color: Colors.black12,
//                          blurRadius: 2.0,
//                          offset: new Offset(0.0, 1.0),
//                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));

//      child: Padding(
//          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
//          child: Stack(
//            fit: StackFit.loose,
//            children: <Widget>[
//              Positioned(
//                left: 0.0,
//                right: 0.0,
//                child: Container(
//                    height: 114.0,
//                    child: Column(
//                      children: <Widget>[
//                        Text('Level ${(i + 1).toString()}'),
//                        (i == 0) ? Text('The Approach') : Text('Comming Soon'),
//                      ],
//                    ),
//                    decoration: BoxDecoration(
//                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                        color: Colors.black.withOpacity(0.1))),
//              ),
//              Positioned(
//                top: 0.0,
//                left: 0.0,
//                right: 0.0,
//                child: Container(
//                  height: 200.0,
//                  child: (i == 0)
//                      ? Image.asset(
//                          'assets/level1.png',
//                          fit: BoxFit.cover,
//                        )
//                      : SizedBox(),
//                ),
//              )
//            ],
//          )),
  }
}
