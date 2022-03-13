import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel {
  static CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  static FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static Future<bool> onLogin(String? username, String? password) async {
    var isLoginSuccess = false;
    try {
      await _firebaseAuth
          .signInWithEmailAndPassword(
              email: username ?? '', password: password ?? '')
          .then((userCredential) async {
        // print('UserCredential UID ====== ${userCredential.user?.uid}');
        // print('UserCredential Email ====== ${userCredential.user?.email}');
        await _users.doc(userCredential.user?.uid).get().then((data) async {
          if (data.exists && data.data() != null) {
            print('Allowed to login ${jsonEncode(data.data())}');
            var usersData =
                UserData.fromJson(data.data() as Map<String, dynamic>);
            var pref = await SharedPreferences.getInstance();
            pref.setString(Pref.USER.toString(), jsonEncode(usersData));
            isLoginSuccess = true;
          } else {
            print('Your Account is not registered');
            return Future.error('Your Account is not registered');
          }
        });
      });
    } on FirebaseAuthException catch (e) {
      print('error Code ======== ${e.code}');
      return Future.error(e.message.toString(), e.stackTrace);
    }
    return isLoginSuccess;
  }

  static Future<int> getUserCount() async {
    // List<UserData> userDataList = <UserData>[];
    int userCount = 0;
    await _users.get().then((userList) {
      // userList.docs.forEach((userData) {
      //   if (userData.exists && userData.data() != null) {
      //     print(
      //         'UserData Object ${userData.id} ======== ${jsonEncode(userData.data())}');
      //     userDataList
      //         .add(UserData.fromJson(userData.data() as Map<String, dynamic>));
      //   }
      // });
      userCount = userList.size;
    });

    return userCount;
  }
}
