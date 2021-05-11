import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taches/Components/MyDialogue.dart';
import 'package:taches/configuration.dart';
import 'package:taches/security.dart';

class LoginPage extends StatefulWidget with Security {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  var _categories = ["hello", "hi"];
  final auth = FirebaseAuth.instance;

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  final _formController = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.protect(context);
  }

  _signOut()async {
    await auth.signOut();
  }

  _submit(BuildContext context) async{
    if(_formController.currentState.validate()){
      _formController.currentState.save();
      print('$_email, $_password');
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(email: _email, password: _password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showDialog(
              context: context,
              builder: (BuildContext context){
                return MyDialogue(
                  title: "Email introuvable",
                  subtitle: "Nous n'avons pas pu trouver cette email ",
                );
              }
          );
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          showDialog(
              context: context,
              builder: (BuildContext context){
                return MyDialogue(
                  title: "Mot de passe incorrect",
                  subtitle: "Votre mot de pass ne correspond pas a aucun mot de pass ",
                );
              }
          );
          print('Wrong password provided for that user.');
        }
      }

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: ()=>FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                        child: Image.asset("assets/images/login.png", scale: 1.1,),
                      )
                    ),

                   SizedBox(height: 30.0,),
                   Text(
                          "Login",
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
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: TextFormField(
                                style:TextStyle(fontSize: 18.0),
                                controller: _emailController,
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(fontSize: 18.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0)
                                    )
                                ),
                                validator: (input)=>input.trim().isEmpty?'Veuiller entrer adresse email':null,
                                onSaved: (input)=>_email=input,
                                onChanged: (input)=>_email=input,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: TextFormField(
                                obscureText: true,
                                style:TextStyle(fontSize: 18.0),
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(fontSize: 18.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0)
                                    )
                                ),
                                validator: (input)=>input.trim().isEmpty?'Veuiller entrer votre mot de pass':null,
                                onSaved: (input)=>_password=input,
                                onChanged: (input)=>_email=input,
                              ),
                            )
                          ],
                        )
                    ),
                    SizedBox(height: 20.0,),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      height: 60.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: FlatButton(
                        onPressed: ()=>_submit(context),
                        child: Text(
                          "Se connecter",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 20.0
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text("ou"),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      height: 60.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: FlatButton(
                        onPressed: ()=>Navigator.pushNamed(context, '/inscription'),
                        child: Text(
                          "Inscription",
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