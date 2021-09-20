import 'package:monggo_pinarak/monggo_pinarak.dart';

class OrderInteractor {
  static Future<List<OrderData>> getOrderList(
      UserEnum _userRole, String _userId,
      {ReportEnum reportType = ReportEnum.Daily}) async {
    return OrderViewModel.getOrderList(
      _userRole,
      _userId,
      reportType: reportType,
    );
  }

  static Future<List<MenuData>> getMenuList() async {
    return MenuViewModel.getMenuList(true);
  }

  static Future<OrderData> createNewOrder(
    OrderData orderData,
    PaymentMethod paymentMethod,
    UserData? userData,
    String phoneNumber,
  ) async {
    var customerName = userData?.name.split(" ");
    CustomerDetails customerDetails = CustomerDetails(
      phone: phoneNumber,
      email: userData?.email,
      firstName: customerName?.first,
      lastName: userData?.name.replaceFirst('${customerName?.first} ', ''),
    );
    orderData.customer = customerDetails;
    return OrderViewModel.createNewOrder(
      orderData,
      paymentMethod,
    );
  }

  static Future<OrderData> createNewOrderAdmin(
    OrderData orderData,
    PaymentMethod paymentMethod,
    String custName,
    String phoneNumber,
    String email,
  ) async {
    var customerName = custName.split(" ");
    CustomerDetails customerDetails = CustomerDetails(
      phone: phoneNumber,
      email: email,
      firstName: customerName.first,
      lastName: custName.replaceFirst('${customerName.first} ', ''),
    );
    orderData.customer = customerDetails;

    return OrderViewModel.createNewOrderAdmin(
      orderData,
      paymentMethod,
    );
  }

  static Future<OrderData> updateOrder(
      OrderData? orderData, bool isCancel) async {
    if (orderData != null) {
      if (isCancel) {
        orderData.orderStatus = getStringOrderEnum[OrderEnum.Cancel];
      } else {
        var orderStatus = orderData.orderStatus ?? '';
        switch (getOrderEnum[orderStatus]) {
          case OrderEnum.WaitingPayment:
            orderData.orderStatus =
                getStringOrderEnum[OrderEnum.WaitingConfirmation];
            break;
          case OrderEnum.WaitingConfirmation:
            orderData.orderStatus = getStringOrderEnum[OrderEnum.Process];
            break;
          case OrderEnum.Process:
          case OrderEnum.Finish:
            orderData.orderStatus = getStringOrderEnum[OrderEnum.Finish];
            break;
          default:
            orderData.orderStatus =
                getStringOrderEnum[OrderEnum.WaitingPayment];
        }
      }
      return OrderViewModel.updateOrder(orderData);
    } else {
      return Future.error('Order is not valid');
    }
  }

  static Future<OrderData> rechargeOrder(
      OrderData orderData, PaymentMethod? paymentMethod) async {
    if (paymentMethod != null) {
      return OrderViewModel.rechargeOrder(orderData, paymentMethod);
    } else {
      return Future.error('Payment Method is not valid');
    }
  }

  static Future<void> deleteOrder(String? orderId) async {
    if (orderId != null) {
      return OrderViewModel.deleteOrder(orderId);
    } else {
      return Future.error('Order is not valid');
    }
  }

  static Future<Map<String, dynamic>> getOrderStatus(String orderId) async {
    CustomDialog.showLoading();
    return await DioService.setupDio().then((dio) async {
      return await DioClient(dio).getOrderStatus(orderId);
    });
  }
}
