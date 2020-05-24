import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

class CustomDialog extends StatefulWidget {

  final String userId;
  CustomDialog({Key key, @required this.userId}): super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}



class _CustomDialogState extends State<CustomDialog> {
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerDes = TextEditingController();

  

  addMatter(String name, String desc) async {

    try{
  String id = await Firestore.instance.collection('tasks').document().documentID;
    await Firestore.instance.collection('tasks').document(widget.userId).updateData({
      'tasks': FieldValue.arrayUnion([{"id":id, "name":name, "desc":desc}])});
    }catch(e){
      String id = await Firestore.instance.collection('tasks').document().documentID;
    await Firestore.instance.collection('tasks').document(widget.userId).setData({
      'tasks': FieldValue.arrayUnion([{"id":id, "name":name, "desc":desc}])});
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(width * 0.050)),
      title: Text(
        'Agregar Materia',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      backgroundColor: Colors.green[400],
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Nombre:   ",
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.white, fontSize: width * 0.06)),
            Flexible(
              child: TextField(
                controller: _controllerName,
                style: TextStyle(fontSize: width * 0.05),
                maxLines: 1,
                textAlign: TextAlign.start,
                decoration: new InputDecoration(
                    hintText: "Nombre Materia",
                    contentPadding: EdgeInsets.only(
                        left: width * 0.04,
                        top: width * 0.041,
                        bottom: width * 0.041,
                        right: width * 0.04),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(width * 0.04),
                        borderSide:
                            BorderSide(color: Colors.white, width: 2.0))),
              ),
            ),
            SizedBox(height: 30,),
            Flexible(
              child: TextField(
                controller: _controllerDes,
                style: TextStyle(fontSize: width * 0.05),
                maxLines: 12,
                textAlign: TextAlign.start,
                decoration: new InputDecoration(
                    hintText: "Descripción",
                    contentPadding: EdgeInsets.only(
                        left: width * 0.04,
                        top: width * 0.041,
                        bottom: width * 0.041,
                        right: width * 0.04),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(width * 0.04),
                        borderSide:
                            BorderSide(color: Colors.white, width: 2.0)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.04),
                      borderSide: BorderSide(color: Colors.white, width: 2.0)
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: width * 0.09),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Text("Cancelar", style: TextStyle(color: Colors.white)),
                  ),
                  GestureDetector(
                    onTap: (){
                      if(_controllerName.text.isNotEmpty && _controllerDes.text.isNotEmpty){
                        print(_controllerName.text);
                        print(_controllerDes.text);
                        addMatter(_controllerName.text, _controllerDes.text);
                      }
                      Navigator.pop(context);
                    },
                    child: Container(
                        padding: EdgeInsets.only(
                            top: width * 0.02, 
                            bottom: width * 0.02, 
                            left: width * 0.03, 
                            right: width * 0.03),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Text(
                            "Agregar",
                            style: TextStyle(
                                color: Colors.red[300],
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.05),
                          ),
                        ),
                      ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
