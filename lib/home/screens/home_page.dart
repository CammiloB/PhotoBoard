import 'package:flutter/material.dart';
import 'package:photoboard/home/screens/calendar_page.dart';
import 'package:photoboard/home/theme/colors/light_colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:photoboard/home/widgets/task_column.dart';
import 'package:photoboard/home/widgets/active_project_card.dart';
import 'package:photoboard/home/widgets/top_container.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photoboard/login/auth.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';
  final String userId;

  HomePage({Key key, @required this.userId}) : super(key: key) {
    print("CCCCC: "+this.userId);
  }

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

    return FutureBuilder<String>(
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                                CalendarPage()),
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
                                iconBackgroundColor: LightColors.kDarkYellow,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  subheading('Mis Materias'),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CalendarPage()),
                                      );
                                    },
                                    child: addIcon(),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                children: <Widget>[
                                  ActiveProjectsCard(
                                    cardColor: LightColors.kGreen,
                                    title: 'Calculo',
                                    subtitle: '9 hours progress',
                                    context: context,
                                  ),
                                  SizedBox(width: 20.0),
                                  ActiveProjectsCard(
                                    cardColor: LightColors.kRed,
                                    title: 'Programación',
                                    subtitle: '20 hours progress',
                                    context: context,
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  ActiveProjectsCard(
                                    cardColor: LightColors.kDarkYellow,
                                    title: 'Sports App',
                                    subtitle: '5 hours progress',
                                    context: context,
                                  ),
                                  SizedBox(width: 20.0),
                                  ActiveProjectsCard(
                                    cardColor: LightColors.kBlue,
                                    title: 'Online Flutter Course',
                                    subtitle: '23 hours progress',
                                    context: context,
                                  ),
                                ],
                              ),
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
    );
  }
}
