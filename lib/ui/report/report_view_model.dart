import 'package:monggo_pinarak/monggo_pinarak.dart';
import 'package:monggo_pinarak/ui/ui_library.dart';

class ReportViewModel {
  static Future<Map<String, dynamic>> getReportData(
      UserEnum _userRole, String _userId,
      {ReportEnum reportType = ReportEnum.Daily}) async {
    var orderCount = 0;
    var menuCount = 0;
    var userCount = 0;
    var orderList = <OrderData>[];
    var menuList = <MenuData>[];
    var userList = <UserData>[];
    await OrderInteractor.getOrderList(_userRole, _userId,
            reportType: reportType)
        .then((order) async {
      orderCount = order.length;
      orderList = order;
      await MenuInteractor.getMenuList().then((menu) async {
        menuCount = menu.length;
        menuList = menu;
        await LoginInteractor.getUserList().then((user) async {
          userCount = user.length;
          userList = user;
        });
      });
    });

    return {
      'dataCount': {
        'orderCount': orderCount,
        'menuCount': menuCount,
        'userCount': userCount,
      },
      'dataList': {
        'orderList': orderList,
        'menuList': menuList,
        'userList': userList
      }
    };
  }

  static Future<Map<String, dynamic>> getReportOrderAndTransaction(
    UserEnum _userRole,
    String _userId, {
    ReportEnum reportType = ReportEnum.Daily,
    required int menuCount,
    required int userCount,
    required List<MenuData> menuList,
    required List<UserData> userList,
  }) async {
    var orderCount = 0;
    var orderList = <OrderData>[];
    await OrderInteractor.getOrderList(_userRole, _userId,
            reportType: reportType)
        .then((order) async {
      orderCount = order.length;
      orderList = order;
    });

    return {
      'dataCount': {
        'orderCount': orderCount,
        'menuCount': menuCount,
        'userCount': userCount,
      },
      'dataList': {
        'orderList': orderList,
        'menuList': menuList,
        'userList': userList
      }
    };
  }
}
