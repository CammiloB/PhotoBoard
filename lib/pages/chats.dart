import 'package:flutter/material.dart';
import 'package:ejemplo_construccion/dummies/chats.dart';

class ChatPage extends StatefulWidget {
  @override
  ChatState createState() {
    return ChatState();
  }
}

class ChatState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
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
