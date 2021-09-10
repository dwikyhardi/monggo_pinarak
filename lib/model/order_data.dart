import 'package:monggo_pinarak/model/menu_data_order.dart';

class OrderData {
  late int? dateTime;
  late String? customerId;
  late String? customerName;
  late String? orderStatus;
  late List<MenuDataOrder?>? menu;
  late String? tableNumber;

  OrderData(
      {this.dateTime,
      this.customerId,
      this.customerName,
      this.orderStatus,
      this.menu,
      this.tableNumber});

  OrderData.fromJson(Map<String, dynamic> json) {
    dateTime = json['date_time'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    orderStatus = json['order_status'];
    if (json['menu'] != null) {
      menu = <MenuDataOrder>[];
      json['menu'].forEach((v) {
        menu?.add(new MenuDataOrder.fromJson(v));
      });
    }
    tableNumber = json['table_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date_time'] = this.dateTime;
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['order_status'] = this.orderStatus;
    if(this.menu != null){
      data['menu'] = this.menu?.map((v) => v?.toJson()).toList();
    }
    data['table_number'] = this.tableNumber;
    return data;
  }
}
