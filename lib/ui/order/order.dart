import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class Order extends StatefulWidget {
  const Order(this._userRole, this._drawerChangeStream, this._userData,
      {Key? key})
      : super(key: key);
  final StreamController<DrawerItems?> _drawerChangeStream;
  final UserData? _userData;
  final UserEnum _userRole;

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  final StreamController<List<OrderData>> _orderListStream = StreamController();
  final DateFormat formatterDMY = DateFormat('dd-MM-yyyy HH:mm');
  RefreshController _refreshController = RefreshController();

  @override
  void dispose() {
    _orderListStream.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getOrderList();
  }

  void _getOrderList() {
    OrderInteractor.getOrderList(widget._userRole, widget._userData?.uid ?? '',
            reportType: ReportEnum.Day)
        .then((orderList) {
      _orderListStream.sink.add(orderList);
      _refreshController.refreshCompleted();
    }).catchError((e) {
      print(e);
      _refreshController.refreshFailed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          StreamBuilder<List<OrderData>>(
              stream: _orderListStream.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && (snapshot.data?.length ?? 0) > 0) {
                    return SmartRefresher(
                      controller: _refreshController,
                      onRefresh: _getOrderList,
                      enablePullDown: true,
                      enablePullUp: false,
                      scrollDirection: Axis.vertical,
                      header: WaterDropHeader(
                        waterDropColor: ColorPalette.primaryColor,
                      ),
                      child: ListView.builder(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.width * 0.15),
                          itemCount: snapshot.data?.length ?? 0,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext buildContext, int index) {
                            return _cardOrder(snapshot.data?[index]);
                          }),
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
            right: 10.0,
            left: 10.0,
            child: PrimaryColorButton(
              onPressed: () {
                _addOrder();
              },
              textTitle: 'Add Order',
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.width * 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardOrder(OrderData? orderData) {
    var cardTitle = '';
    if ((orderData?.menu?.length ?? 0) > 1) {
      cardTitle =
          '${orderData?.menu?.first?.name} & ${(orderData?.menu?.length ?? 0) - 1} Other Menu';
    } else {
      cardTitle = orderData?.menu?.first?.name ?? '';
    }
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          _updateOrder(orderData);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cardTitle,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: ColorPalette.primaryColor),
                  ),
                  Text(orderData?.orderStatus ?? ''),
                ],
              ),
              Text(
                '${orderData?.customer?.firstName ?? ''} ${orderData?.customer?.lastName ?? ''}',
              ),
              Text('Table Number : ${orderData?.tableNumber ?? ''}'),
              Text(
                  '${formatterDMY.format(DateTime.fromMillisecondsSinceEpoch(orderData?.dateTime ?? 0))}'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateOrder(OrderData? orderData) async {
    print('OrderId === ${orderData?.orderId}');

    if (getOrderEnum[orderData?.orderStatus] == OrderEnum.Cancel) {
      _showDetailOrder(orderData);
    } else {
      await OrderInteractor.getOrderStatus(orderData?.orderId ?? '')
          .then((orderStatus) async {
        Navigator.pop(context);
        await _checkOrderStatus(orderStatus, orderData, false).then((value) {
          print('_checkOrderStatus Value ========= ${jsonEncode(value)}');
          _showDetailOrder(value);
        });
      }).catchError((e, stack) {
        Navigator.pop(context);
        print('Stack ====== ${stack.toString()}');
        CustomDialog.showDialogWithoutTittle(e.toString());
      });
    }
  }

  void _showDetailOrder(OrderData? value) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        isScrollControlled: true,
        elevation: 5,
        context: context,
        builder: (BuildContext buildContext) {
          return UpdateOrder(
            widget._userRole,
            value,
            _updateOrderStatus,
            _payOrder,
            _cancelOrder,
          );
        });
  }

  void _payOrder(OrderData? orderData) {
    OrderInteractor.getOrderStatus(orderData?.orderId ?? '')
        .then((orderStatus) {
      Navigator.pop(context);
      _checkOrderStatus(orderStatus, orderData, true);
    }).catchError((e, stack) {
      Navigator.pop(context);
      print('Stack ====== ${stack.toString()}');
      CustomDialog.showDialogWithoutTittle(e.toString());
    });
  }

  Future<OrderData?> _checkOrderStatus(Map<String, dynamic> orderStatus,
      OrderData? orderData, bool isPay) async {
    print('OrderStatus ============= ${jsonEncode(orderStatus)}');
    if (orderStatus['transaction_status'] !=
        orderData?.payment?.paymentStatus) {
      orderData?.payment?.paymentStatus = orderStatus['transaction_status'];
      orderData?.payment?.paymentMethod = orderStatus['payment_type'];
      orderData?.payment?.totalPayment =
          double.tryParse(orderStatus['gross_amount'])?.toInt();
      return await _updateOrderStatus(orderData, false).then((value) {
        print('_updateOrderStatus Value ======= ${jsonEncode(value)}');
        if (isPay) {
          if (orderStatus['status_code'] == "407") {
            _rechargeOrder(orderData);
          } else if (orderStatus['status_code'] == "201") {
            _payOrderBottomSheet(orderData);
          }
        }
        return value;
      });
    } else {
      if (isPay) {
        if (orderStatus['status_code'] == "407") {
          _rechargeOrder(orderData);
        } else if (orderStatus['status_code'] == "201") {
          _payOrderBottomSheet(orderData);
        }
      }
      return orderData;
    }
  }

  void _rechargeOrder(OrderData? orderData) async {
    if (orderData != null) {
      print(
          'Payment method ====== ${getPaymentMethod[orderData.payment?.paymentMethod]}');
      print('Payment method ====== ${orderData.payment?.paymentMethod}');
      await OrderInteractor.rechargeOrder(
              orderData, getPaymentMethod[orderData.payment?.paymentMethod])
          .then((orderData) {
        _payOrderBottomSheet(orderData);
      }).catchError((e) {
        CustomDialog.showDialogWithoutTittle(e.toString());
      });
    } else {
      CustomDialog.showDialogWithoutTittle('Order Is Not Valid');
    }
  }

  void _payOrderBottomSheet(OrderData? orderData) {
    var qrCodeUrl = '';
    var jumpAppUrl = '';
    var appName =
        '${orderData?.payment?.paymentMethod?.substring(0, 1).toUpperCase()}${orderData?.payment?.paymentMethod?.substring(1, orderData.payment?.paymentMethod?.length)}';
    print('OrderData ===== ${jsonEncode(orderData)}');
    orderData?.payment?.actions?.forEach((element) {
      if (element?.name == 'generate-qr-code') {
        qrCodeUrl = element?.url ?? '';
      } else if (element?.name == 'deeplink-redirect') {
        jumpAppUrl = element?.url ?? '';
      }
    });
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (BuildContext buildContext) {
          return CupertinoActionSheet(
            title: Text('Select Payment'),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                  _jumpApps(jumpAppUrl);
                },
                child: Text(
                  'Open $appName Apps',
                  style: TextStyle(
                    color: CupertinoColors.activeBlue,
                  ),
                ),
              ),
              if (qrCodeUrl.isNotEmpty)
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                    openQRCode(qrCodeUrl);
                  },
                  child: Text(
                    'Show QR Code',
                    style: TextStyle(
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(buildContext);
              },
              child: Text(
                'Close',
                style: TextStyle(
                  color: CupertinoColors.activeBlue,
                ),
              ),
            ),
          );
        });
  }

  void openQRCode(String? qrUrl) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        builder: (BuildContext buildContext) {
          return ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                child: CachedNetworkImage(
                  imageUrl: qrUrl ?? '',
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
          );
        });
  }

  Future<void> _jumpApps(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _cancelOrder(OrderData? orderData) {
    //TODO: add cancel to midtrans
    CustomDialog.showLoading();
    OrderInteractor.updateOrder(orderData, true).then((value) {
      Navigator.pop(context);
      CustomDialog.showDialogWithoutTittle('Success Cancel Order')
          .then((value) => _refreshController.requestRefresh());
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.showDialogWithoutTittle(e.toString());
    });
  }

  Future<OrderData> _updateOrderStatus(
      OrderData? orderData, bool isShowDetail) async {
    var data = orderData;
    CustomDialog.showLoading();
    if(data?.payment?.paymentStatus == 'pending' || data?.payment?.paymentStatus == 'expire'){
      data?.orderStatus = getStringOrderEnum[OrderEnum.WaitingPayment];
      print('Update ====== ${jsonEncode(data)}');
    }
    await OrderInteractor.updateOrder(data, false).then((value) {
      data = value;
      Navigator.pop(context);
      if (isShowDetail) {
        CustomDialog.showDialogWithoutTittle('Success Update Order')
            .then((value) => _refreshController.requestRefresh());
      } else {
        _refreshController.requestRefresh();
      }
    }).catchError((e) {
      Navigator.pop(context);
      if (isShowDetail) {
        CustomDialog.showDialogWithoutTittle(e.toString());
      }
    });
    return data ?? OrderData();
  }

  void _addOrder() {
    routePush(AddOrder(widget._userData, widget._userRole)).then((isNewOrder) {
      if (isNewOrder != null) {
        if (isNewOrder) {
          _getOrderList();
        }
      }
    });
  }
}
