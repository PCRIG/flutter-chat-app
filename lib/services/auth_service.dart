import 'package:chatapp/helper/helper_functions.dart';
import 'package:chatapp/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<bool> registerUserWithEmail(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      await DatabaseService(user.uid).createUserData(fullName, email);
      
      HelperFunctions.setUserLoggedInDetails(true, fullName, email);

      return true;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(
          "Unable to register your account. Please try again after some time");
    }
  }

  Future<bool> logInUserWithEmail(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password)).user!;

      QuerySnapshot userData = await DatabaseService(user.uid).getUsersCollectionData(user.email!);

      HelperFunctions.setUserLoggedInDetails(true, userData.docs[0]["fullName"], email);

      return true;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("Login failed. Please try again after some time");
    }
  }
}
