import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class AddOrder extends StatefulWidget {
  const AddOrder(this._userData, this._userRole, {Key? key}) : super(key: key);
  final UserData? _userData;
  final UserEnum? _userRole;

  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  final StreamController<List<MenuData>> _menuDataListStream =
      StreamController();

  final StreamController<List<MenuDataOrder?>> _selectedMenuDataListStream =
      StreamController();

  List<MenuDataOrder?> _selectedMenuDataList = <MenuDataOrder?>[];

  int _selectedLayoutConfig = 0;

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
    OrderInteractor.getMenuList().then((value) {
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
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ToggleSwitch(
                            minWidth: MediaQuery.of(context).size.width,
                            activeBgColor: ColorPalette.secondaryColor,
                            initialLabelIndex: _selectedLayoutConfig,
                            cornerRadius: 20.0,
                            activeFgColor: Colors.white,
                            inactiveBgColor: CupertinoColors.inactiveGray,
                            inactiveFgColor: Colors.white,
                            labels: ['', ''],
                            icons: [
                              CupertinoIcons.rectangle_grid_1x2,
                              CupertinoIcons.rectangle_grid_2x2
                            ],
                            onToggle: (index) {
                              _selectedLayoutConfig = index;
                              setState(() {});
                            },
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: _buildListView(context, snapshot),
                        ),
                      ],
                    );
                  } else {
                    return NoDataPage();
                  }
                } else {
                  return LoadingPage();
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

  Widget _buildListView(
      BuildContext context, AsyncSnapshot<List<MenuData>> snapshot) {
    if (_selectedLayoutConfig == 0) {
      return ListView.builder(
          padding:
              EdgeInsets.only(bottom: _selectedMenuDataList.length > 0 ? MediaQuery.of(context).size.width * 0.15 : 10),
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (BuildContext buildContext, int index) {
            return MenuOrderListView(
              menuData: snapshot.data?[index],
              addMenuButton: _addMenuButton,
              onTapCard: _showMenuDetail,
            );
          });
    } else {
      return GridView.builder(
          padding:
              EdgeInsets.only(bottom: _selectedMenuDataList.length > 0 ? MediaQuery.of(context).size.width * 0.15 : 10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
          ),
          itemCount: snapshot.data?.length ?? 0,
          itemBuilder: (BuildContext buildContext, int index) {
            return MenuOrderGridView(
              menuData: snapshot.data?[index],
              addMenuButton: _addMenuButton,
              onTapCard: _showMenuDetail,
            );
          });
    }
  }

  void _addOrderConfirmation() {
    var totalQty = 0;
    var totalPayment = 0.0;
    TextEditingController _tableNumberController = TextEditingController();
    TextEditingController _nameController = TextEditingController();
    TextEditingController _phoneNumberNumberController =
        TextEditingController();
    TextEditingController _emailController = TextEditingController();
    _selectedMenuDataList.forEach((element) {
      totalQty = totalQty + (element?.qty ?? 0);
      totalPayment =
          totalPayment + ((element?.qty ?? 0) * (element?.price ?? 0));
    });
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext buildContext) {
          return AddOrderConfirmation(
              tableNumberController: _tableNumberController,
              emailController: _emailController,
              nameController: _nameController,
              phoneNumberController: _phoneNumberNumberController,
              userRole: widget._userRole ?? UserEnum.User,
              selectedMenuDataList: _selectedMenuDataList,
              addOrder: _addOrder,
              totalQty: totalQty,
              totalPayment: totalPayment);
        });
  }

  Widget _addMenuButton(MenuData? menuData, {bool isFromDetail = false}) {
    var updateQtyIndex = _selectedMenuDataList
        .indexWhere((element) => element?.menuId == menuData?.menuId);
    var isUpdateQty = updateQtyIndex != -1;

    if (isUpdateQty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
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
          if (isFromDetail) {
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
    var updateQtyIndex = _selectedMenuDataList
        .indexWhere((element) => element?.menuId == menuData?.menuId);
    var isAddedToCart = updateQtyIndex != -1;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        builder: (BuildContext buildContext) {
          return MenuDetailOrder(
            menuData: menuData,
            addMenuButton: _addMenuButton,
            isAddedToCart: isAddedToCart,
          );
        });
  }

  void _addOrder(String tableNumber, double totalPayment, int totalQty,
      String custName, String phoneNumber, String email) async {
    print('Table Number ============ $tableNumber');
    // CustomDialog.showLoading();
    await routePush(
      Payment(),
      RouterType.cupertino,
    ).then((value) async {
      if (value != null) {
        await _createOrder(
          value,
          totalPayment,
          tableNumber,
          totalQty,
          custName,
          phoneNumber,
          email,
        );
      }
    });
  }

  Future<void> _createOrder(value, double totalPayment, String tableNumber,
      int totalQty, String custName, String phoneNumber, String email) async {
    print('_addOrder PaymentMethod ======== ${value.toString()}');
    var payment = PaymentData(
      paymentMethod: getStringPaymentMethod[value],
      totalPayment: totalPayment.toInt(),
      paymentStatus: 'pending',
    );

    var orderData = OrderData(
        payment: payment,
        customerId: widget._userData?.uid,
        dateTime: DateTime.now().millisecondsSinceEpoch,
        orderStatus: getStringOrderEnum[OrderEnum.WaitingPayment] ?? '',
        tableNumber: tableNumber,
        menu: _selectedMenuDataList,
        totalPayment: totalPayment.toInt(),
        totalQty: totalQty);

    print('_addOrder OrderData ======== ${orderData.toJson()}');

    if (widget._userRole == UserEnum.Admin ||
        widget._userRole == UserEnum.Waitress ||
        widget._userRole == UserEnum.Cashier) {
      CustomDialog.showLoading();
      await OrderInteractor.createNewOrderAdmin(
              orderData, value, custName, phoneNumber, email)
          .then((value) {
        Navigator.pop(context);
        CustomDialog.showDialogWithoutTittle("Success Adding Order")
            .then((value) {
          Navigator.pop(context, true);
        });
      }).catchError((e, stack) {
        Navigator.pop(context);
        print('Stack Trace ================== ${stack.toString()}');
        if (e['orderId'] != null) {
          OrderInteractor.deleteOrder(e['orderId']);
          CustomDialog.showDialogWithoutTittle(e['errorCause']);
        } else {
          CustomDialog.showDialogWithoutTittle(e.toString());
        }
      });
    } else {
      CustomDialog.showLoading();
      await OrderInteractor.createNewOrder(
        orderData,
        value,
        widget._userData,
        phoneNumber,
      ).then((value) {
        Navigator.pop(context);
        CustomDialog.showDialogWithoutTittle("Success Adding Order")
            .then((value) {
          Navigator.pop(context, true);
        });
      }).catchError((e, stack) {
        Navigator.pop(context);
        print('Stack Trace ================== ${stack.toString()}');
        if (e['orderId'] != null) {
          OrderInteractor.deleteOrder(e['orderId']);
          CustomDialog.showDialogWithoutTittle(e['errorCause']);
        } else {
          CustomDialog.showDialogWithoutTittle(e.toString());
        }
      });
    }
  }
}
