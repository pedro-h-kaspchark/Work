import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  registerUser(
      {required String name,
      required String email,
      required String password}) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'Email já em uso';
      }
    }
  }

  loginUser({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      if (e.message == 'invalid-credential') {
        return 'Email ou senha incorreto!';
      } else if (e.message == 'The email address is badly formatted.') {
        return 'Email ou senha incorreto!';
      } else {
        return 'Erro de login';
      }
    }
  }

  logoutUser() {
    return _firebaseAuth.signOut();
  }

  Future passwordReset(email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }
}
