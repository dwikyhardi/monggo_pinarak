import 'dart:async';

import 'package:flutter/material.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class Login extends StatelessWidget {
  Login(this._drawerChangeStream, {Key? key}) : super(key: key);
  final StreamController<DrawerItems?> _drawerChangeStream;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icons/ic_logo.png',
                width: MediaQuery.of(context).size.width * 0.5,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  color: ColorPalette.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'E-Mail',
                        hintText: 'mail@mail.com',
                        hintStyle: TextStyle(
                          color: ColorPalette.primaryColorLight,
                        ),
                        labelStyle: TextStyle(
                          color: ColorPalette.primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: ColorPalette.primaryColor,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      validator: (input) {
                        if (input == null || input.length == 0) {
                          return 'Email is required';
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: '********',
                        hintStyle: TextStyle(
                          color: ColorPalette.primaryColorLight,
                        ),
                        labelStyle: TextStyle(
                          color: ColorPalette.primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: ColorPalette.primaryColor,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      style: TextStyle(
                        color: ColorPalette.primaryColorLight,
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      validator: (input) {
                        if (input == null || input.length == 0) {
                          return 'Password is required';
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  var form = _formKey.currentState;
                  if (form != null && form.validate()) {
                    form.save();
                    _onLogin();
                  }
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  primary: ColorPalette.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: Size(MediaQuery.of(context).size.width, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLogin() {
    CustomDialog.showLoading();
    LoginInteractor.onLogin(_emailController.text, _passwordController.text)
        .then((isSuccess) {
      print('IsSuccess ====== $isSuccess');
      if (isSuccess) {
        pushAndRemoveUntil(SplashScreen());
      } else {
        Navigator.pop(navGK.currentState!.context);
        CustomDialog.showDialogWithoutTittle('Error Login');
      }
    }).catchError((e, trace) {
      Navigator.pop(navGK.currentState!.context);
      print(e);
      print('StackTrace ======= ${trace.toString()}');
      CustomDialog.showDialogWithoutTittle(e.toString());
    });
  }
}
