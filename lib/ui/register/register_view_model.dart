import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class RegisterViewModel {
  static CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  static Future<bool> onRegisterUser(
      String email, String password, String userRole, String name) async {
    UserData? userData;
    bool isSuccess = false;

    await isEmailValid(email).then((isValid) async {
      if (isValid) {
        await _users
            .doc(email)
            .set(UserData(
                    name: name,
                    userRole: userRole,
                    encryptedPassword: password,
                    email: email)
                .toJson())
            .then((response) async {
          await _users.doc(email).get().then((data) async {
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
      } else {
        return Future.error('Email already taken');
      }
    });
    return isSuccess;
  }

  static Future<bool> isEmailValid(String email) async {
    var isValid = await _users.doc(email).get();
    return Future.value(!isValid.exists);
  }
}
