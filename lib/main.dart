import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:photoboard/login/flutter_login.dart';

import 'transition_route_observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  Duration get loginTime => Duration(seconds: timeDilation.ceil() * 1 );
  AuthResult user;

  Future<String> _loginUser (LoginData data) async{
    return Future.delayed(loginTime).then((_) async {
        try{
          AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: data.name, password: data.password);
          this.user = result;
          return null;
      }catch (e){
        return "Error";
      }
    });
  }

  Future<String> _registerUser(LoginData data) async {
    return Future.delayed(loginTime).then((_) async {
        try{
          AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: data.name, password: data.password);
          this.user = result;
          Firestore.instance.collection('users').document(result.user.uid).setData({
            'name': 'pruebaCamilo'
          });
        return null;
      }catch (e){
        return "Error";
      }
    });
  }

  Future<String> _onRecoverPassword(String email) async {
    return Future.delayed(loginTime).then((_) async {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      }catch (e){
        return "Error";
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Login',
      theme: new ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
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
          return _loginUser(loginData);
        },
        onRecoverPassword: (loginData) {
          print("Recover Password");
          print("data: "+loginData);
          return _onRecoverPassword(loginData);
        },
        user: this.user
      ),
      navigatorObservers: [TransitionRouteObserver()],
    );
  }
}
