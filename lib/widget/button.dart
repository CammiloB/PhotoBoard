import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ejemplo_construccion/principal.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ejemplo_construccion/authentication.dart';



class ButtonLogin extends StatefulWidget {

  final CameraDescription camera;
  final String email;
  final String password;
  const ButtonLogin({Key key, @required this.camera, this.email, this.password}): super(key: key);

  @override
  _ButtonLoginState createState() => _ButtonLoginState();
}

class _ButtonLoginState extends State<ButtonLogin> {
  AuthService authService = new AuthService();
  bool auth = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, right: 50, left: 200),
      child: Container(
        alignment: Alignment.bottomRight,
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.red[300],
              blurRadius: 10.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                5.0, // horizontal, move right 10
                5.0, // vertical, move down 10
              ),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: FlatButton(
          onPressed: () {
            
            if(authService.signInFirebase("prueba123@photoboard.com", "prueba123") != null){
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => PrincipalPage(
                    camera: widget.camera,
                  )
                )
              );
            }else{
              print("Error");
            }

            
            
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'OK',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}