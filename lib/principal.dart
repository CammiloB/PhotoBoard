import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ejemplo_construccion/dummies/chats.dart';
import 'widget/color/light_color.dart';
import 'package:ejemplo_construccion/camera.dart';
import 'widget/global_card.dart';

class PrincipalPage extends StatelessWidget {
  final CameraDescription camera;
  const PrincipalPage({Key key, @required this.camera}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed() {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want to exit an App'),
              actions: <Widget>[
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Text("NO"),
                ),
                SizedBox(height: 16),
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(true),
                  child: Text("YES"),
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          primaryColor: Colors.blueGrey[900],
          primaryColorDark: Colors.blueGrey[900],
          accentColor: Colors.blueGrey[900]),
      home: MyHomePage(
        title: 'PhotoBoard',
        camera: this.camera,
      ),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title, this.camera}) : super(key: key);
  final String title;
  final CameraDescription camera;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  DateTime dateTime;
  Duration duration;

  TabController _tabController;
  @override
  void initState() {
    dateTime = DateTime.now();
    duration = Duration(minutes: 10);
    super.initState();
    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0.5,
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: 'Horario'),
            Tab(
              text: 'Materias',
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ListView(
            children: <Widget>[
              SizedBox(height: 50),
              SingleChildScrollView(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(children: <Widget>[
                    GlobalSituationCard(
                      cardTitle: 'Recovered CASES',
                      caseTitle: 'Recovered',
                      currentData: 10000,
                      newData: 777777777,
                      percentChange: 100,
                      cardColor: CardColors.blue,
                      icon: Icon(
                        Icons.arrow_upward,
                        color: Colors.green,
                      ),
                      color: Colors.green,
                    ),
                    GlobalSituationCard(
                      cardTitle: 'Recovered CASES',
                      caseTitle: 'Recovered',
                      currentData: 10000,
                      newData: 777777777,
                      percentChange: 100,
                      cardColor: CardColors.blue,
                      icon: Icon(
                        Icons.arrow_upward,
                        color: Colors.green,
                      ),
                      color: Colors.green,
                    ),
                    GlobalSituationCard(
                      cardTitle: 'Recovered CASES',
                      caseTitle: 'Recovered',
                      currentData: 10000,
                      newData: 777777777,
                      percentChange: 100,
                      cardColor: CardColors.blue,
                      icon: Icon(
                        Icons.arrow_upward,
                        color: Colors.green,
                      ),
                      color: Colors.green,
                    ),
                  ]))
            ],
          ),
          ListView.builder(
              itemCount: dataDummy.length,
              itemBuilder: (context, i) => new Column(
                    children: <Widget>[
                      new Divider(
                        height: 10,
                      ),
                      new ListTile(
                        leading: new CircleAvatar(
                            //backgroundImage: new NetworkImage(dataDummy[i].avatar),
                            ),
                        title: new Text(dataDummy[i].title),
                        subtitle: new Text(dataDummy[i].message),
                      )
                    ],
                  ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  TakePictureScreen(camera: widget.camera)));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
