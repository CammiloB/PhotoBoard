import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:ejemplo_construccion/login/flutter_login.dart';
import 'package:ejemplo_construccion/login/src/users.dart';

import 'package:ejemplo_construccion/home/screens/home_page.dart';
import 'transition_route_observer.dart';
import 'custom_route.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:io';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 0);
  AuthResult user;

  Future<String> _loginUser(LoginData data){
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

  Future<String> _registerUser(LoginData data){
    return Future.delayed(loginTime).then((_) async {
      try{
        AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: data.name, password: data.password);
        this.user = result;
        Firestore.instance.collection('users').add({
          'name': 'camilo'
        }); 
        return null;
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
        onRecoverPassword: null,
        user: this.user
      ),
      navigatorObservers: [TransitionRouteObserver()],
    );
  }
}
