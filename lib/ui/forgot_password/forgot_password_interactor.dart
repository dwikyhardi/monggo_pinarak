import 'package:monggo_pinarak/ui/ui_library.dart';

class ForgotPasswordInteractor{
  static Future<void> resetPassword(String email) async {
    return ForgotPasswordViewModel.resetPassword(email);
  }
}