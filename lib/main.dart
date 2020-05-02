import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:ejemplo_construccion/login/flutter_login.dart';

import 'transition_route_observer.dart';




void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  Duration get loginTime => Duration(seconds: timeDilation.ceil() * 1 );

  Future<String> _loginUser(LoginData data){
    return Future.delayed(loginTime).then((_) async {
        return null;
    });
  }

  Future<String> _registerUser(LoginData data){
    return Future.delayed(loginTime).then((_) async {
        return null;
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
        onRecoverPassword: null
      ),
      navigatorObservers: [TransitionRouteObserver()],
    );
  }
}
