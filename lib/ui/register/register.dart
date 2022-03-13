import 'dart:async';

import 'package:flutter/material.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class Register extends StatefulWidget {
  Register(this._drawerChangeStream, this._userRole, {Key? key})
      : super(key: key);
  final StreamController<DrawerItems?> _drawerChangeStream;
  final UserEnum? _userRole;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  UserEnum? _selectedUserRole;

  bool _isObscure = true;

  late List<UserEnum> _userRoleList;

  @override
  void initState() {
    super.initState();
    switch (widget._userRole) {
      case UserEnum.Admin:
        _userRoleList = [
          UserEnum.Admin,
          UserEnum.Cashier,
          UserEnum.Owner,
          UserEnum.User,
          UserEnum.Waitress,
        ];
        break;
      case UserEnum.Waitress:
      case UserEnum.Cashier:
      case UserEnum.Owner:
        _userRoleList = [
          UserEnum.Cashier,
          UserEnum.Owner,
          UserEnum.User,
          UserEnum.Waitress,
        ];
        break;
      case UserEnum.User:
        _userRoleList = [
          UserEnum.User,
        ];
        break;
      default:
        _userRoleList = [
          UserEnum.User,
        ];
    }
  }

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
                'Register',
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
                        labelText: 'Name',
                        hintText: 'John Doe',
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
                      keyboardType: TextInputType.name,
                      controller: _nameController,
                      validator: (input) {
                        if (input == null || input.length == 0) {
                          return 'Name is required';
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          child: Icon(
                            _isObscure
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            color: ColorPalette.primaryColor,
                          ),
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
                      obscureText: _isObscure,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      validator: (input) {
                        if (input == null || input.length == 0) {
                          return 'Password is required';
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (widget._userRole != null &&
                        widget._userRole != UserEnum.User)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: ColorPalette.primaryColor,
                            width: 1,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<UserEnum>(
                            isDense: false,
                            value: _selectedUserRole,
                            iconEnabledColor: ColorPalette.primaryColor,
                            onChanged: (selected) {
                              setState(() {
                                _selectedUserRole = selected;
                              });
                              print(_selectedUserRole.toString());
                            },
                            hint: Text(
                              'Select User Role',
                              style:
                                  TextStyle(color: ColorPalette.primaryColor),
                            ),
                            dropdownColor: Colors.white,
                            items: _userRoleList.map((e) {
                              return DropdownMenuItem(
                                child: Text(
                                  getStringUserEnum[e] ?? '',
                                  style: TextStyle(
                                      color: ColorPalette.primaryColor),
                                ),
                                value: e,
                              );
                            }).toList(),
                          ),
                        ),
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
                    _onRegister();
                  }
                },
                child: Text('Register'),
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

  void _onRegister() {
    CustomDialog.showLoading();
    RegisterInteractor.onRegisterUser(
            _emailController.text,
            _passwordController.text,
            _selectedUserRole ?? UserEnum.User,
            _nameController.text)
        .then((isSuccess) {
      if (isSuccess) {
        if (widget._userRole != null && widget._userRole != UserEnum.User) {
          widget._drawerChangeStream.sink.add(DrawerItems.report);
        } else {
          _loginAfterRegister();
        }
      } else {
        CustomDialog.showDialogWithoutTittle('Error Register');
      }
      Navigator.pop(navGK.currentState!.context);
    }).catchError((e) {
      Navigator.pop(navGK.currentState!.context);
      CustomDialog.showDialogWithoutTittle(e.toString());
    });
  }

  void _loginAfterRegister() {
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
