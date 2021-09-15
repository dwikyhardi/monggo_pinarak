import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final StreamController<DrawerItems?> _drawerChangeStream =
      StreamController<DrawerItems?>();

  bool _isLogin = false;
  UserData? _userData;
  UserEnum? _userRole;
  String _appBarTitle = 'Monggo Pinarak';

  @override
  void initState() {
    super.initState();
    checkLogin().then((_) {
      if (_isLogin) {
        switch (_userRole) {
          case UserEnum.Admin:
          case UserEnum.Waitress:
          case UserEnum.Cashier:
          case UserEnum.Owner:
            _drawerChangeStream.sink.add(DrawerItems.report);
            break;
          case UserEnum.User:
            _drawerChangeStream.sink.add(DrawerItems.order);
            break;
          default:
            _drawerChangeStream.sink.add(DrawerItems.login);
        }
      } else {
        _drawerChangeStream.sink.add(DrawerItems.login);
      }
    });
  }

  @override
  void dispose() {
    _drawerChangeStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DrawerItems?>(
        stream: _drawerChangeStream.stream,
        builder: (context, snapshot) {
          _appBarTitle = getStringDrawerItems[snapshot.data] ?? '';
          return Scaffold(
            appBar: AppBar(
              title: Text(_appBarTitle),
              brightness: Brightness.dark,
            ),
            drawerScrimColor: Colors.transparent,
            backgroundColor: Colors.white,
            drawer: DashboardDrawer(
                _drawerChangeStream, _isLogin, _userData, _userRole),
            body: getBody(snapshot.data),
          );
        });
  }

  Future<void> checkLogin() async {
    var pref = await SharedPreferences.getInstance();
    var user = pref.getString(Pref.USER.toString());
    // print('UserData CheckLogin ====== $user');
    if (user != null) {
      if (mounted) {
        await Encrypt().getPassKeyPref().then((passKey) {
          _isLogin = true;
          _userData = UserData.fromJson(jsonDecode(user));
          _userRole =
              getUserEnum[Encrypt().decrypt(_userData?.userRole, passKey)];
          print('User Data ==== ${_userData?.toJson()}');
          print(
              'User Role ==== ${Encrypt().decrypt(_userData?.userRole, passKey)}');
          print(
              'User Role dec ==== ${getUserEnum[Encrypt().decrypt(_userData?.userRole, passKey)]}');
          print(
              'User Role enc ==== ${Encrypt().encrypt(getStringUserEnum[UserEnum.User] ?? '', passKey)}');
          setState(() {});
        });
      }
    } else {
      if (mounted) {
        _isLogin = false;
        _userData = null;
        setState(() {});
      }
    }
  }

  Widget getBody(DrawerItems? drawerItems) {
    print('drawerItems ====== $drawerItems');
    switch (drawerItems) {
      case DrawerItems.order:
        return Order(
            _userRole ?? UserEnum.User, _drawerChangeStream, _userData);
      // case DrawerItems.transaction:
      //   return Container(
      //     child: Text(drawerItems.toString()),
      //   );
      case DrawerItems.report:
        return Report(_drawerChangeStream, _userRole ?? UserEnum.User,
            _userData?.uid ?? '');
      case DrawerItems.register:
        return Register(_drawerChangeStream, _userRole);
      case DrawerItems.logout:
        _onLogout();
        return Container();
      case DrawerItems.login:
        return Login(_drawerChangeStream);
      case DrawerItems.menu:
        return Menu(_drawerChangeStream, _userRole);
      default:
        return Container(
          child: Text(drawerItems.toString()),
        );
    }
  }

  void _onLogout() async {
    var pref = await SharedPreferences.getInstance();
    CustomDialog.showLoading();
    await FirebaseAuth.instance.signOut().then((value) async {
      await pref.remove(Pref.USER.toString()).then((value) {
        Navigator.pop(navGK.currentState!.context);
        pushAndRemoveUntil(SplashScreen());
      });
    });
  }
}
