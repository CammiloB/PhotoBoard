import 'package:flutter/material.dart';
import 'package:photoboard/matter/dummies/chats.dart';
import 'package:photoboard/camera/camera.dart';
import 'widget/color/light_color.dart';
import 'widget/global_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrincipalPage extends StatelessWidget {
  final String pageId;
  final String userId;

  PrincipalPage({Key key, @required this.pageId, @required this.userId}) : super(key: key) {}

  @override
  Widget build(BuildContext context) {

    return  MaterialApp(
          theme: ThemeData(
              primarySwatch: Colors.blueGrey,
              primaryColor: Colors.blueGrey[900],
              primaryColorDark: Colors.blueGrey[900],
              accentColor: Colors.blueGrey[900]),
          home: MyHomePage(
            title: 'PhotoBoard',
            pageId: pageId,
            userId: userId,
          ),
        );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title, this.pageId, this.userId}) : super(key: key);
  final String title;
  final String pageId;
  final String userId;

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

  Future<String> getMatter = Future<String>.delayed(
    Duration(seconds: 5),
    () => Firestore.instance.collection('matters').document('8LKJSepMjMPkMCy39lWelaVo9no2').get().then((value) => value['name'])
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getMatter,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        Widget title = Text(snapshot.data);

        return Scaffold(
      appBar: AppBar(
        title: title,
        elevation: 0.5,
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: 'Galeria'),
            Tab(
              text: 'descripción',
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
                      SizedBox(height: 60,),
                      Material(
                          elevation: 8.2,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            backgroundColor: Color(0xFF616161),
                            child: new Image.network('https://image.freepik.com/vector-gratis/diseno-logo-phoenix_111165-14.jpg',
                              width: 120.0,
                              height: 145.0,
                            ),
                            radius: 65.0,
                          )),
                          
                          new Text('Ingles', style: TextStyle(fontSize: 32),),
                          Center(
                          child: new Text('clase ingles nivel 2, horario 7 - 8 am  ', style: TextStyle(fontSize: 22),)                       
                          ),
                      /*
                      new Divider(
                        height: 600,
                      ),
                      new ListTile(
                        leading: new CircleAvatar(
                            //backgroundImage: new NetworkImage(dataDummy[i].avatar),
                            ),
                        title: new Text(dataDummy[i].title),
                        subtitle: new Text(dataDummy[i].message),
                      )*/
                    ],
                  ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (BuildContext context) => ProfilePage(
                userId: widget.userId,
              )));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add, color: Colors.white),
      ),
      );});
  }
}
