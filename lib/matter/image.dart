import 'package:flutter/material.dart';
import 'widget/color/light_color.dart';
import 'package:photoboard/matter/widget/utils/margin.dart';

class ImagePage extends StatelessWidget {
  final String imageUrl;

  ImagePage({Key key, @required this.imageUrl}) : super(key: key) {}

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
        imageUrl: imageUrl,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title, this.imageUrl}) : super(key: key);
  final String title;
  final String imageUrl;

  @override
  _MyHomePageState createState() => _MyHomePageState(imageUrl: imageUrl);
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  DateTime dateTime;
  Duration duration;

  final String imageUrl;
  _MyHomePageState({Key key, @required this.imageUrl});

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
    DecorationImage backgroundPhoto = new DecorationImage(
      image: new NetworkImage(this.imageUrl),
      fit: BoxFit.cover,
    );

    return GestureDetector(
        child: Stack(
      children: <Widget>[
        Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Container(
                  width: screenWidth(context),
                  height: screenHeight(context, percent: 0.9),
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    image: backgroundPhoto,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.18),
                          blurRadius: 20,
                          spreadRadius: 3.5,
                          offset: Offset(0, 13)),
                    ],
                  )),
              FloatingActionButton(
                onPressed: () {
                  print("Eliminae");
                },
                tooltip: 'Increment',
                child: Icon(Icons.delete, color: Colors.red),
              )
            ],
          ),
        ),
      ],
    ));
  }
}
