import 'package:monggo_pinarak/monggo_pinarak.dart';

class OrderInteractor{
  static Future<List<OrderData>> getOrderList(UserEnum _userRole, String _userId,{ReportEnum reportType = ReportEnum.Daily}) async {
    return OrderViewModel.getOrderList(_userRole, _userId, reportType: reportType,);
  }

  static Future<List<MenuData>> getMenuList() async {
    return MenuViewModel.getMenuList();
  }

  static Future<OrderData> createNewOrder(OrderData orderData) async {
    return OrderViewModel.createNewOrder(orderData);
  }

  static Future<OrderData> updateOrder(OrderData? orderData, String? orderId) async {
    if(orderData != null && orderId != null){
      return OrderViewModel.updateOrder(orderData, orderId);
    }else{
      return Future.error('Order is not valid');
    }
  }
}