import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  final String pageId;
  ProfilePage({Key key, @required this.userId, @required this.pageId})
      : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File _image;

  @override
  Widget build(BuildContext context) {
    
    DateTime now = DateTime.now();
    String date = now.day.toString()+"/"+now.month.toString()+"/"+now.year.toString(); 

    Future<String> getMatter = Future<String>.delayed(
        Duration(seconds: 0),
        () => Firestore.instance
            .collection('matters')
            .document(widget.pageId)
            .get()
            .then((value) => value['name']));

    Future getImage(bool state) async {
      var image;
      if (state) {
        image = await ImagePicker.pickImage(source: ImageSource.camera);
      } else {
        image = await ImagePicker.pickImage(source: ImageSource.gallery);
      }

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    Future uploadPic(BuildContext context) async {
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("${widget.userId}/${basename(_image.path)}");
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      setState(() {
        print("Profile Picture uploaded");
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });

      await Firestore.instance
          .collection('matters')
          .document(widget.pageId)
          .updateData({
        "photos": FieldValue.arrayUnion(
            [{"date":date,"url":(await firebaseStorageRef.getDownloadURL()).toString()}])
      });
    }

    return FutureBuilder<String>(
        future: getMatter,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget matter;
          if (snapshot.hasData) {
            matter = Text(
              snapshot.data,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            );
          } else if (snapshot.hasError) {
            matter = Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            );
          } else {
            matter = CircularProgressIndicator();
          }
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(FontAwesomeIcons.arrowLeft),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              title: Text('Edit Profile'),
            ),
            body: Builder(
              builder: (context) => Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 100,
                            backgroundColor: Color(0xff476cfb),
                            child: ClipOval(
                              child: new SizedBox(
                                width: 180.0,
                                height: 180.0,
                                child: (_image != null)
                                    ? Image.file(
                                        _image,
                                        fit: BoxFit.fill,
                                      )
                                    : Image.network(
                                        "https://image.freepik.com/vector-gratis/diseno-logo-phoenix_111165-14.jpg",
                                        fit: BoxFit.fill,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        Column(children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 60.0),
                            child: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.camera,
                                size: 30.0,
                              ),
                              onPressed: () {
                                getImage(true);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.0),
                            child: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.image,
                                size: 30.0,
                              ),
                              onPressed: () {
                                getImage(false);
                              },
                            ),
                          ),
                        ])
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Materia',
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 18.0)),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: matter,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('fecha',
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 18.0)),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(date,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    
                    
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                          color: Color(0xff476cfb),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          elevation: 4.0,
                          splashColor: Colors.blueGrey,
                          child: Text(
                            'Cancel',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                        RaisedButton(
                          color: Color(0xff476cfb),
                          onPressed: () {
                            uploadPic(context);
                          },
                          elevation: 4.0,
                          splashColor: Colors.blueGrey,
                          child: Text(
                            'Submit',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
