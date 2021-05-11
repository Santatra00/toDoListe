import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taches/configuration.dart';
import 'package:taches/screens/AddTask.dart';
import 'package:taches/screens/DetailTask.dart';
import 'package:taches/screens/Home.dart';
import 'package:taches/screens/Login.dart';
import 'package:taches/screens/SignIn.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Offline storage
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  runApp(App());
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liste de tache',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context)=>LoginPage(),
        '/inscription': (context)=>SignInPage(),
        '/home': (context) => MyHomePage(),
        '/addTask': (context) => AddTaskPage(),
        '/detailTask': (context) => DetailTaskPage(),
      },
    );
  }
}
