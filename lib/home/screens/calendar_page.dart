import 'package:flutter/material.dart';
import 'package:photoboard/home/theme/colors/light_colors.dart';
import 'package:photoboard/home/widgets/task_container.dart';
import 'package:photoboard/home/screens/create_new_task_page.dart';
import 'package:photoboard/home/widgets/back_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarPage extends StatefulWidget{
  final String userId;
  CalendarPage({Key key, @required this.userId}): super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<CalendarPage>{

  Widget _dashedText() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        '------------------------------------------',
        maxLines: 1,
        style:
            TextStyle(fontSize: 20.0, color: Colors.black12, letterSpacing: 5),
      ),
    );
  }

  _dialogAddRecDesp(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(userId: widget.userId);
        });
  }

  Widget _buildMatters(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('tasks')
          .document(widget.userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data['tasks']);
      },
    );
  }

  Widget _buildList(BuildContext context, List<dynamic> snapshot)  {
    return Column(
      children: snapshot
          .map<Widget>((matter) =>  Column(children: [
                   Dismissible(
                    key: Key(matter['id']),
                    onDismissed: (direction){
                      if(direction.index == 2){
                        setState((){
                            Firestore.instance.collection('tasks').document(widget.userId).updateData({
                          'numTasks':FieldValue.increment(-1) ,'tasks': FieldValue.arrayRemove([matter])});
                        
                        });
                        Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text("$matter se ha eliminado")));
                      }else if(direction.index == 3){
                          setState((){
                              Firestore.instance.collection('tasks').document(widget.userId).updateData({
                              'numTasks': FieldValue.increment(-1),
                              'done': FieldValue.increment(1),
                              'tasks': FieldValue.arrayRemove([matter])});
                          
                          });
                          Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text("$matter esta realizada")));
                      }
                },
                  child: TaskContainer(
                    title: matter['name'],
                    subtitle: matter['desc'],
                    boxColor: LightColors.kLightGreen,
                  ),
          )]),
              )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.kLightYellow,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            0,
          ),
          child: Column(
            children: <Widget>[
              MyBackButton(),
              SizedBox(height: 30.0),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Mis Tareas',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.w700),
                    ),
                    Container(
                      height: 40.0,
                      width: 120,
                      decoration: BoxDecoration(
                        color: LightColors.kGreen,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: FlatButton(
                        onPressed: () {
                          _dialogAddRecDesp(context);
                        },
                        child: Center(
                          child: Text(
                            'Agregar',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ]),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Manten tu dia productivo',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 5,
                          child: ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: <Widget>[_buildMatters(context)],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
