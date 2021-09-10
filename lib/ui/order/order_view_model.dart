import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:monggo_pinarak/model/order_data.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class OrderViewModel {
  static CollectionReference _order =
      FirebaseFirestore.instance.collection('order');

  ///Get Method

  static Future<List<OrderData>> getOrderList() async {
    List<OrderData> orderDataList = <OrderData>[];
    await _order.get().then((orderList) {
      orderList.docs.forEach((orderData) {
        if (orderData.exists && orderData.data() != null) {
          print(
              'Order Object ${orderData.id} ======== ${jsonEncode(orderData.data())}');
          orderDataList.add(OrderData.fromJson(orderData.data() as Map<String, dynamic>));
        }
      });
    });

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
      return await getOrderData(value.id).then((value) {
        return value;
      });
    });
  }
}
