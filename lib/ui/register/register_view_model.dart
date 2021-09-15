import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class RegisterViewModel {
  static CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<bool> onRegisterUser(
      String email, String password, String userRole, String name) async {
    UserData? userData;
    bool isSuccess = false;

    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((userCredential) async {
        await _users
            .doc(userCredential.user?.uid)
            .set(UserData(
                    uid: userCredential.user?.uid ?? '',
                    name: name,
                    userRole: userRole,
                    email: email)
                .toJson())
            .then((response) async {
          await _users.doc(userCredential.user?.uid).get().then((data) async {
            if (data.exists && data.data() != null) {
              isSuccess = true;
              debugPrint('Register Success View Model ${userData?.toJson()}');
            } else {
              return Future.error('Register Error');
            }
          });
        }, onError: (e) {
          debugPrint('Register Error View Model $e');
          return Future.error('Register Error');
        });
      });
    } on FirebaseAuthException catch (e) {
      return Future.error(e.code, e.stackTrace);
    }
    return isSuccess;
  }

// static Future<bool> isEmailValid(String email) async {
//   var isValid = await _users.doc(email).get();
//   return Future.value(!isValid.exists);
// }
}
