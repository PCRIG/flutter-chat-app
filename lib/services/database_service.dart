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

  Future<QuerySnapshot> getUsersCollectionDataByEmail(String email) async {
    QuerySnapshot dss =
        await usersCollection.where("email", isEqualTo: email).get();
    return dss;
  }

  Future<Stream> getUsersCollectionData() async {
    Stream dss = usersCollection.doc(uid).snapshots();
    return dss;
  }

  Future createGroup(String userName, String uid, String groupName) async {
    DocumentReference groupDocRef = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${uid}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": ""
    });

    await groupDocRef.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocRef.id
    });

    DocumentReference userDocRef = usersCollection.doc(uid);
    await userDocRef.update({
      "groups": FieldValue.arrayUnion(["${groupDocRef.id}_$groupName"])
    });
  }

  Future getChats(String groupId) async {
    return groupCollection
        .doc(groupId)
        .collection('messages')
        .orderBy('time')
        .snapshots();
  }

  Future getGroupAdmin(String groupId) async {
    return (await groupCollection.doc(groupId).get())['admin'];
  }

  sendMessage(String groupId, Map<String, dynamic> messageMap) async {
    groupCollection.doc(groupId).collection('messages').add(messageMap);
    groupCollection.doc(groupId).update({
      "recentMessage": messageMap['message'],
      "recentMessageSender": messageMap['sender']
    });
  }
}
