import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class UpdateOrder extends StatelessWidget {
  final OrderData? _orderData;
  final UserEnum? _userRole;
  final Function(OrderData?) _updateOrderStatus;
  UpdateOrder(this._userRole, this._orderData,this._updateOrderStatus, {Key? key}) : super(key: key);
  final DateFormat formatterDMY = DateFormat('dd-MM-yyyy HH:mm');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _userRole == UserEnum.User ? 'Detail Order':'Update Order Status',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
          Divider(
            height: 30,
            color: CupertinoColors.inactiveGray,
            thickness: 1.5,
          ),
          Text(
            'Order Detail',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
          Divider(
            height: 20,
          ),
          RichText(
            text: TextSpan(
                text: 'Name : ',
                style: TextStyle(color: Colors.black, fontSize: 12),
                children: [
                  TextSpan(
                    text: _orderData?.customerName ?? '',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
          ),
          RichText(
            text: TextSpan(
                text: 'Table Number : ',
                style: TextStyle(color: Colors.black, fontSize: 12),
                children: [
                  TextSpan(
                    text: _orderData?.tableNumber ?? '',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
          ),
          RichText(
            text: TextSpan(
                text: 'Order Date : ',
                style: TextStyle(color: Colors.black, fontSize: 12),
                children: [
                  TextSpan(
                    text:
                    '${formatterDMY.format(DateTime.fromMillisecondsSinceEpoch(_orderData?.dateTime ?? 0))}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
          ),
          Divider(
            height: 20,
          ),
          Text('Menu'),
          Divider(
            height: 20,
          ),
          Flexible(
            fit: FlexFit.tight,
            child: ListView.builder(
                itemCount: _orderData?.menu?.length,
                itemBuilder: (BuildContext buildContext, int index) {
                  var data = _orderData?.menu?[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${data?.name} ',
                            style: TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                          Text(
                            'x${data?.qty}',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(
                        height: 20,
                      ),
                    ],
                  );
                }),
          ),
          Divider(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Quantity : ',
                style: TextStyle(
                    color: Colors.black, fontSize: 14),
              ),
              Text(
                '${_orderData?.totalQty}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Payment : ',
                style: TextStyle(
                    color: Colors.black, fontSize: 14),
              ),
              Text(
                'IDR ${MoneyFormatter.format(double.tryParse(_orderData?.totalPayment.toString() ?? '0'))}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
                style: ElevatedButton.styleFrom(
                  primary: ColorPalette.primaryColor,
                  onPrimary: Colors.white,
                  minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.4,
                      MediaQuery.of(context).size.width * 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              if (_userRole == UserEnum.Admin ||
                  _userRole == UserEnum.Cashier)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _updateOrderStatus(_orderData);
                  },
                  child: Text('Update Status Order'),
                  style: ElevatedButton.styleFrom(
                    primary: ColorPalette.primaryColor,
                    onPrimary: Colors.white,
                    minimumSize: Size(
                        MediaQuery.of(context).size.width * 0.4,
                        MediaQuery.of(context).size.width * 0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
