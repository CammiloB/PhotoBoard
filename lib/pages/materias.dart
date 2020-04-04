import 'package:flutter/material.dart';
import 'package:ejemplo_construccion/dummies/chats.dart';

class MateriasPage extends StatefulWidget {
  @override
  MateriasState createState() {
    // TODO: implement createState
    return MateriasState();
  }
}

class MateriasState extends State<MateriasPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new ListView.builder(
        itemCount: dataDummy.length, itemBuilder: (context, i) => new Column(
          children: <Widget>[
            new Divider(
              height: 10,
            ),
            new ListTile(
              leading: new CircleAvatar(
                backgroundImage: new NetworkImage(dataDummy[i].avatar),
              ),
              title: new Text(dataDummy[i].title),
              subtitle: new Text(dataDummy[i].message),
              
            )
          ],
        ));
  }
}
