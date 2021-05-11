import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TacheService {

  TacheService();

  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  CollectionReference getCollectionReferenceTache(){
    print("Query:: all");
    return this.firestore.collection("taches");
  }
   Query getQueryForAllTachesByUserId(Query query){
     return query.where("id_user",isEqualTo: this.auth.currentUser.uid);
  }
  Query getQueryIsFinished(Query query, bool isFinished){
    return query.where("is_finished",isEqualTo: isFinished);
  }
  Query getQueryForTacheCreatedInDay(Query query, DateTime dateReference){
    return query.where("created_at",
        isLessThanOrEqualTo: dateReference.add(Duration(days: 1)),
        isGreaterThanOrEqualTo: dateReference);
  }

  Future<bool> delete(String tache_id){
     firestore.collection("taches").where("id_user",isEqualTo:auth.currentUser.uid);
  }
  Future<DocumentReference> add(Map<String, dynamic> tacheJson){
    return this.firestore.collection("taches").add(tacheJson);
  }

}