import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taches/Components/MyTextFormField.dart';

class DetailTaskPage extends StatefulWidget {
  DetailTaskPage({Key key, String idTask}) : super(key: key);
  String idTask;

  @override
  _DetailTaskPageState createState() => _DetailTaskPageState();
}

class _DetailTaskPageState extends State<DetailTaskPage> {
  String _description;
  String _categorie;
  var _categories = ["Etude", "Livre", "Boulot"];
  final firestore = FirebaseFirestore.instance;


  TextEditingController _descriptionController = TextEditingController();
  final _formController = GlobalKey<FormState>();

  final auth = FirebaseAuth.instance;

  _submit(context){
    if((_categorie!=null)&&(_description!=null)&&(_formController.currentState!=null)&&(_formController.currentState.validate())){
      _formController.currentState.save();
      CollectionReference taches = FirebaseFirestore.instance.collection('taches');
      print('$_categorie, $_description');
      taches.add({
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
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                      Container(
                        color: Colors.blue,
                        child:  GestureDetector(
                          onTap: ()=>Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 30.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Text(
                          "Tache:",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold
                          )
                      ),
                    Form(
                        key: _formController,
                        child: Column(
                          children: [
                            MyTextFormField(
                              controller: _descriptionController,
                                labelText: "Description",
                                msgOnEmpty: "Veuillez indiquer la description de la tache",
                                onSaved: (input){
                                    _description=input;
                                }
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
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      height: 60.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: FlatButton(
                        onPressed: _submit(context),
                        child: Text(
                          "Enregistrer",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20.0
                          ),
                        ),
                      ),
                    )
                  ],
                )
            ),
          ),
        )
    );
  }
}