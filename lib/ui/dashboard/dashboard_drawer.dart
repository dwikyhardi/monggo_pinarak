import 'dart:async';

import 'package:flutter/material.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

enum DrawerItems {
  order,
  // transaction,
  menu,
  report,
  register,
  logout,
  login,
  forgotPassword,
}

final Map<DrawerItems, String> getStringDrawerItems = {
  DrawerItems.order: 'Order',
  // DrawerItems.transaction: 'Transaction',
  DrawerItems.menu: 'Menu',
  DrawerItems.report: 'Report',
  DrawerItems.register: 'Register',
  DrawerItems.logout: 'Logout',
  DrawerItems.login: 'Login',
  DrawerItems.forgotPassword: 'Forgot Password',
};

final Map<String, DrawerItems> getDrawerItems = {
  'Order': DrawerItems.order,
  // 'Transaction': DrawerItems.transaction,
  'Menu': DrawerItems.menu,
  'Report': DrawerItems.report,
  'Register': DrawerItems.register,
  'Logout': DrawerItems.logout,
  'Login': DrawerItems.login,
  'Forgot Password': DrawerItems.forgotPassword,
};

class DashboardDrawer extends StatelessWidget {
  final StreamController<DrawerItems?> _drawerChangeStream;
  final bool _isLogin;
  final UserData? _userData;
  final UserEnum? _userRole;

  DashboardDrawer(
      this._drawerChangeStream, this._isLogin, this._userData, this._userRole,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: ColorPalette.primaryColor),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/ic_logo.png',
                    width: MediaQuery.of(context).size.width * 0.2,
                    color: Colors.white,
                  ),
                  if (_isLogin) Spacer(),
                  if (_isLogin)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userData?.name ?? '',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        Text(
                          _userData?.email ?? '',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            _getDrawerItem(context),
          ],
        ),
      ),
    );
  }

  Widget _getDrawerItem(BuildContext context) {
    var children = <Widget>[];
    if (_isLogin) {
      switch (_userRole) {
        case UserEnum.Admin:
          children.add(_orderButton(context));
          // children.add(_transactionButton(context));
          children.add(_menuButton(context));
          children.add(_reportButton(context));
          children.add(_registerButton(context));
          children.add(_logoutButton(context));
          break;
        case UserEnum.Waitress:
          children.add(_orderButton(context));
          children.add(_reportButton(context));
          children.add(_registerButton(context));
          children.add(_logoutButton(context));
          break;
        case UserEnum.Cashier:
          // children.add(_transactionButton(context));
          children.add(_orderButton(context));
          children.add(_reportButton(context));
          children.add(_registerButton(context));
          children.add(_logoutButton(context));
          break;
        case UserEnum.Owner:
          children.add(_reportButton(context));
          children.add(_logoutButton(context));
          break;
        case UserEnum.User:
          children.add(_orderButton(context));
          children.add(_logoutButton(context));
          break;
        default:
          break;
      }
    } else {
      children.add(_registerButton(context));
      children.add(_loginButton(context));
      children.add(_forgotPasswordButton(context));
    }

    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: children,
    );
  }

  Widget _loginButton(BuildContext context) {
    return _drawerItem(DrawerItems.login, onTap: () {
      _drawerChangeStream.sink.add(DrawerItems.login);
      Navigator.pop(context);
    });
  }

  Widget _logoutButton(BuildContext context) {
    return _drawerItem(DrawerItems.logout, onTap: () {
      _drawerChangeStream.sink.add(DrawerItems.logout);
      Navigator.pop(context);
    });
  }

  Widget _registerButton(BuildContext context) {
    return _drawerItem(DrawerItems.register, onTap: () {
      _drawerChangeStream.sink.add(DrawerItems.register);
      Navigator.pop(context);
    });
  }

  Widget _reportButton(BuildContext context) {
    return _drawerItem(DrawerItems.report, onTap: () {
      _drawerChangeStream.sink.add(DrawerItems.report);
      Navigator.pop(context);
    });
  }

  Widget _menuButton(BuildContext context) {
    return _drawerItem(DrawerItems.menu, onTap: () {
      _drawerChangeStream.sink.add(DrawerItems.menu);
      Navigator.pop(context);
    });
  }

  Widget _forgotPasswordButton(BuildContext context) {
    return _drawerItem(DrawerItems.forgotPassword, onTap: () {
      _drawerChangeStream.sink.add(DrawerItems.forgotPassword);
      Navigator.pop(context);
    });
  }

  // Widget _transactionButton(BuildContext context) {
  //   return _drawerItem(DrawerItems.transaction, onTap: () {
  //     _drawerChangeStream.sink.add(DrawerItems.transaction);
  //     Navigator.pop(context);
  //   });
  // }

  Widget _orderButton(BuildContext context) {
    return _drawerItem(DrawerItems.order, onTap: () {
      _drawerChangeStream.sink.add(DrawerItems.order);
      Navigator.pop(context);
    });
  }

  Widget _drawerItem(DrawerItems drawerItems, {void Function()? onTap}) {
    var title = '';
    IconData icon = Icons.logout;
    switch (drawerItems) {
      case DrawerItems.login:
        title = 'Login';
        icon = Icons.login;
        break;
      case DrawerItems.order:
        title = 'Order';
        icon = Icons.shopping_cart;
        break;
      // case DrawerItems.transaction:
      //   title = 'Transaction';
      //   icon = Icons.add_shopping_cart_outlined;
      //   break;
      case DrawerItems.report:
        title = 'Report';
        icon = Icons.assessment_outlined;
        break;
      case DrawerItems.register:
        title = 'Register User';
        icon = Icons.person_add_rounded;
        break;
      case DrawerItems.logout:
        title = 'Logout';
        icon = Icons.logout;
        break;
      case DrawerItems.menu:
        title = 'Menu';
        icon = Icons.restaurant;
        break;
      case DrawerItems.forgotPassword:
        title = 'Forgot Password';
        icon = Icons.password;
        break;
    }
    return ListTile(
      title: Row(
        children: [
          Icon(
            icon,
            color: Colors.black,
          ),
          SizedBox(
            width: 30,
          ),
          Text(
            title,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
