import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyListTile extends StatefulWidget {
  MyListTile({Key key, this.title, this.subtitle, this.onSaved, this.user}): super(key: key);

  final String title;
  final String subtitle;

  final Function onSaved;
  final QueryDocumentSnapshot user;

  @override
  _MyListTileState createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  _MyListTileState({
    String labelText, TextEditingController descriptionController, Function onChanged});

  cutText(String text){
    String textResult = text;
    if(text.length>40){
      textResult = text.substring(0, 40) + "...";
    }
    if(textResult.split("\n").length>1){
      textResult = textResult.split("\n")[0];
      textResult+="...";
    }
    return textResult;
  }

  @override
  Widget build(BuildContext context){
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                cutText(widget.title),
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              subtitle: Text(
                  widget.subtitle
              ),
              trailing: Checkbox(
                  onChanged: (value){
                    final firestore = FirebaseFirestore.instance.collection('taches');
                    firestore
                        .doc(widget.user.id)
                        .update({'is_finished': true})
                        .then((value) => print("It's checked"))
                            .catchError((error) => print("Failed to check user: $error"));
                      },
                  activeColor: Theme.of(context).primaryColor,
                  value: widget.user["is_finished"],

              ),
            ),
            Divider()
          ],
        )
    );
  }

}
