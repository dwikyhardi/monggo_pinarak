import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordViewModel{
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: email,);
    } on FirebaseAuthException catch (e) {
      print('error Code ======== ${e.code}');
      print('error Code ======== ${e.email}');
      print('stack trace ======== ${e.stackTrace.toString()}');
      print('stack trace ======== ${e.message.toString()}');
      return Future.error(e);
    }
  }
}