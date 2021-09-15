import 'package:monggo_pinarak/monggo_pinarak.dart';

class ReportInteractor {
  static Future<Map<String, dynamic>> getReport(
      UserEnum _userRole, String _userId,
      {ReportEnum reportType = ReportEnum.Daily}) async {
    return ReportViewModel.getReportData(_userRole,_userId,reportType: reportType);
  }

  static Future<Map<String, dynamic>> getReportOrderAndTransaction(UserEnum _userRole, String _userId,{
    ReportEnum reportType = ReportEnum.Daily,
    required int menuCount,
    required int userCount,
    required List<MenuData> menuList,
    required List<UserData> userList,
  }) async {
    return ReportViewModel.getReportOrderAndTransaction(
      _userRole,_userId,
        reportType: reportType,
        menuCount: menuCount,
        userCount: userCount,
        menuList: menuList,
        userList: userList);
  }
}
