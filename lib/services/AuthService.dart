import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  AuthService();

  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
}