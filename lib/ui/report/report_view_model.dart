import 'package:monggo_pinarak/monggo_pinarak.dart';
import 'package:monggo_pinarak/ui/ui_library.dart';

class ReportViewModel {
  static Future<ReportData> getReportData(UserEnum _userRole, String _userId,
      {ReportEnum reportType = ReportEnum.Daily}) async {
    var orderCount = 0;
    var menuCount = 0;
    var userCount = 0;
    var orderList = <OrderData>[];
    var menuList = <MenuData>[];
    var userList = <UserData>[];
    var totalIncome = 0;
    await OrderInteractor.getOrderList(_userRole, _userId,
            reportType: reportType)
        .then((order) async {
      orderCount = order.length;
      orderList = order;
      orderList.forEach((element) {
        totalIncome = totalIncome + (element.totalPayment ?? 0);
      });
      await MenuInteractor.getMenuList().then((menu) async {
        menuCount = menu.length;
        menuList = menu;
        await LoginInteractor.getUserList().then((user) async {
          userCount = user.length;
          userList = user;
        });
      });
    });

    return ReportData(
        userList: userList,
        orderCount: orderCount,
        userCount: userCount,
        menuList: menuList,
        menuCount: menuCount,
        orderList: orderList,
        totalIncome: totalIncome);
  }

  static Future<ReportData> getReportOrderAndTransaction(
    UserEnum _userRole,
    String _userId, {
    ReportEnum reportType = ReportEnum.Daily,
    required ReportData reportData,
  }) async {
    var orderCount = 0;
    var orderList = <OrderData>[];
    var totalIncome = 0;
    await OrderInteractor.getOrderList(_userRole, _userId,
            reportType: reportType)
        .then((order) async {
      orderCount = order.length;
      orderList = order;
      orderList.forEach((element) {
        totalIncome = totalIncome + (element.totalPayment ?? 0);
      });
    });

    return ReportData(
      orderList: orderList,
      orderCount: orderCount,
      totalIncome: totalIncome,
      menuCount: reportData.menuCount,
      menuList: reportData.menuList,
      userCount: reportData.userCount,
      userList: reportData.userList,
    );
  }
}
