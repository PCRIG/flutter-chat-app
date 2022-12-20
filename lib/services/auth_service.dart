import 'package:chatapp/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<bool?> registerUserWithEmail(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        await DatabaseService(user.uid).createUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    return null;
  }
}
