import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:photoboard/login/flutter_login.dart';

import 'transition_route_observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photoboard/home/screens/home_page.dart';

import 'package:photoboard/login/auth.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  Duration get loginTime => Duration(seconds: timeDilation.ceil() * 1);
  String userId;
  final auth = new AuthUser();

  Future<String> _loginUser(LoginData data, BuildContext context) async {
    return Future.delayed(loginTime).then((_) async {
      try {
        await auth.signIn(data.name, data.password);
        return null;
      } catch (e) {
        return "Error " + e.toString();
      }
    });
  }

  Future<String> _registerUser(LoginData data) async {
    return Future.delayed(loginTime).then((_) async {
      try {
        userId = await auth.createUser(data.name, data.password);
        Firestore.instance
            .collection('users')
            .document(userId) 
            .setData({'name': data.username});
        Firestore.instance.collection('matter').document(userId).setData({"matters":FieldValue.arrayUnion([])});
        Firestore.instance.collection('tasks').document(userId).setData({"tasks":FieldValue.arrayUnion([])});
        return null;
      } catch (e) {
        return "Error";
      }
    });
  }

  Future<String> _onRecoverPassword(String email) async {
    return Future.delayed(loginTime).then((_) async {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      } catch (e) {
        return "Error";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: auth.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return new MaterialApp(
            title: 'Login',
            theme: new ThemeData(
              primarySwatch: Colors.blueGrey,
            ),
            routes: {
              'home':(context) => HomePage(userId: this.userId, auth: this.auth,),
              
            },
            home: FlutterLogin(
                onSignup: (loginData) {
                  print('Register Info');
                  print('Name: ${loginData.name}');
                  print('Password: ${loginData.password}');
                  return _registerUser(loginData);
                },
                onLogin: (loginData) {
                  print('Login info');
                  print('Name: ${loginData.name}');
                  print('Password: ${loginData.password}');
                  return _loginUser(loginData, context);
                },
                onRecoverPassword: (loginData) {
                  print("Recover Password");
                  print("data: " + loginData);
                  return _onRecoverPassword(loginData);
                },
                userId: snapshot.data,
                auth: this.auth),
            navigatorObservers: [TransitionRouteObserver()],
          );
        });
  }
}
