import 'package:flutter/material.dart';
import 'package:photoboard/home/screens/calendar_page.dart';
import 'package:photoboard/home/theme/colors/light_colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:photoboard/home/widgets/task_column.dart';
import 'package:photoboard/home/widgets/active_project_card.dart';
import 'package:photoboard/home/widgets/top_container.dart';

import 'package:photoboard/home/widgets/CustomDialog.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photoboard/login/auth.dart';
import 'package:photoboard/matter/matter.dart';

import 'Dart:io';

class HomePage extends StatelessWidget {
  static const routeName = '/home';
  final String userId;

  HomePage({Key key, @required this.userId}) : super(key: key) {}

  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  static CircleAvatar calendarIcon() {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: LightColors.kGreen,
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  static CircleAvatar addIcon() {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: LightColors.kGreen,
      child: Icon(Icons.add, size: 20.0, color: Colors.white),
    );
  }

  Widget _buildMatters(BuildContext context)  {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('matter')
          .document(this.userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Scaffold(
          body: Text("No tienes materias para mostrar"),
        );
        return _buildList(context, snapshot.data['matters']);
      },
    );
  }

  _dialogAddRecDesp(BuildContext context){
    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(userId: this.userId);
      }
    );
  }

  Widget _buildList(BuildContext context, List<dynamic> snapshot) {
    return Column(
      children: snapshot
          .map<Widget>(
            (matter) => Column(children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                padding: EdgeInsets.all(15.0),
                height: 100,
                decoration: BoxDecoration(
                  color: LightColors.kGreen,
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: ListTile(
                  title: Center(
                      child: Text(
                    matter['name'],
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  )),
                  onTap: () => {
                    
                    Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (BuildContext context) => PrincipalPage(
                              pageId: matter['id'],
                              userId: this.userId
                            )))
                  },
                ),
              )
            ]),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    Future<String> getName = Future<String>.delayed(
        Duration(seconds: 5),
        () => Firestore.instance
            .collection('users')
            .document(this.userId)
            .get()
            .then((value) => value['name']));

    Future<bool> _onBackPressed() {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('¿Esta seguro?'),
              content: new Text('¿Quiere salir de la aplicación?'),
              actions: <Widget>[
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Text("No"),
                ),
                SizedBox(height: 16),
                new GestureDetector(
                  onTap: () => exit(0),
                  child: Text("Si"),
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: FutureBuilder<String>(
          future: getName,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            Widget children;
            if (snapshot.hasData) {
              children = Text(
                snapshot.data,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 22.0,
                  color: LightColors.kDarkBlue,
                  fontWeight: FontWeight.w800,
                ),
              );
            } else if (snapshot.hasError) {
              children = Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              );
            } else {
              children = CircularProgressIndicator();
            }

            return Scaffold(
              backgroundColor: LightColors.kLightYellow,
              body: SafeArea(
                child: Column(
                  children: <Widget>[
                    TopContainer(
                      height: 200,
                      width: width,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(Icons.menu,
                                    color: LightColors.kDarkBlue, size: 30.0),
                                Icon(Icons.search,
                                    color: LightColors.kDarkBlue, size: 25.0),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  CircularPercentIndicator(
                                    radius: 90.0,
                                    lineWidth: 5.0,
                                    animation: true,
                                    percent: 0.75,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: LightColors.kRed,
                                    backgroundColor: LightColors.kDarkYellow,
                                    center: CircleAvatar(
                                        backgroundColor: LightColors.kBlue,
                                        radius: 35.0,
                                        backgroundImage: new ExactAssetImage(
                                            'assets/foto1.png')),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: children,
                                      ),
                                      Container(
                                        child: Text(
                                          'App Developer',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black45,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ]),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      subheading('Mis tareas'),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CalendarPage(
                                                      userId: userId,
                                                    )),
                                          );
                                        },
                                        child: calendarIcon(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15.0),
                                  TaskColumn(
                                    icon: Icons.alarm,
                                    iconBackgroundColor: LightColors.kRed,
                                    title: 'Por Hacer',
                                    subtitle: '5 tasks now. 1 started',
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  TaskColumn(
                                    icon: Icons.blur_circular,
                                    iconBackgroundColor:
                                        LightColors.kDarkYellow,
                                    title: 'En Progreso',
                                    subtitle: '1 tasks now. 1 started',
                                  ),
                                  SizedBox(height: 15.0),
                                  TaskColumn(
                                    icon: Icons.check_circle_outline,
                                    iconBackgroundColor: LightColors.kBlue,
                                    title: 'Hecho',
                                    subtitle: '18 tasks now. 13 started',
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      subheading('Mis Materias'),
                                      GestureDetector(
                                        onTap: () {
                                          _dialogAddRecDesp(context);
                                        },
                                        child: addIcon(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.0),
                                  _buildMatters(context)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}

class Record {
  final String name;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name>";
}
