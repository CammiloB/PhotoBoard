import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ejemplo_construccion/widget/button.dart';
import 'package:ejemplo_construccion/widget/first.dart';
import 'package:ejemplo_construccion/widget/forgot.dart';
import 'package:ejemplo_construccion/widget/inputEmail.dart';
import 'package:ejemplo_construccion/widget/password.dart';
import 'package:ejemplo_construccion/widget/textLogin.dart';
import 'package:ejemplo_construccion/widget/verticalText.dart';


class LoginPage extends StatefulWidget {

  final CameraDescription camera;

  const LoginPage({Key key, @required this.camera}): super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.black87, Colors.blueGrey]),
        ),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(children: <Widget>[
                  VerticalText(),
                  TextLogin(),
                ]),
                InputEmail(),
                PasswordInput(),
                ButtonLogin(
                  camera: widget.camera,
                ),
                FirstTime(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}