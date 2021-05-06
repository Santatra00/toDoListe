import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taches/Components/MyDialogue.dart';
import 'package:taches/Components/MyListTile.dart';
import 'package:taches/security.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  final DateFormat _dateFormat = DateFormat("dd MMM yyyy * hh:mm:ss");

  final List<String> filters = ["Tous", "Accompli", "non Accompli"];
//  filtre by categorie
//  details tache
  bool isConnected;
  String filter;
  String tempFilter;
  DateTime dateFilter;
  DateTime selectedDate = DateTime.now();
  final DateFormat _dateFormatFilter = DateFormat("dd MMM yyyy");
  final DateFormat _dateFormatQuery = DateFormat("yyyy-MM-dd");

  bool isDateFilterActive;

  var db;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filter = "Tous";
    isDateFilterActive = false;
    dateFilter = DateTime.now();
    isConnected = true;
    auth.authStateChanges()
        .listen((User user) {
      if (user == null) {
        Navigator.popAndPushNamed(context, '/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if(auth.currentUser == null){
      return Scaffold(
          body:Center(
        child: Text("Loading"),
      ));
    }


    db = firestore.collection("taches").where("id_user",isEqualTo:auth.currentUser.uid);

    if(dateFilter != null){
      DateTime tempDateTime = DateTime.parse(_dateFormatQuery.format(dateFilter) + " 00:00:00");
      if(filter !=  "Tous"){
        db= db.where("is_finished",isEqualTo:(filter == "Accompli"))
              .where("created_at",
                isLessThanOrEqualTo: tempDateTime.add(Duration(days: 1)),
                isGreaterThanOrEqualTo: tempDateTime);
        print("Filter: $filter");
      }else{
        db = db.where("created_at",
            isLessThanOrEqualTo: tempDateTime.add(Duration(days: 1)),
            isGreaterThanOrEqualTo: tempDateTime);
      }
      print("${tempDateTime.millisecondsSinceEpoch} ${dateFilter.millisecondsSinceEpoch}");
    }else{
      if(filter !=  "Tous") {
        db = db.where("is_finished", isEqualTo: (filter == "Accompli"));
      }
    }
    return Scaffold(
      body: StreamBuilder(
        stream: db.snapshots(),
        builder: (context, snapshots){

//            entete
            List<Widget> listWidgetTache=[
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "Taches",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.filter_list),
                                onPressed: ()=>showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      return MyDialogue(
                                        title: "Filtrer les taches",
                                          action:FlatButton(
                                              child: Text("Filtrer"),
                                              onPressed: (){
                                                setState(() {
                                                  filter = tempFilter;
                                                });
                                                Navigator.pop(context, true);
                                              }
                                          ),
                                        content: DropdownButtonFormField(
                                          icon: Icon(Icons.arrow_drop_down_circle),
                                          iconSize: 22.0,
                                          iconEnabledColor: Theme.of(context).primaryColor,
                                          items: filters.map((value){
                                            return DropdownMenuItem(
                                                value: value,
                                                child: Text(
                                                    value,
                                                    style: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 18.0
                                                    )
                                                )
                                            );
                                          }).toList(),
                                          style:TextStyle(fontSize: 18.0),
                                          decoration: InputDecoration(
                                              labelText: 'Filtre',
                                              labelStyle: TextStyle(fontSize: 18.0),
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10.0)
                                              )
                                          ),
                                          validator: (input)=>((input==null)||(input.trim().isEmpty))?'Please enter a task':null,
                                          onSaved: (input)=>input,
                                          onChanged: (value){
                                          setState(() {
                                            tempFilter=value;
                                          });
                                          },
                                        ),
                                      );
                                    }
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.calendar_today),
                                onPressed: ()async{
                                  print("Pressed-1");
                                  if(!isDateFilterActive){
                                    print("Pressed-2");
                                    await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2050),
                                    ).then((picked){
                                      print("Pressed-3");
                                      if((picked != null) && (picked != selectedDate)){
                                        setState(() {
                                          dateFilter = picked;
                                        });
                                      }
                                    });
                                  }else{
                                    dateFilter = null;
                                  }
                                  print(isDateFilterActive);
                                  setState(() {
                                    isDateFilterActive = !isDateFilterActive;
                                  });

                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.exit_to_app),
                                onPressed: ()async{
                                  await auth.signOut();
                                  setState((){
                                    isConnected = false;
                                  });
                                },
                              )
                            ],
                          )

                        ],
                      ),

                      SizedBox(height: 10.0),

                        Text(
                        "${(snapshots.hasData)?snapshots.data.docs.length:0.toString()} "
                            "Tache${(snapshots.hasData &&(snapshots.data.docs.length>1))?"s":""} "
                            "${filter=="Tous"?"":filter}"
                            "${(isDateFilterActive)?" du ${_dateFormatFilter.format(dateFilter)}":""}"
                        ,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600
                        ),
                      )
                    ],
                  )
              ),
            ];
//          creation de la liste des taches
            ((!snapshots.hasData)||(snapshots.data.docs.length==0))?
            Text("Liste vide"):
            snapshots.data.docs.forEach((data){
              listWidgetTache.add(
                MyListTile(
                  key: Key(data.id),
                  onDismissed : (DismissDirection direction){
                    firestore
                        .doc(data.id)
                        .delete()
                        .then((value) => print("It's deleted"))
                        .catchError((error) => print("Failed to delete : $error"));

                  },
                  title: (data["description"] == null)?"[Empty]":data["description"],
                  categorie: data["categorie"],
                  subtitle: _dateFormat.format(
                    DateTime.fromMillisecondsSinceEpoch(
                      int.parse(
                          (data["created_at"] is int)?(data["created_at"]*1000).toString():(data["created_at"].seconds*1000).toString()
                      )
                    )
                  ), user: data,
                )
              );
            });
            return ListView(
                padding: EdgeInsets.symmetric(vertical: 50.0),
                children: listWidgetTache
            );
          }

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/addTask');
        },
        tooltip: 'Ajouter taches',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
