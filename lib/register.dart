import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ejemplo_construccion/widget/button.dart';
import 'package:ejemplo_construccion/widget/first.dart';
import 'package:ejemplo_construccion/widget/inputEmail.dart';
import 'package:ejemplo_construccion/widget/password.dart';
import 'package:ejemplo_construccion/widget/textLogin.dart';
import 'package:ejemplo_construccion/widget/verticalText.dart';
import 'package:ejemplo_construccion/widget/input.dart';


class RegisterPage extends StatefulWidget {

  final CameraDescription camera;

  const RegisterPage({Key key, @required this.camera}): super(key: key);

  @override
  _registerPageState createState() => _registerPageState();
}

class _registerPageState extends State<RegisterPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.black87, Colors.blueGrey[100]]),
        ),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(children: <Widget>[
                  VerticalText(title:"Registrarse"),
                  TextLogin(text: "Aqui puedes registrarte para disfrutar de los beneficios de PhotoBoard"),
                ]),
                Input(text: "Nombres"),
                Input(text: "Apellidos"),
                Input(text: "Email"),
                PasswordInput(),
                ButtonLogin(
                  camera: widget.camera,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}