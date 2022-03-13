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
              // print(
              //     'Order Object ${orderData.id} ======== ${jsonEncode(orderData.data())}');
              var order =
                  OrderData.fromJson(orderData.data() as Map<String, dynamic>);
              return orderDataList.add(order);
            }
          });
        }
      }).catchError((e, stack) {
        return Future.error(e, stack);
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
              // print(
              //     'Order Object ${orderData.id} ======== ${jsonEncode(orderData.data())}');
              var order =
                  OrderData.fromJson(orderData.data() as Map<String, dynamic>);
              orderDataList.add(order);
            }
          });
        }
      }).catchError((e, stack) {
        return Future.error(e, stack);
      });
    }

    return orderDataList;
  }

  static Future<OrderData> getOrderData(String? orderId) async {
    if (orderId != null) {
      return await _order.doc(orderId).get().then((orderData) {
        if (orderData.exists) {
          var data = orderData.data() as Map<String, dynamic>;
          var orderDatas = OrderData.fromJson(data);
          print(
              'Order Data Object ${orderData.id} ======== ${jsonEncode(orderDatas)}');
          return orderDatas;
        } else {
          return Future.error('Order Not Exist');
        }
      }).catchError((e, stack) {
        return Future.error(e, stack);
      }) as OrderData;
    } else {
      return Future.error('Order Not Exist');
    }
  }

  ///Add Method
  static Future<OrderData> createNewOrder(
    OrderData orderData,
    PaymentMethod paymentMethod,
  ) async {
    return await _order.add(orderData.toJson()).then((value) async {
      switch (paymentMethod) {
        case PaymentMethod.Gopay:
          return await createNewOrderGopay(
            orderData,
            value.id,
          );
        case PaymentMethod.ShopeePay:
          return await createNewOrderShopeePay(
            orderData,
            value.id,
          );
        // case PaymentMethod.QRIS:
        //   return await createNewOrderQRIS(
        //     orderData,
        //     value.id,
        //   );
        default:
          return Future.error('Invalid Payment Method');
      }
    }) as OrderData;
  }

  static Future<OrderData> createNewOrderAdmin(
    OrderData orderData,
    PaymentMethod paymentMethod,
  ) async {
    return await _order.add(orderData.toJson()).then((value) async {
      print(
          '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
      print('Success Add order to firestore');
      print(
          '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
      switch (paymentMethod) {
        case PaymentMethod.Gopay:
          print(
              '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
          print('switch to gopay');
          print(
              '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
          return createNewOrderGopay(
            orderData,
            value.id,
          );
        case PaymentMethod.ShopeePay:
          print(
              '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
          print('switch to shopeepay');
          print(
              '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
          return createNewOrderShopeePay(
            orderData,
            value.id,
          );
        // case PaymentMethod.QRIS:
        //   print(
        //       '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        //   print('switch to qris');
        //   print(
        //       '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        //   return createNewOrderQRIS(
        //     orderData,
        //     value.id,
        //   );
        default:
          print(
              '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
          print('switch default or invalid payment');
          print(
              '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
          return Future.error('Invalid Payment Method');
      }
    }).catchError((e, stack) {
      return Future.error(e, stack);
    }) as OrderData;
  }

  static Future<OrderData> createNewOrderGopay(
      OrderData orderData, String orderId) async {
    print(
        '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
    print('Continue to create order gopay ');
    print(
        '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
    var gopayPaymentModel = createGopayPaymentModel(orderData, orderId);
    return await createOrderEWalletMidtrans(gopayPaymentModel.toJson())
        .then((paymentResponse) async {
      print(
          '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
      print(
          'Success to create order gopay continue to update order ======== $paymentResponse');
      print(
          '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
      EWalletPaymentResponse gopayPaymentResponse =
          EWalletPaymentResponse.fromJson(paymentResponse ?? {});
      print(
          '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
      print('EwalletPaymentResponse ======== ${gopayPaymentResponse.toJson()}');
      print(
          '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
      orderData.payment = PaymentData(
          actions: gopayPaymentResponse.actions,
          totalPayment:
              double.tryParse(gopayPaymentResponse.grossAmount ?? '0')?.toInt(),
          paymentMethod: gopayPaymentResponse.paymentType,
          paymentStatus: gopayPaymentResponse.transactionStatus);
      orderData.orderId = orderId;
      print(
          '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
      print('Create update order data ====== ${orderData.toJson()} ');
      print(
          '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
      return await updateOrder(orderData).then((value) {
        print(
            '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        print('Success to Update order data ===== ${value.toJson()} ');
        print(
            '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        return value;
      });
    });
  }

  static Future<OrderData> createNewOrderShopeePay(
    OrderData orderData,
    String orderId,
  ) async {
    var shopeepayPaymentModel = createShopeepayPaymentModel(
      orderData,
      orderId,
    );
    return await createOrderEWalletMidtrans(shopeepayPaymentModel.toJson())
        .then((paymentResponse) async {
      EWalletPaymentResponse shopeepayPaymentResponse =
          EWalletPaymentResponse.fromJson(paymentResponse ?? {});
      orderData.payment = PaymentData(
          actions: shopeepayPaymentResponse.actions,
          totalPayment:
              double.tryParse(shopeepayPaymentResponse.grossAmount ?? '0')
                  ?.toInt(),
          paymentMethod: shopeepayPaymentResponse.paymentType,
          paymentStatus: shopeepayPaymentResponse.transactionStatus);
      orderData.orderId = orderId;
      return await updateOrder(orderData).then((value) {
        return value;
      });
    });
  }

  // static Future<OrderData> createNewOrderQRIS(
  //   OrderData orderData,
  //   String orderId,
  // ) async {
  //   var qrisPaymentModel = createQRISPaymentModel(orderData, orderId);
  //   return await createOrderEWalletMidtrans(qrisPaymentModel.toJson())
  //       .then((paymentResponse) async {
  //     EWalletPaymentResponse qrisPaymentResponse =
  //         EWalletPaymentResponse.fromJson(paymentResponse ?? {});
  //     orderData.payment = PaymentData(
  //         actions: qrisPaymentResponse.actions,
  //         totalPayment:
  //             double.tryParse(qrisPaymentResponse.grossAmount ?? '0')?.toInt(),
  //         paymentMethod: qrisPaymentResponse.paymentType,
  //         paymentStatus: qrisPaymentResponse.transactionStatus);
  //     orderData.orderId = orderId;
  //     return await updateOrder(orderData).then((value) {
  //       return value;
  //     });
  //   });
  // }

  static EWalletPaymentRequest createGopayPaymentModel(
      OrderData orderData, String orderId) {
    return EWalletPaymentRequest(
      customerDetails: orderData.customer,
      gopay: Gopay(
        // callbackUrl: 'monggoPinarak://',
        enableCallback: false,
      ),
      paymentType: 'gopay',
      transactionDetails: TransactionDetails(
        orderId: orderId,
        grossAmount: orderData.totalPayment,
      ),
      itemDetails: orderData.menu?.map((e) {
        return ItemDetails(
          price: e?.price,
          name: e?.name,
          id: e?.menuId,
          quantity: e?.qty,
        );
      }).toList(),
    );
  }

  static EWalletPaymentRequest createShopeepayPaymentModel(
      OrderData orderData, String orderId) {
    return EWalletPaymentRequest(
      customerDetails: orderData.customer,
      shopeepay: Shopeepay(
        callbackUrl: 'monggoPinarak://',
      ),
      paymentType: 'shopeepay',
      transactionDetails: TransactionDetails(
        orderId: orderId,
        grossAmount: orderData.totalPayment,
      ),
      itemDetails: orderData.menu?.map((e) {
        return ItemDetails(
          price: e?.price,
          name: e?.name,
          id: e?.menuId,
          quantity: e?.qty,
        );
      }).toList(),
    );
  }

  // static EWalletPaymentRequest createQRISPaymentModel(
  //     OrderData orderData, String orderId) {
  //   return EWalletPaymentRequest(
  //     customerDetails: orderData.customer,
  //     qris: QRIS(acquirer: 'gopay'),
  //     paymentType: 'qris',
  //     transactionDetails: TransactionDetails(
  //       orderId: orderId,
  //       grossAmount: orderData.totalPayment,
  //     ),
  //     itemDetails: orderData.menu?.map((e) {
  //       return ItemDetails(
  //         price: e?.price,
  //         name: e?.name,
  //         id: e?.menuId,
  //         quantity: e?.qty,
  //       );
  //     }).toList(),
  //   );
  // }

  static Future<Map<String, dynamic>?> createOrderEWalletMidtrans(
      Map<String, dynamic> request) async {
    return await DioService.setupDio().then((dio) async {
      var createOrder = await DioClient(dio).chargeOrder(request);
      if (createOrder['status_code'] == '201' ||
          createOrder['status_code'] == '200') {
        print(
            '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        print(
            'Success Create order to midtrans ${createOrder['status_message']} ');
        print(
            '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        return createOrder;
      } else {
        return Future.error({
          'errorCause': 'Error Creating Order to Midtrans',
          'orderId': request['transaction_details']['order_id']
        });
      }
    });
  }

  static Future<Map<String, dynamic>?> cancelOrderEWalletMidtrans(
      String orderId) async {
    return await DioService.setupDio().then((dio) async {
      var cancelOrder = await DioClient(dio).cancelOrder({}, orderId);
      if (cancelOrder['status_code'] == '201' ||
          cancelOrder['status_code'] == '200' ||
          cancelOrder['status_code'] == '202') {
        print(
            '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        print(
            'Success Cancel order to midtrans ${cancelOrder['status_message']} ');
        print(
            '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        return cancelOrder;
      } else if (cancelOrder['status_code'] == '412') {
        return Future.error(cancelOrder['status_message'].toString());
      } else {
        return Future.error('Error Cancel Order to Midtrans');
      }
    });
  }

  /// Update Method
  static Future<OrderData> updateOrder(OrderData orderData) async {
    return await _order
        .doc(orderData.orderId)
        .set(orderData.toJson())
        .then((value) async {
      if (getOrderEnum[orderData.orderStatus] == OrderEnum.Cancel) {
        return await cancelOrderEWalletMidtrans(orderData.orderId ?? '')
            .then((value) async {
          print(
              '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
          print('Success Update Order data ${orderData.orderId}');
          print(
              '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
          return await getOrderData(orderData.orderId).then((value) {
            return value;
          });
        });
      } else {
        print(
            '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        print('Success Update Order data ${orderData.orderId}');
        print(
            '═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════');
        return await getOrderData(orderData.orderId).then((value) {
          return value;
        });
      }
    });
  }

  ///Recharge order
  static Future<OrderData> rechargeOrder(
      OrderData orderData, PaymentMethod paymentMethod) async {
    switch (paymentMethod) {
      case PaymentMethod.Gopay:
        return createNewOrderGopay(orderData, orderData.orderId ?? '');
      case PaymentMethod.ShopeePay:
        return createNewOrderShopeePay(orderData, orderData.orderId ?? '');
      default:
        return OrderData();
    }
  }

  ///Delete Order
  static Future<void> deleteOrder(String orderId) async {
    return await _order.doc(orderId).delete();
  }
}
