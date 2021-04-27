import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

mixin Security {
  final auth = FirebaseAuth.instance;

  protect(BuildContext context){
    auth.authStateChanges()
        .listen((User user) {
          if (user != null) {
            Navigator.popAndPushNamed(context, '/home');
          }
        });
  }
}