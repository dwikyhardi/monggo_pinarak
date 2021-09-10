import 'dart:async';
import 'dart:convert';

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
  String? _userRole;
  String _appBarTitle = 'Monggo Pinarak';

  @override
  void initState() {
    super.initState();
    checkLogin().then((_) {
      if (_isLogin) {
        if (UserEnum.user.toString().contains(_userRole ?? '')) {
          _drawerChangeStream.sink.add(DrawerItems.order);
        } else {
          _drawerChangeStream.sink.add(DrawerItems.report);
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
          var nameSplit = snapshot.data.toString().split('.').last;
          _appBarTitle =
              '${nameSplit.substring(0, 1).toUpperCase()}${nameSplit.substring(1, nameSplit.length).toLowerCase()}';
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
        _isLogin = true;
        _userData = UserData.fromJson(jsonDecode(user));
        _userRole = Encrypt().decrypt(
            _userData?.userRole ?? '', await Encrypt().getPassKeyPref());
        setState(() {});
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
        return Order(_drawerChangeStream, _userData);
      case DrawerItems.transaction:
        return Container(
          child: Text(drawerItems.toString()),
        );
      case DrawerItems.report:
        return Container(
          child: Text(drawerItems.toString()),
        );
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
    pref.remove(Pref.USER.toString()).then((value) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(navGK.currentState!.context);
        pushAndRemoveUntil(SplashScreen());
      });
    });
  }
}
