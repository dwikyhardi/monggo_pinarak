import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
            right: 10.0,
            left: 10.0,
            child: ElevatedButton(
              onPressed: () {
                _addOrder();
              },
              child: Text('Add Order'),
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
              Text(orderData?.customerName ?? ''),
              Text('Table Number : ${orderData?.tableNumber ?? ''}'),
              Text(
                  '${formatterDMY.format(DateTime.fromMillisecondsSinceEpoch(orderData?.dateTime ?? 0))}'),
            ],
          ),
        ),
      ),
    );
  }

  void _updateOrder(OrderData? orderData) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        isScrollControlled: true,
        elevation: 5,
        context: context,
        builder: (BuildContext buildContext) {
          return UpdateOrder(widget._userRole, orderData, _updateOrderStatus);
        });
  }

  void _updateOrderStatus(OrderData? orderData) {
    CustomDialog.showLoading();
    var orderStatus = orderData?.orderStatus ?? '';
    switch (getOrderEnum[orderStatus]) {
      case OrderEnum.Waiting:
        orderData?.orderStatus = getStringOrderEnum[OrderEnum.Process];
        break;
      case OrderEnum.Process:
      case OrderEnum.Finish:
        orderData?.orderStatus = getStringOrderEnum[OrderEnum.Finish];
        break;
      default:
        orderData?.orderStatus = getStringOrderEnum[OrderEnum.Waiting];
    }
    OrderInteractor.updateOrder(orderData, orderData?.orderId).then((value) {
      Navigator.pop(context);
      CustomDialog.showDialogWithoutTittle('Success Update Order')
          .then((value) => _refreshController.requestRefresh());
    }).catchError((e) {
      Navigator.pop(context);
      CustomDialog.showDialogWithoutTittle(e);
    });
  }

  void _addOrder() {
    routePush(AddOrder(widget._userData)).then((isNewOrder) {
      if (isNewOrder != null) {
        if (isNewOrder) {
          _getOrderList();
        }
      }
    });
  }
}
