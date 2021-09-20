import 'package:monggo_pinarak/monggo_pinarak.dart';

class OrderData {
  late String? orderId;
  late int? dateTime;
  late String? customerId;
  late CustomerDetails? customer;
  late String? orderStatus;
  late List<MenuDataOrder?>? menu;
  late String? tableNumber;
  late PaymentData? payment;
  late int? totalPayment;
  late int? totalQty;

  OrderData({
    this.orderId,
    this.dateTime,
    this.customerId,
    this.customer,
    this.orderStatus,
    this.menu,
    this.tableNumber,
    this.payment,
    this.totalPayment,
    this.totalQty,
  });

  OrderData.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    dateTime = json['date_time'];
    customerId = json['customer_id'];
    customer = json['customer'] != null
        ? CustomerDetails.fromJson(json['customer'])
        : null;
    orderStatus = json['order_status'];
    if (json['menu'] != null) {
      menu = <MenuDataOrder>[];
      json['menu'].forEach((v) {
        menu?.add(MenuDataOrder.fromJson(v));
      });
    }
    tableNumber = json['table_number'];
    payment =
        json['payment'] != null ? PaymentData.fromJson(json['payment']) : null;
    totalPayment = json['total_payment'];
    totalQty = json['total_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['date_time'] = this.dateTime;
    data['customer_id'] = this.customerId;
    if (this.customer != null) {
      data['customer'] = this.customer?.toJson();
    }
    data['order_status'] = this.orderStatus;
    if (this.menu != null) {
      data['menu'] = this.menu?.map((v) => v?.toJson()).toList();
    }
    data['table_number'] = this.tableNumber;
    if (this.payment != null) {
      data['payment'] = this.payment?.toJson();
    }
    data['total_payment'] = this.totalPayment;
    data['total_quantity'] = this.totalQty;
    return data;
  }
}
