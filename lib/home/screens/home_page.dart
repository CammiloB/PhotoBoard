import 'package:flutter/material.dart';
import 'package:photoboard/home/screens/calendar_page.dart';
import 'package:photoboard/home/theme/colors/light_colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:photoboard/home/widgets/task_column.dart';
import 'package:photoboard/home/widgets/top_container.dart';
import 'package:photoboard/home/widgets/CustomDialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photoboard/login/auth.dart';
import 'package:photoboard/matter/matter.dart';
import 'package:photoboard/login/model/User.dart';
import 'package:photoboard/login/ui/utils/helper.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';
  final User user;
  final BaseAuth auth;
  final String name;

  HomePage({Key key, @required this.user, this.auth, this.name})
      : super(key: key) {}

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

  _dialogAddRecDesp(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(userId: user.userID);
        });
  }

  Widget _buildMatters(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('matter')
          .document(user.userID)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data['matters'].length == 0) {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                padding: EdgeInsets.all(15.0),
                height: 100,
                child: Center(
                    child: Text(
                  "No hay materias para mostrar, Agrega una",
                  style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700),
                )),
              ),
            ],
          );
        }
        return _buildList(context, snapshot.data['matters']);
      },
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
                            pageId: matter['id'], userId: user.userID)))
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
            .document(user.userID)
            .get()
            .then((value) => value['name']));

    Future getTasks = Future.delayed(
        Duration(seconds: 5),
        () => Firestore.instance
            .collection('tasks')
            .document(user.userID)
            .get()
            .then((value) => value['numTasks']));

    Future getDoneTasks = Future.delayed(
        Duration(seconds: 5),
        () => Firestore.instance
            .collection('tasks')
            .document(user.userID)
            .get()
            .then((value) => value['done']));

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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          user.profilePictureURL != null
                              ? displayCircleImage(
                                  user.profilePictureURL, 117, false)
                              : displayCircleImage(
                                  'assets/foto1.png', 125, false),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                child: Text(
                                  'Estudiante',
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              subheading('Mis tareas'),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CalendarPage(
                                              userId: user.userID,
                                            )),
                                  );
                                },
                                child: calendarIcon(),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          FutureBuilder(
                            future: getTasks,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              int tasksForDo = 0;
                              if (snapshot.hasData) {
                                if (snapshot.data != null) {
                                  tasksForDo = snapshot.data;
                                }
                              }
                              return TaskColumn(
                                icon: Icons.alarm,
                                iconBackgroundColor: LightColors.kRed,
                                title: 'Por Hacer',
                                subtitle: '${tasksForDo} tareas por hacer',
                              );
                            },
                          ),
                          SizedBox(height: 15.0),
                          FutureBuilder(
                            future: getDoneTasks,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              int tasksDone = 0;
                              if (snapshot.hasData) {
                                if (snapshot.data != null) {
                                  tasksDone = snapshot.data;
                                }
                              }
                              return TaskColumn(
                                icon: Icons.check_circle_outline,
                                iconBackgroundColor: LightColors.kBlue,
                                title: 'Hecho',
                                subtitle: '${tasksDone} Tareas hechas',
                              );
                            },
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
  }
}
