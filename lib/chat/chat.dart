import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photoboard/login/model/User.dart';
import 'package:photoboard/home/theme/colors/light_colors.dart';


class ChatPage extends StatefulWidget {
  final User user;
  ChatPage({Key key, @required this.user}):super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ChatPage> {
  void response(query) async {
    AuthGoogle authGoogle = await AuthGoogle(
            fileJson: "assets/credentials.json")
        .build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
      messsages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
      });
    });
  }

  final messageInsert = TextEditingController();
  List<Map> messsages = List();

  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CupcakeShop Bot",
        ),
        backgroundColor: LightColors.kPalePink,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    itemCount: messsages.length,
                    itemBuilder: (context, index) => chat(widget.user,
                        messsages[index]["message"].toString(),
                        messsages[index]["data"]))),
            Divider(
              height: 5.0,
              color: LightColors.kGreen,
            ),
            Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                      child: TextField(
                    controller: messageInsert,
                    decoration: InputDecoration.collapsed(
                        hintText: "Habla con Angela",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18.0)),
                  )),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconButton(
                      
                        icon: Icon(
                          
                          Icons.send,
                          size: 30.0,
                          color: LightColors.kGreen,
                        ),
                        onPressed: () {
                          if (messageInsert.text.isEmpty) {
                            print("empty message");
                          } else {
                            setState(() {
                              messsages.insert(0,
                                  {"data": 1, "message": messageInsert.text});
                            });
                            response(messageInsert.text);
                            messageInsert.clear();
                          }
                        }),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            )
          ],
        ),
      ),
    );
  }

  //for better one i have use the bubble package check out the pubspec.yaml

  Widget chat(@required User user, String message, int data) {
    Widget widget;
    Future getTasks = Future.delayed(
        Duration(seconds: 5),
        () => Firestore.instance
            .collection('tasks')
            .document(user.userID)
            .get()
            .then((value) => value['tasks']));

    Future getMatters = Future.delayed(
        Duration(seconds: 5),
        () => Firestore.instance
            .collection('matter')
            .document(user.userID)
            .get()
            .then((value) => value['matters']));

    if(message.contains("@")){
      if(message.split("@")[1] == "showTasks"){
        widget = FutureBuilder(
          future: getTasks,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            String tasks = "${message.split('@')[0]} \n\n";
            if(snapshot.hasData){
              for(int i=0; i<snapshot.data.length; i++){
                tasks += "*"+snapshot.data[i]['name']+"\n";
              }
            }
            return Text(tasks, style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),);
          }
        );
      }else if(message.split("@")[1] == "showMatters"){
        widget = FutureBuilder(
          future: getMatters,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            String tasks = "${message.split('@')[0]} \n\n";
            if(snapshot.hasData){
              for(int i=0; i<snapshot.data.length; i++){
                tasks += "*"+snapshot.data[i]['name']+"\n";
              }
            }
            return Text(tasks, style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),);
          }
        );
      }
    }else{
      widget = Text(message, style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),);
    }

    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Bubble(
          radius: Radius.circular(15.0),
          color: data == 0 ? LightColors.kRed  : LightColors.kDarkYellow,
          elevation: 0.0,
          alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
          nip: data == 0 ? BubbleNip.leftBottom : BubbleNip.rightTop,
          child: Padding(
            padding: EdgeInsets.all(2.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: AssetImage(
                      data == 0 ? "assets/bot.png" : "assets/user.png"),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Flexible(
                    child: widget)
              ],
            ),
          )),
    );
  }

  
}