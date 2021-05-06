
import 'package:flutter/material.dart';

class MyDialogue extends StatelessWidget {
  MyDialogue({@required this.title, this.subtitle, this.content, this.action});
  final String title;
  final String subtitle;

  final Widget content;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
              title: Text(title),
              content: (content)??Text(subtitle),
              actions: <Widget>[
                (action)??
                  FlatButton(
                      child: Text("D'accord"),
                      onPressed: () => Navigator.pop(context, true)),
              ]
          );

  }
}
