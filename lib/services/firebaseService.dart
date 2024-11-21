import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Firebaseservice {
  final CollectionReference tasks =
      FirebaseFirestore.instance.collection("tickets");

  String get userId => FirebaseAuth.instance.currentUser!.uid;

  Future addTicket(
      String name, String value, String dateOfIssue, String deadline) {
    return tasks.add({
      "name": name,
      "value": value,
      "dateOfIssue": dateOfIssue,
      "deadline": deadline,
      "userId": userId
    });
  }

  Stream<QuerySnapshot> getCarsStream() {
    final tasksStream = tasks.where("userId", isEqualTo: userId).snapshots();
    return tasksStream;
  }

  Future<void> updateTask(String docId, String newName, String newValue,
      String dateOfIssue, String newDeadline) {
    return tasks.doc(docId).update({
      "name": newName,
      "value": newValue,
      "dateOfIssue": dateOfIssue,
      "deadline": newDeadline,
      "userId": userId
    });
  }

  Future<void> deleteTask(String docId) {
    return tasks.doc(docId).delete();
  }

  Future<DocumentSnapshot> getTicket(String docId) {
    return tasks.doc(docId).get();
  }
}
