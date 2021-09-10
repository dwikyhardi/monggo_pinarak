import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';
import 'package:monggo_pinarak/ui/order/add_order.dart';

class Order extends StatefulWidget {
  const Order(this._drawerChangeStream, this._userData, {Key? key})
      : super(key: key);
  final StreamController<DrawerItems?> _drawerChangeStream;
  final UserData? _userData;

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  final StreamController<List<OrderData>> _orderListStream = StreamController();

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

  void _getOrderList(){
    OrderInteractor.getOrderList().then((orderList) {
      _orderListStream.sink.add(orderList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          StreamBuilder<List<OrderData>>(
              stream: _orderListStream.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext buildContext, int index) {
                          return _cardOrder(snapshot.data?[index]);
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
    if((orderData?.menu?.length ?? 0) > 1){
      cardTitle = '${orderData?.menu?.first?.name} & ${(orderData?.menu?.length ?? 0) - 1} Other Menu';
    }else{
      cardTitle = orderData?.menu?.first?.name ?? '';
    }
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/icons/ic_logo.png',
              height: MediaQuery.of(context).size.height * 0.15,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(cardTitle,style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: ColorPalette.primaryColor
              ),),
              Text(orderData?.customerName ?? ''),
              Text(orderData?.orderStatus ?? ''),
              Text(orderData?.tableNumber ?? ''),
              Text(DateTime.fromMillisecondsSinceEpoch(orderData?.dateTime ?? 0).toString()),
            ],
          ),
        ],
      ),
    );
  }

  void _addOrder() {
    routePush(AddOrder(widget._userData)).then((isNewOrder) {
      if(isNewOrder != null){
        if(isNewOrder){
          _getOrderList();
        }
      }
    });
  }
}
