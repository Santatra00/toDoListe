import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taches/Components/MyDialogue.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String _email, _password, _confirmPassword;
  var _categories = ["hello", "hi"];
  final auth = FirebaseAuth.instance;

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController = new TextEditingController();

  final _formController = GlobalKey<FormState>();


  _verifyAuth(){
    auth.authStateChanges()
        .listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  _signOut()async {
    await auth.signOut();
  }

  _submit() async{
    if((_formController.currentState.validate())||(_confirmPassword==_password)){
      _formController.currentState.save();
      print('$_email, $_password');
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(email: _email, password: _password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }

    }
  }
  voida(){
    print("Voida");
  }

  _createuser(BuildContext context) async{
    if(_confirmPassword!=_password){
      showDialog(
          context: context,
          builder: (BuildContext context){
            return MyDialogue(
              title: "Les mots de passe ne sont pas identiques",
              subtitle: "Veuillez faire en sorte que le mot de pass correspond a la confirmation du mot de passee",
            );
          }
      );
    }else if(_formController.currentState.validate()){
      _formController.currentState.save();
      print('$_email, $_password');
      try {
        UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: _email.trim(), password: _password.trim());
        showDialog(
            context: context,
            builder: (BuildContext context){
              return MyDialogue(
                title: "Inscription effectuer",
                subtitle: "Connection effectuer",
              );
            }
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showDialog(
              context: context,
              builder: (BuildContext context){
                return MyDialogue(
                  title: "Mot de passe trop faible",
                  subtitle: "Veuiller utiliser un mot de passe plus complexe.",
                );
              }
          );
        } else if (e.code == 'email-already-in-use') {
          showDialog(
              context: context,
              builder: (BuildContext context){
                return MyDialogue(
                  title: "Cette email existe deja",
                  subtitle: "Cette adresse email est deja dans notre base de donnees",
                );
              }
          );
        }
      } catch (e) {
        print(e);
        showDialog(
            context: context,
            builder: (BuildContext context){
              return MyDialogue(
                title: "Erreur",
                subtitle: e.toString(),
              );
            }
        );
      }

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

                    Text(
                        "Inscription",
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
                              padding: EdgeInsets.symmetric(vertical: 20.0),
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
                                validator: (input)=>input.trim().isEmpty?'Veuillez entrer adresse email':null,
                                onSaved: (input)=>_email=input,
                                onChanged: (input)=>_email=input,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: TextFormField(
                                obscureText: true,
                                style:TextStyle(fontSize: 18.0),
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    labelText: 'Mot de passe',
                                    labelStyle: TextStyle(fontSize: 18.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0)
                                    )
                                ),
                                validator: (input)=>input.trim().isEmpty?'Veuillez entrer votre mot de pass':null,
                                onSaved: (input)=>_password=input,
                                onChanged: (input)=>_password=input,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: TextFormField(
                                obscureText: true,
                                style:TextStyle(fontSize: 18.0),
                                controller: _confirmPasswordController,
                                decoration: InputDecoration(
                                    labelText: 'Confirmer le mot de passe',
                                    labelStyle: TextStyle(fontSize: 18.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0)
                                    )
                                ),
                                validator: (input)=>input.trim().isEmpty?'Veuillez confirmer votre mot de pass':null,
                                onSaved: (input)=>_confirmPassword=input,
                                onChanged: (input)=>_confirmPassword=input,
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
                        onPressed: (){

                          _createuser(context);
                        },
                        child: Text(
                          "Soumettre",
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 20.0
                          ),
                        ),
                      ),
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
                        onPressed: ()=>Navigator.pop(context),
                        child: Text(
                          "Annuler",
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