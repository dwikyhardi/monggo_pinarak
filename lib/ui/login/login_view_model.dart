import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel {
  static Future<bool> onLogin(
      String? username, String? password) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var isLoginSuccess = false;
    await users.doc(username).get().then((data) async {
      if (data.exists && data.data() != null) {
        var usersData = UserData.fromJson(data.data() as Map<String, dynamic>);
        await Encrypt().getPassKeyPref().then((passkey) async {
          if (Encrypt().decrypt(usersData.encryptedPassword, passkey) ==
              Encrypt().decrypt(password ?? '', passkey)) {
            print('Allowed to login ${jsonEncode(usersData)}');
            var pref = await SharedPreferences.getInstance();
            pref.setString(Pref.USER.toString(), jsonEncode(usersData));
            isLoginSuccess = true;
          } else {
            print('Wrong Password');
            return Future.error('Wrong Password');
          }
        });
      }else{
        print('Your Account is not registered');
        return Future.error('Your Account is not registered');
      }
    });
    return isLoginSuccess;
  }
}
