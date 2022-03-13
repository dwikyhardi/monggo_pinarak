import 'package:monggo_pinarak/monggo_pinarak.dart';

class LoginInteractor {
  static Future<bool> onLogin(String? username, String? password) async {
    print('username $username');
    print('password $password');
    return LoginViewModel.onLogin(username, password);
    // await LoginViewModel.onLogin(username,
    //         Encrypt().encrypt(password ?? '', await Encrypt().getPassKeyPref()))
    //     .then((value) {
    //   print('Success $value');
    //   if (value) {
    //     isLoginSuccess = value;
    //   }else{
    //     return Future.error('Unknown Login Error');
    //   }
    // }).catchError((e) {
    //   print('catchError Interactor $e');
    //   isLoginSuccess = false;
    //   return Future.error(e);
    // });
    // return isLoginSuccess;
  }

  static Future<int> getUserCount() async {
    return LoginViewModel.getUserCount();
  }
}
