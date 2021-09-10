import 'package:monggo_pinarak/monggo_pinarak.dart';

class OrderInteractor{
  static Future<List<OrderData>> getOrderList() async {
    return OrderViewModel.getOrderList();
  }

  static Future<List<MenuData>> getMenuList() async {
    return MenuViewModel.getMenuList();
  }

  static Future<OrderData> createNewOrder(OrderData orderData) async {
    return OrderViewModel.createNewOrder(orderData);
  }

}