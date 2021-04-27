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

  @override
  Widget build(BuildContext context){
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                widget.title,
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
                        .then((value) => print("User Deleted"))
                            .catchError((error) => print("Failed to delete user: $error"));
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
