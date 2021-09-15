import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class AddOrder extends StatefulWidget {
  const AddOrder(this._userData, {Key? key}) : super(key: key);
  final UserData? _userData;

  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  final StreamController<List<MenuData>> _menuDataListStream =
      StreamController();

  final StreamController<List<MenuDataOrder?>> _selectedMenuDataListStream =
      StreamController();

  List<MenuDataOrder?> _selectedMenuDataList = <MenuDataOrder?>[];

  @override
  void dispose() {
    _selectedMenuDataListStream.close();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Order'),
        automaticallyImplyLeading: true,
        backgroundColor: ColorPalette.primaryColor,
        brightness: Brightness.dark,
      ),
      body: Stack(
        children: [
          StreamBuilder<List<MenuData>>(
              stream: _menuDataListStream.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && (snapshot.data?.length ?? 0) > 0) {
                    return ListView.builder(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.width * 0.15),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (BuildContext buildContext, int index) {
                          return _cardMenu(snapshot.data?[index]);
                        });
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
          Positioned(
            bottom: 0.0,
            left: 10.0,
            right: 10.0,
            child: StreamBuilder<List<MenuData?>>(
                stream: _selectedMenuDataListStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && (snapshot.data?.length ?? 0) > 0) {
                    if ((snapshot.data?.length ?? 0) > 0) {
                      var selectedMenu = snapshot.data;
                      return ElevatedButton(
                        onPressed: () {
                          _addOrderConfirmation();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${selectedMenu?.length} Item Selected'),
                              Text('Submit order'),
                            ],
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: ColorPalette.primaryColor,
                            onPrimary: Colors.white,
                            fixedSize: Size(MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.width * 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                      );
                    } else {
                      return const SizedBox();
                    }
                  } else {
                    return const SizedBox();
                  }
                }),
          ),
        ],
      ),
    );
  }

  void _addOrderConfirmation() {
    TextEditingController _tableNumberController = TextEditingController();
    var totalQty = 0;
    var totalPayment = 0.0;
    _selectedMenuDataList.forEach((element) {
      totalQty = totalQty + (element?.qty ?? 0);
      totalPayment = totalPayment + ((element?.qty ?? 0) * (element?.price ?? 0));
    });
    var _textEditingFocus = FocusNode();
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext buildContext) {
          return CupertinoActionSheet(
            title: Text(
              'Order Confirmation',
              style: TextStyle(
                color: CupertinoColors.activeBlue,
              ),
            ),
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                if (_tableNumberController.text.isNotEmpty) {
                  Navigator.pop(buildContext);
                  _addOrder(_tableNumberController.text, totalPayment, totalQty);
                } else {
                  CustomDialog.showDialogWithoutTittle(
                          'Please Insert Table Number')
                      .then((_) {
                    FocusScope.of(buildContext).requestFocus(_textEditingFocus);
                  });
                }
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  color: CupertinoColors.activeBlue,
                ),
              ),
            ),
            actions: _selectedMenuDataList.map((e) {
              return CupertinoActionSheetAction(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: '${e?.name}',
                        style: TextStyle(
                          color: CupertinoColors.inactiveGray.darkColor,
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    RichText(
                      text: TextSpan(
                        text: '${e?.qty}x',
                        style: TextStyle(
                          color: CupertinoColors.inactiveGray.darkColor,
                        ),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ],
                ),
              );
            }).toList(),
            message: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Your Order',
                  style: TextStyle(
                    color: CupertinoColors.inactiveGray,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Total Quantity : ',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                      children: [
                        TextSpan(
                          text: '$totalQty',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' item',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,),
                        ),
                      ]),
                ),
                SizedBox(
                  height: 5,
                ),
                RichText(
                  text: TextSpan(
                      text: 'Total Payment : IDR ',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                      children: [
                        TextSpan(
                          text: '${MoneyFormatter.format(totalPayment)}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ]),
                ),
                SizedBox(
                  height: 10,
                ),
                CupertinoTextField(
                  focusNode: _textEditingFocus,
                  controller: _tableNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: CupertinoColors.inactiveGray.darkColor,
                        width: 1,
                      )),
                  placeholder: 'Table Number',
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  maxLength: 3,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
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
          _showMenuDetail(menuData);
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    menuData?.name ?? '',
                    style: TextStyle(
                        color: ColorPalette.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: TextSpan(
                      text: menuData?.description ?? '',
                      style: TextStyle(color: Colors.grey[800]),
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
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.width * 0.25,
                      fit: BoxFit.cover,
                      imageUrl: menuData?.imageUrl ?? '',
                      placeholder: (b, s) {
                        return CupertinoActivityIndicator();
                      },
                      errorWidget: (b, s, _) {
                        return Image.asset('assets/icons/ic_logo.png');
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _addMenuButton(menuData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addMenuButton(MenuData? menuData, {bool isFromDetail = false}) {
    var updateQtyIndex = _selectedMenuDataList
        .indexWhere((element) => element?.menuId == menuData?.menuId);
    var isUpdateQty = updateQtyIndex != -1;

    if (isUpdateQty) {
      return Row(
        children: [
          TextButton(
            onPressed: () {
              if ((_selectedMenuDataList[updateQtyIndex]?.qty ?? 0) > 1) {
                _selectedMenuDataList[updateQtyIndex]?.qty =
                    (_selectedMenuDataList[updateQtyIndex]?.qty ?? 0) - 1;
              } else {
                _selectedMenuDataList.removeAt(updateQtyIndex);
              }
              _selectedMenuDataListStream.sink.add(_selectedMenuDataList);
              setState(() {});
            },
            child: Icon(
              Icons.remove,
              color: ColorPalette.secondaryColor,
            ),
            style: TextButton.styleFrom(
              elevation: 0.0,
              enableFeedback: false,
              primary: Colors.transparent,
              minimumSize: Size(25, 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: ColorPalette.secondaryColor, width: 1),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            _selectedMenuDataList[updateQtyIndex]?.qty.toString() ?? '0',
            style: TextStyle(
              color: ColorPalette.secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          TextButton(
            onPressed: () {
              _selectedMenuDataList[updateQtyIndex]?.qty =
                  (_selectedMenuDataList[updateQtyIndex]?.qty ?? 0) + 1;
              _selectedMenuDataListStream.sink.add(_selectedMenuDataList);
              setState(() {});
            },
            child: Icon(
              Icons.add,
              color: ColorPalette.secondaryColor,
            ),
            style: TextButton.styleFrom(
              elevation: 0.0,
              enableFeedback: false,
              primary: Colors.transparent,
              minimumSize: Size(25, 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: ColorPalette.secondaryColor, width: 1),
              ),
            ),
          ),
        ],
      );
    } else {
      var menuDataOrder = MenuDataOrder(
          qty: 1,
          imageUrl: menuData?.imageUrl,
          name: menuData?.name,
          description: menuData?.description,
          price: menuData?.price,
          menuId: menuData?.menuId);
      return TextButton(
        onPressed: () {
          _selectedMenuDataList.add(menuDataOrder);
          _selectedMenuDataListStream.sink.add(_selectedMenuDataList);
          setState(() {});
          if(isFromDetail){
            Navigator.pop(context);
          }
        },
        child: Text(
          'Add',
          style: TextStyle(color: ColorPalette.secondaryColor),
        ),
        style: TextButton.styleFrom(
          elevation: 0.0,
          enableFeedback: false,
          primary: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: ColorPalette.secondaryColor, width: 1),
          ),
        ),
      );
    }
  }

  void _showMenuDetail(MenuData? menuData) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        builder: (BuildContext buildContext) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  child: CachedNetworkImage(
                    imageUrl: menuData?.imageUrl ?? '',
                    fit: BoxFit.cover,
                    placeholder: (b, s) {
                      return CupertinoActivityIndicator();
                    },
                    errorWidget: (b, s, _) {
                      return Image.asset('assets/icons/ic_logo.png');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            menuData?.name ?? '',
                            style: TextStyle(
                                color: ColorPalette.primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          RichText(
                            text: TextSpan(
                              text: menuData?.description ?? '',
                              style: TextStyle(color: Colors.grey[800]),
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
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      _addMenuButton(menuData, isFromDetail: true),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _addOrder(String tableNumber, double totalPayment, int totalQty) async {
    print('Table Number ============ $tableNumber');
    CustomDialog.showLoading();
    await OrderInteractor.createNewOrder(OrderData(
      customerId: widget._userData?.uid,
      customerName: widget._userData?.name,
      dateTime: DateTime.now().millisecondsSinceEpoch,
      orderStatus: getStringOrderEnum[OrderEnum.Waiting] ?? '',
      tableNumber: tableNumber,
      menu: _selectedMenuDataList,
      totalPayment: totalPayment.toInt(),
      totalQty: totalQty
    )).then((value) {
      Navigator.pop(context);
      CustomDialog.showDialogWithoutTittle("Success Adding Order")
          .then((value) {
        Navigator.pop(context, true);
      });
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.showDialogWithoutTittle(e);
    });
  }
}
