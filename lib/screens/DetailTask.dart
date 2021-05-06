import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taches/Components/MyTextFormField.dart';

class DetailTaskPage extends StatefulWidget {
  DetailTaskPage({Key key, this.description, this.categorie}) : super(key: key);
  final String description;
  final String categorie;

  @override
  _DetailTaskPageState createState() => _DetailTaskPageState();
}

class _DetailTaskPageState extends State<DetailTaskPage> {

  String getTitle(){
    String textResult=widget.description;

    if(textResult.split("\n").length>1){
      textResult = textResult.split("\n")[0];
    }
    return textResult;
  }
  String getContent(){
    String content = widget.description;
    String titre = getTitle();
    if(content.length>titre.length){
      content = content.substring(titre.length);
    }
    return content;
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
                          getTitle(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold
                          )
                      ),
                    SizedBox(height: 30.0),
                    Text(
                        getContent(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                      )
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Text(
                          "Categorie:  ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold
                          )
                        ),
                      Text(
                        widget.categorie,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20.0,
                        )
                      )
                      ],


                    )
                  ],
                )
            ),
          ),
        )
    );
  }
}