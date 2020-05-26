import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photoboard/login/constants.dart';
import 'package:photoboard/login/model/User.dart';
import 'package:photoboard/login/ui/auth/AuthScreen.dart';
import 'package:photoboard/login/ui/services/Authenticate.dart';
import 'package:photoboard/login/ui/utils/helper.dart';
import 'package:photoboard/home/screens/home_page.dart';
import 'package:photoboard/home/theme/colors/light_colors.dart';
import '../../../main.dart';

FireStoreUtils _fireStoreUtils = FireStoreUtils();

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({Key key, @required this.user}) : super(key: key);

  @override
  State createState() {
    return _HomeState(user);
  }
}

class _HomeState extends State<HomeScreen> {
  final User user;

  _HomeState(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Menu Principal',
                style: TextStyle(color: Colors.white),
              ),
              decoration: BoxDecoration(
                color: Color(COLOR_PRIMARY),
              ),
            ),
            ListTile(
              title: Text(
                'Chat',
                style: TextStyle(color: Colors.black),
              ),
              leading: Transform.rotate(
                angle: 0,
                  child: Icon(Icons.chat, color: Colors.black)),
              onTap: () async {
                user.active = false;
                user.lastOnlineTimestamp = Timestamp.now();
                _fireStoreUtils.updateCurrentUser(user, context);
                await FirebaseAuth.instance.signOut();
                MyAppState.currentUser = null;
                pushAndRemoveUntil(context, AuthScreen(), false);
              },
            ),
            ListTile(
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ),
              leading: Transform.rotate(
                angle: pi/1,
                  child: Icon(Icons.exit_to_app, color: Colors.black)),
              onTap: () async {
                user.active = false;
                user.lastOnlineTimestamp = Timestamp.now();
                _fireStoreUtils.updateCurrentUser(user, context);
                await FirebaseAuth.instance.signOut();
                MyAppState.currentUser = null;
                pushAndRemoveUntil(context, AuthScreen(), false);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: LightColors.kDarkYellow,
        centerTitle: true,
      ),
      body: HomePage(user: user, name: user.firstName)
    );
  }
}
