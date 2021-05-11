import 'package:flutter/material.dart';

class MyTextFormField extends StatefulWidget {
  MyTextFormField({Key key, this.labelText, this.controller, this.onSaved, this.msgOnEmpty}): super(key: key);

  final TextEditingController controller;
  final String labelText;
  final String msgOnEmpty;

  final Function onSaved;

  @override
  _MyTextFormFieldState createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  _MyTextFormFieldState({
    String labelText, TextEditingController descriptionController, Function onChanged});

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: TextFormField(
        style:TextStyle(fontSize: 18.0),
        controller: widget.controller,
        maxLines: null,
          minLines: 4,
          onSaved: widget.onSaved,
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: TextStyle(fontSize: 18.0),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0)
            )
        ),
        validator: (input)=>input.trim().isEmpty?widget.msgOnEmpty:null,
      ),
    );
  }

}
