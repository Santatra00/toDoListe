
import 'package:flutter/material.dart';

class MyDialogue extends StatelessWidget {
  MyDialogue({this.title, this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
              title: Text(title),
              content: Text(subtitle),
              actions: <Widget>[
                FlatButton(
                    child: Text("D'accord"),
                    onPressed: () => Navigator.pop(context, true)),
              ]
          );

  }
}
