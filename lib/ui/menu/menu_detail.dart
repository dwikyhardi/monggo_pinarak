import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class MenuDetail extends StatefulWidget {
  final MenuData? menuData;
  final UserEnum? _userRole;

  const MenuDetail(this.menuData, this._userRole, {Key? key}) : super(key: key);

  @override
  _MenuDetailState createState() => _MenuDetailState(this.menuData);
}

class _MenuDetailState extends State<MenuDetail> {
  final StreamController<MenuData?> _menuDataStream = StreamController();
  static CollectionReference _menu =
      FirebaseFirestore.instance.collection('menu');
  MenuData? menuData;
  bool isLoading = false;

  _MenuDetailState(this.menuData);

  void _getMenuDetail() {
    _menu.doc(menuData?.menuId).get().then((value) {
      menuData = MenuData.fromJson(value.data() as Map<String, dynamic>);
      _menuDataStream.sink.add(menuData);
      isLoading = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _menuDataStream.sink.add(menuData);
  }

  @override
  void dispose() {
    _menuDataStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<MenuData?>(
          stream: _menuDataStream.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData && snapshot.data != null) {
                var data = snapshot.data;
                return _buildBody(data, context);
              } else {
                return NoDataPage();
              }
            } else {
              return LoadingPage();
            }
          }),
    );
  }

  NestedScrollView _buildBody(MenuData? data, BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            brightness: Brightness.dark,
            expandedHeight: MediaQuery.of(context).size.width,
            floating: false,
            pinned: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              collapseMode: CollapseMode.parallax,
              title: Text(
                data?.name ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              background: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
                child: CachedNetworkImage(
                  imageUrl: data?.imageUrl ?? '',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  placeholder: (b, s) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: Center(child: CupertinoActivityIndicator()),
                    );
                  },
                  errorWidget: (b, s, _) {
                    return Image.asset(
                      'assets/icons/ic_logo.png',
                      color: Colors.white,
                    );
                  },
                ),
              ),
            ),
          ),
        ];
      },
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
          child: Column(
            children: [
              Text(
                data?.name ?? '',
                style: TextStyle(
                  color: ColorPalette.primaryColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'IDR ${MoneyFormatter.format(
                  double.tryParse(data?.price.toString() ?? '0'),
                )}',
                style: TextStyle(
                    color: ColorPalette.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                data?.description ?? '',
                style: TextStyle(
                  color: ColorPalette.primaryColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (widget._userRole == UserEnum.Admin)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Is Active',
                      style: TextStyle(
                          color: ColorPalette.primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity: isLoading ? 0.5 : 1,
                          child: CupertinoSwitch(
                            value: data?.isActive ?? false,
                            onChanged: (value) {
                              isLoading = true;
                              setState(() {});
                              data?.isActive = value;
                              _menu
                                  .doc(data?.menuId)
                                  .set(data?.toJson())
                                  .then((value) {
                                print('success');
                                _getMenuDetail();
                              }).catchError((e, stack) {
                                isLoading = false;
                                setState(() {});
                                print('error ${e.toString()}');
                                print('stack ${stack.toString()}');
                              });
                            },
                          ),
                        ),
                        if (isLoading) CupertinoActivityIndicator(),
                      ],
                    ),
                  ],
                ),
              if (widget._userRole == UserEnum.Admin)
                PrimaryColorButton(
                  onPressed: () {
                    routePush(AddMenu(
                      true,
                      menuData: data,
                    )).then((isNewData) {
                      if (isNewData != null) {
                        if (isNewData) {
                          Navigator.pop(context, true);
                        }
                      }
                    });
                  },
                  textTitle: 'Update Menu',
                  size: Size(MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.width * 0.1),
                ),
              if (widget._userRole == UserEnum.Admin)
                PrimaryColorButton(
                  onPressed: () {
                    _deleteMenuConfirmation(context);
                  },
                  textTitle: 'Delete Menu',
                  size: Size(MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.width * 0.1),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteMenuConfirmation(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return CupertinoAlertDialog(
            title: Text('Delete Confirmation'),
            content: Text(
                'Are you sure wan\'t to continue delete ${menuData?.name} from menu list?'),
            actions: [
              CupertinoDialogAction(
                child: Text('Cancel'),
                isDestructiveAction: false,
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(buildContext);
                },
              ),
              CupertinoDialogAction(
                child: Text('Continue'),
                isDefaultAction: false,
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(buildContext);
                  CustomDialog.showLoading();
                  MenuInteractor.deleteMenu(menuData?.menuId ?? '')
                      .then((value) {
                    Navigator.pop(context);
                    CustomDialog.showDialogWithoutTittle(value).then((value) {
                      Navigator.pop(context, true);
                    });
                  }).catchError((e) {
                    Navigator.pop(context);
                    CustomDialog.showDialogWithoutTittle(e.toString());
                  });
                },
              ),
            ],
          );
        });
  }
}
