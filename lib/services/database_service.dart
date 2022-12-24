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

  Future<Object?> getUsersCollectionData() async {
    final dss = await usersCollection.doc(uid).get();

    if (!dss.exists) {
      throw Exception("Failed to fetch user data");
    }

    return dss.data();
  }
}
