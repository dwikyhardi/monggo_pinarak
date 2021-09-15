enum ReportEnum {
  Day,
  Daily,
  Monthly,
  Annual,
}

final Map<ReportEnum, String> getStringReportEnum = {
  ReportEnum.Day: 'Day',
  ReportEnum.Daily: 'Daily',
  ReportEnum.Monthly: 'Monthly',
  ReportEnum.Annual: 'Annual',
};

final Map<String, ReportEnum> getReportEnum = {
  'Day': ReportEnum.Day,
  'Daily': ReportEnum.Daily,
  'Monthly': ReportEnum.Monthly,
  'Annual': ReportEnum.Annual,
};
