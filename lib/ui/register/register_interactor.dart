import 'package:flutter/material.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class RegisterInteractor {
  static Future<bool> onRegisterUser(
      String email, String password, UserEnum userRole, String name) async {
    bool isSuccess = false;

    await Encrypt().getPassKeyPref().then((passKey) async {
      await RegisterViewModel.onRegisterUser(
              email,
              Encrypt().encrypt(password, passKey),
              Encrypt().encrypt(userRole.toString().split('.').last, passKey),
              name)
          .then((success) {
        if (success) {
          isSuccess = success;
        } else {
          return Future.error('Register error Interactor');
        }
      }).catchError((e) {
        debugPrint('Register Error interactor $e');
        return Future.error(e);
      });
    });

    return isSuccess;
  }
}
