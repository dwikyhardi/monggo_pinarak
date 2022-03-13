import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewDashboard extends StatefulWidget {
  const NewDashboard({Key? key}) : super(key: key);

  @override
  _NewDashboardState createState() => _NewDashboardState();
}

class _NewDashboardState extends State<NewDashboard> {
  int _tabBarIndex = 0;

  UserData? _userData;
  UserEnum? _userRole;
  List<Widget> _listChild = [
    LoadingPage(),
    LoadingPage(),
    LoadingPage(),
  ];

  Future<void> checkLogin() async {
    var pref = await SharedPreferences.getInstance();
    var user = pref.getString(Pref.USER.toString());
    // print('UserData CheckLogin ====== $user');
    if (user != null) {
      if (mounted) {
        await Encrypt().getPassKeyPref().then((passKey) {
          _userData = UserData.fromJson(jsonDecode(user));
          _userRole =
              getUserEnum[Encrypt().decrypt(_userData?.userRole, passKey)];
          setState(() {});
        });
      }
    } else {
      if (mounted) {
        _userData = null;
        setState(() {});
      }
    }

    _listChild = [
      Home(),
      Report(null, _userRole ?? UserEnum.User, _userData?.uid ?? ''),
      Order(_userRole ?? UserEnum.User, null, _userData),
    ];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    Widget _tabBarChild(NewDashboardEnum drawerItems) {
      return InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          _tabBarIndex = drawerItems.index;
          setState(() {});
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          decoration: BoxDecoration(
            color: (_tabBarIndex == drawerItems.index)
                ? Colors.white
                : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            getStringNewDashboardEnum[drawerItems] ?? '',
            style: TextStyle(
              fontSize: 14,
              color: (_tabBarIndex == drawerItems.index)
                  ? ColorPalette.primaryColor
                  : Colors.white,
            ),
          ),
        ),
      );
    }

    Widget _tabBar() {
      return Container(
        decoration: BoxDecoration(
          color: ColorPalette.primaryColorLight,
          borderRadius: BorderRadius.circular(40),
        ),
        padding: EdgeInsets.all(2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:
              NewDashboardEnum.values.map((e) => _tabBarChild(e)).toList(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: _tabBar(),
        brightness: Brightness.dark,
      ),
      body: IndexedStack(
        index: _tabBarIndex,
        children: _listChild,
      ),
    );
  }
}

enum NewDashboardEnum {
  Home,
  Report,
  Order,
}

final Map<NewDashboardEnum, String> getStringNewDashboardEnum = {
  NewDashboardEnum.Home: 'Home',
  NewDashboardEnum.Report: 'Report',
  NewDashboardEnum.Order: 'Order',
};

final Map<String, NewDashboardEnum> getNewDashboardEnum = {
  'Home': NewDashboardEnum.Home,
  'Report': NewDashboardEnum.Report,
  'Order': NewDashboardEnum.Order,
};
