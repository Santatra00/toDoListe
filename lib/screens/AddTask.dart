import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taches/Components/MyTextFormField.dart';
import 'package:taches/Components/PageTitle.dart';
import 'package:taches/services/TacheService.dart';

class AddTaskPage extends StatefulWidget {
  AddTaskPage({Key key}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  String _description;
  String _categorie;
  var _categories = ["Etude", "Livre", "Boulot"];
  final firestore = FirebaseFirestore.instance;
  TacheService tacheService = new TacheService();

  CollectionReference tacheReference ;

  TextEditingController _descriptionController = TextEditingController();
  final _formController = GlobalKey<FormState>();

  final auth = FirebaseAuth.instance;

  _submit(context){
    print("_submit, $_categorie, $_description");

    if((_categorie!=null)&&(_formController.currentState!=null)&&(_formController.currentState.validate())){
      _formController.currentState.save();
      print("_submit, $_categorie, $_description");

      tacheReference = tacheService.getCollectionReferenceTache();
      tacheReference.add({
        'categorie': _categorie, // John Doe
        'description': _description, // Stokes and Sons
        'created_at': Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch),
        'id_user': auth.currentUser.uid,
        'is_finished': false
      })
          .then((value) => Navigator.of(context).pop())
          .catchError((error) => print("Failed to add user: $error"));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
          onTap: ()=>FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 40.0, left: 40.0),
                        child:  GestureDetector(
                          onTap: ()=>Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 30.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),

                      PageTitle(
                        title: "Nouvelle tache",
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 40.0,right: 40.0),
                        child: Column(
                          children: [
                            Form(
                                key: _formController,
                                child: Column(
                                  children: [
                                    MyTextFormField(
                                      controller: _descriptionController,
                                      labelText: "Description",
                                      msgOnEmpty: "Veuillez indiquer la description de la tache",
                                      onSaved: (input){
                                        print("saved");
                                        _description=input;
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 20.0),
                                      child: DropdownButtonFormField(
                                        icon: Icon(Icons.arrow_drop_down_circle),
                                        iconSize: 22.0,
                                        iconEnabledColor: Theme.of(context).primaryColor,
                                        items: _categories.map((value){
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
                                            labelText: 'Categorie',
                                            labelStyle: TextStyle(fontSize: 18.0),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0)
                                            )
                                        ),
                                        validator: (input)=>((input==null)||(input.trim().isEmpty))?'Please enter a task':null,
                                        onSaved: (input)=>_categorie=input,
                                        onChanged: (value){
                                          _categorie=value;
                                          //                                      setState(() {
                                          //                                        _categorie=value;
                                          //                                      });
                                        },
                                      ),
                                    )
                                  ],
                                )
                            ),
                            GestureDetector(
                                onTap: ()=> _submit(context),
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 20.0),
                                  height: 60.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Enregistrer",
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 20.0
                                      ),
                                    ),
                                  ),

                                )
                            )
                          ],
                        ),
                      ),

                  ],
                )
            ),
          ),
        )
    );
  }
}