import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  String? uid;

  DatabaseService(this.uid);

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  Future createUserData(String fullName, String email) async {
    return usersCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "userId": uid,
    });
  }

  Future<QuerySnapshot> getUsersCollectionData(String email) async {
    QuerySnapshot dss = await usersCollection.where("email", isEqualTo: email).get();
    return dss;
  }
}
