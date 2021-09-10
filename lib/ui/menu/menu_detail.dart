import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class MenuDetail extends StatelessWidget {
  final MenuData? menuData;
  final String? _userRole;

  const MenuDetail(this.menuData, this._userRole, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              brightness: Brightness.dark,
              expandedHeight: MediaQuery.of(context).size.width,
              floating: false,
              pinned: true,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(40)),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                collapseMode: CollapseMode.parallax,
                title: Text(
                  menuData?.name ?? '',
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
                    imageUrl: menuData?.imageUrl ?? '',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    placeholder: (b, s) {
                      return CupertinoActivityIndicator();
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
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
          child: Column(
            children: [
              Text(
                menuData?.name ?? '',
                style: TextStyle(
                  color: ColorPalette.primaryColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'IDR ${MoneyFormatter.format(
                  double.tryParse(menuData?.price.toString() ?? '0'),
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
                menuData?.description ?? '',
                style: TextStyle(
                  color: ColorPalette.primaryColor,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (_userRole == 'admin')
                ElevatedButton(
                  onPressed: () {
                    routePush(AddMenu(
                      true,
                      menuData: menuData,
                    )).then((isNewData) {
                      if (isNewData != null) {
                        if (isNewData) {
                          Navigator.pop(context, true);
                        }
                      }
                    });
                  },
                  child: Text('Update Menu'),
                  style: ElevatedButton.styleFrom(
                      primary: ColorPalette.primaryColor,
                      onPrimary: Colors.white,
                      fixedSize: Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.width * 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
                ),
              if (_userRole == 'admin')
                ElevatedButton(
                  onPressed: () {
                    _deleteMenuConfirmation(context);
                  },
                  child: Text('Delete Menu'),
                  style: ElevatedButton.styleFrom(
                      primary: ColorPalette.primaryColor,
                      onPrimary: Colors.white,
                      fixedSize: Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.width * 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      )),
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
                    CustomDialog.showDialogWithoutTittle(e);
                  });
                },
              ),
            ],
          );
        });
  }
}
