import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Menu extends StatefulWidget {
  final StreamController<DrawerItems?> _drawerChangeStream;
  final UserEnum? _userRole;

  const Menu(this._drawerChangeStream, this._userRole, {Key? key})
      : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final StreamController<List<MenuData>> _menuDataListStream =
      StreamController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    _menuDataListStream.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getMenuList();
  }

  void _getMenuList() {
    List<MenuData> _menuDataList = <MenuData>[];
    MenuInteractor.getMenuList().then((value) {
      _menuDataList = value;
      print('data list length ${_menuDataList.length}');
      _menuDataListStream.sink.add(_menuDataList);
      _refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          StreamBuilder<List<MenuData>>(
              stream: _menuDataListStream.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && (snapshot.data?.length ?? 0) > 0) {
                    return SmartRefresher(
                      onRefresh: _getMenuList,
                      enablePullDown: true,
                      enablePullUp: false,
                      scrollDirection: Axis.vertical,
                      header: WaterDropHeader(
                        waterDropColor: ColorPalette.primaryColor,
                      ),
                      controller: _refreshController,
                      child: GridView.builder(
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.width * 0.15),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                          ),
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder:
                              (BuildContext buildContext, int index) {
                            return _cardMenu(snapshot.data?[index]);
                          }),
                    );
                  } else {
                    return Center(
                      child: Text('No Data'),
                    );
                  }
                } else {
                  return Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CupertinoActivityIndicator(),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Please Wait...'),
                      ],
                    ),
                  );
                }
              }),
          if (widget._userRole == UserEnum.Admin)
            Positioned(
              bottom: 0.0,
              left: 10.0,
              right: 10.0,
              child: ElevatedButton(
                onPressed: () {
                  routePush(AddMenu(false)).then((isNewData) {
                    if (isNewData != null) {
                      if (isNewData) {
                        _getMenuList();
                      }
                    }
                  });
                },
                child: Text('Add Menu'),
                style: ElevatedButton.styleFrom(
                    primary: ColorPalette.primaryColor,
                    onPrimary: Colors.white,
                    fixedSize: Size(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.width * 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
            ),
        ],
      ),
    );
  }

  Widget _cardMenu(MenuData? menuData) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          routePush(MenuDetail(menuData, widget._userRole)).then((isNewData) {
            if (isNewData != null) {
              if (isNewData) {
                _getMenuList();
              }
            }
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: CachedNetworkImage(
                imageUrl: menuData?.imageUrl ?? '',
                placeholder: (b, s) {
                  return CupertinoActivityIndicator();
                },
                errorWidget: (b, s, _) {
                  return Image.asset('assets/icons/ic_logo.png');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    menuData?.name ?? '',
                    style: TextStyle(
                      color: ColorPalette.primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'IDR ${MoneyFormatter.format(
                      double.tryParse(menuData?.price.toString() ?? '0'),
                    )}',
                    style: TextStyle(
                      color: ColorPalette.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
