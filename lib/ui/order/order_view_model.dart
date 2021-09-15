import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class OrderViewModel {
  static CollectionReference _order =
      FirebaseFirestore.instance.collection('order');

  ///Get Method

  static Future<List<OrderData>> getOrderList(
      UserEnum _userRole, String _userId,
      {ReportEnum reportType = ReportEnum.Daily}) async {
    var day = 0;
    switch (reportType) {
      case ReportEnum.Day:
        day = 1;
        break;
      case ReportEnum.Daily:
        day = 7;
        break;
      case ReportEnum.Monthly:
        day = 30;
        break;
      case ReportEnum.Annual:
        day = 365;
        break;
    }
    List<OrderData> orderDataList = <OrderData>[];
    if (_userRole == UserEnum.User) {
      await _order
          .where('date_time',
              isGreaterThanOrEqualTo: DateTime.now()
                  .subtract(Duration(
                    days: day,
                  ))
                  .millisecondsSinceEpoch,
              isLessThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
          .where('customer_id', isEqualTo: _userId)
          .orderBy('date_time', descending: true)
          .get()
          .then((orderList) {
        if (orderList.size > 0) {
          return orderList.docs.forEach((orderData) {
            if (orderData.exists && orderData.data() != null) {
              print(
                  'Order Object ${orderData.id} ======== ${jsonEncode(orderData.data())}');
              var order =
                  OrderData.fromJson(orderData.data() as Map<String, dynamic>);
              return orderDataList.add(order);
            }
          });
        }
      }).catchError((e) {
        return Future.error(e);
      });
    } else {
      await _order
          .where('date_time',
              isGreaterThanOrEqualTo: DateTime.now()
                  .subtract(Duration(
                    days: day,
                  ))
                  .millisecondsSinceEpoch,
              isLessThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
          .orderBy('date_time', descending: true)
          .get()
          .then((orderList) {
        if (orderList.size > 0) {
          return orderList.docs.forEach((orderData) {
            if (orderData.exists && orderData.data() != null) {
              print(
                  'Order Object ${orderData.id} ======== ${jsonEncode(orderData.data())}');
              var order =
                  OrderData.fromJson(orderData.data() as Map<String, dynamic>);
              orderDataList.add(order);
            }
          });
        }
      }).catchError((e) {
        return Future.error(e);
      });
    }

    return orderDataList;
  }

  static Future<OrderData> getOrderData(String orderId) async {
    OrderData orderDatas = OrderData();
    await _order.doc(orderId).get().then((orderData) {
      if (orderData.exists) {
        orderDatas =
            OrderData.fromJson(orderData.data() as Map<String, dynamic>);
        print(
            'Order Data Object ${orderData.id} ======== ${jsonEncode(orderDatas)}');
        return orderDatas;
      } else {
        return Future.error('Order Not Exist');
      }
    }).catchError((e) {
      return Future.error(e);
    });
    return orderDatas;
  }

  ///Add Method
  static Future<OrderData> createNewOrder(OrderData orderData) async {
    return await _order.add(orderData.toJson()).then((value) async {
      return await updateOrder(
        orderData,
        value.id,
      ).then((value) {
        return value;
      });
    });
  }

  /// Update Method
  static Future<OrderData> updateOrder(
      OrderData orderData, String orderId) async {
    orderData.orderId = orderId;
    return await _order
        .doc(orderId)
        .set(orderData.toJson())
        .then((value) async {
      return await getOrderData(orderId).then((value) {
        return value;
      });
    });
  }
}
