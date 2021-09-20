import 'package:monggo_pinarak/monggo_pinarak.dart';

class ReportData {
  int? orderCount;
  int? menuCount;
  int? userCount;
  int? totalIncome;
  List<OrderData>? orderList;
  List<MenuData>? menuList;
  List<UserData>? userList;

  ReportData(
      {this.orderCount = 0,
      this.menuCount = 0,
      this.userCount = 0,
      this.totalIncome = 0,
      this.orderList = const <OrderData>[],
      this.menuList = const <MenuData>[],
      this.userList = const <UserData>[]});

  ReportData.fromJson(Map<String, dynamic> json) {
    orderCount = json['order_count'];
    menuCount = json['menu_count'];
    userCount = json['user_count'];
    totalIncome = json['total_income'];
    orderList = json['order_list'];
    menuList = json['menu_list'];
    userList = json['user_list'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_count'] = this.orderCount;
    data['menu_count'] = this.menuCount;
    data['user_count'] = this.userCount;
    data['total_income'] = this.totalIncome;
    data['order_list'] = this.orderList;
    data['menu_list'] = this.menuList;
    data['user_list'] = this.userList;
    return data;
  }
}
