import 'package:flutter/material.dart';
import 'package:photoboard/matter/dummies/chats.dart';
import 'package:photoboard/camera/camera.dart';
import 'widget/color/light_color.dart';
import 'widget/global_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PrincipalPage extends StatelessWidget {
  final String pageId;
  final String userId;

  PrincipalPage({Key key, @required this.pageId, @required this.userId})
      : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  const MyHomePage({Key key, this.title, this.pageId, this.userId})
      : super(key: key);
  final String title;
  final String pageId;
  final String userId;

  @override
  _MyHomePageState createState() => _MyHomePageState(pageId: pageId);
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  DateTime dateTime;
  Duration duration;

  final String pageId;
  _MyHomePageState({Key key, @required this.pageId});

  TabController _tabController;
  @override
  void initState() {
    dateTime = DateTime.now();
    duration = Duration(minutes: 10);
    super.initState();
    _tabController = TabController(vsync: this, length: 2, initialIndex: 0);
  }

  Widget _buildMatters(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('matters')
          .document(widget.pageId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data['photos']);
      },
    );
  }

  Widget _buildList(BuildContext context, List<dynamic> snapshot) {
    return Column(
      children: snapshot
          .map<Widget>(
            (matter) => Column(children: [
              GlobalSituationCard(
                  percentChange: matter['date'],
                  cardColor: CardColors.blue,
                  icon: Icon(
                    Icons.arrow_upward,
                    color: Colors.green,
                  ),
                  color: Colors.green,
                  url: matter['url']),
            ]),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<String> getMatter = Future<String>.delayed(
        Duration(seconds: 0),
        () => Firestore.instance
            .collection('matters')
            .document(this.pageId)
            .get()
            .then((value) => value['name']));

    Future<String> getDesc = Future<String>.delayed(
        Duration(seconds: 0),
        () => Firestore.instance
            .collection('matters')
            .document(this.pageId)
            .get()
            .then((value) => value['description']));

    return FutureBuilder<String>(
        future: getMatter,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget title;

          if (snapshot.hasData) {
            title = Text(
              snapshot.data,
              style: TextStyle(fontSize: 32),
            );
          } else if (snapshot.hasError) {
            title = Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            );
          } else {
            title = CircularProgressIndicator();
          }

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
                    _buildMatters(context),
                  ],
                ),
                ListView.builder(
                    itemCount: dataDummy.length,
                    itemBuilder: (context, i) => new Column(
                          children: <Widget>[
                            SizedBox(
                              height: 60,
                            ),
                            Material(
                                elevation: 8.2,
                                shape: CircleBorder(),
                                child: CircleAvatar(
                                  backgroundColor: Color(0xFF616161),
                                  child: new Image.network(
                                    'https://image.freepik.com/vector-gratis/diseno-logo-phoenix_111165-14.jpg',
                                    width: 120.0,
                                    height: 145.0,
                                  ),
                                  radius: 65.0,
                                )),
                            title,
                            FutureBuilder<String>(
                              future: getDesc,
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                Widget title;
                                if (snapshot.hasData) {
                                  title = Text(snapshot.data,
                                      style: TextStyle(fontSize: 22));
                                } else if (snapshot.hasError) {
                                  title = Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 60,
                                  );
                                } else {
                                  title = CircularProgressIndicator();
                                }
                                return Center(
                                  child: title);
                              },
                            )
                          ],
                        ))
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute<void>(
                    builder: (BuildContext context) => ProfilePage(
                          userId: widget.userId,
                          pageId: widget.pageId,
                        )));
              },
              tooltip: 'Increment',
              child: Icon(Icons.add, color: Colors.white),
            ),
          );
        });
  }
}
