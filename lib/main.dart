import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:ejemplo_construccion/login/flutter_login.dart';
import 'package:ejemplo_construccion/login/src/users.dart';

import 'package:ejemplo_construccion/home/screens/home_page.dart';
import 'transition_route_observer.dart';
import 'custom_route.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  /*Future<String> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(data.name)) {
        return 'Username not exists';
      }
      if (mockUsers[data.name] != data.password) {
        return 'Password does not match';
      }
      /* Navigator.of(context).push(
        MaterialPageRoute<void> (
          builder: (BuildContext context) => HomePage()
        
        )
      ); */
      return null;
    });
  }*/

  Future<String> _loginUser(LoginData data){
    return Future.delayed(loginTime).then((_) async {
      try{
        AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: data.name, password: data.password);
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
        primarySwatch: Colors.blue,
      ),
      home: FlutterLogin(
        onSignup: null,
        onLogin: (loginData) {
          print('Login info');
          print('Name: ${loginData.name}');
          print('Password: ${loginData.password}');
          return _loginUser(loginData);
        },
        onRecoverPassword: null,
        onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => HomePage(),
        ));
      },
      ),
      navigatorObservers: [TransitionRouteObserver()],
      routes: {HomePage.routeName: (context) => HomePage()},
    );
  }
}
