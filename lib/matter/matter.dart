import 'package:flutter/material.dart';
import 'package:photoboard/matter/dummies/chats.dart';
import 'package:photoboard/camera/camera.dart';
import 'widget/color/light_color.dart';
import 'widget/global_card.dart';

class PrincipalPage extends StatelessWidget {
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
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

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
                            child: new Image.network('https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.abc.es%2Fplay%2Fpelicula%2Flos-aristogatos-9442%2F&psig=AOvVaw3ccdGHwkZ9YlngnOQVcnus&ust=1588570870900000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCMjJo-b9lukCFQAAAAAdAAAAABAD',
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
              builder: (BuildContext context) => ProfilePage()));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
