import 'package:monggo_pinarak/monggo_pinarak.dart';

class ReportInteractor {
  static Future<ReportData> getReport(UserEnum _userRole, String _userId,
      {ReportEnum reportType = ReportEnum.Daily}) async {
    return ReportViewModel.getReportData(_userRole, _userId,
        reportType: reportType);
  }

  static Future<ReportData> getReportOrderAndTransaction(
    UserEnum _userRole,
    String _userId, {
    ReportEnum reportType = ReportEnum.Daily,
    required ReportData reportData,
  }) async {
    return ReportViewModel.getReportOrderAndTransaction(_userRole, _userId,
        reportType: reportType, reportData: reportData);
  }
}
