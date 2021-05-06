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

//  filtre by categorie
//  details tache

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: firestore.collection("taches").where("id_user",isEqualTo:auth.currentUser.uid).snapshots(),
        builder: (context, snapshots){
          if((!snapshots.hasData)||(snapshots.data.docs.length==0)){
            return Text("Liste vide");
          }else{
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
                                        subtitle: "Votre mot de pass ne correspond pas a aucun mot de pass ",
                                      );
                                    }
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.exit_to_app),
                                onPressed: ()=>auth.signOut(),
                              )
                            ],
                          )

                        ],
                      ),

                      SizedBox(height: 10.0),
                      Text(
                        "${(snapshots.hasData)?snapshots.data.docs.length:0.toString()} Tache(s)",
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
            snapshots.data.docs.forEach((data){
              print(data["description"] );
              listWidgetTache.add(
                MyListTile(
                  title: (data["description"] == null)?"[Empty]":data["description"],
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
