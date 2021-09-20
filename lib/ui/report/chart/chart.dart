import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';
import 'package:monggo_pinarak/util/color_palette.dart';

final List<String> listOfDay = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

final listOfMonth = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

class Chart extends StatefulWidget {
  final List<FlSpot> chartData;
  final List<String> dayList;
  final ReportEnum reportType;

  Chart(this.chartData, this.reportType, this.dayList);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Color> gradientColors = [
    ColorPalette.secondaryColorDark,
    ColorPalette.secondaryColorLight,
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      child: Container(
        color: ColorPalette.chartBackground,
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: AspectRatio(
                aspectRatio: 1.70,
                child: Container(
                  padding: const EdgeInsets.only(
                      right: 30.0, left: 12.0, top: 24, bottom: 12),
                  child: LineChart(
                    _createChartMainData(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                '${widget.reportType.toString().split('.').last} Report Order',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _createChartMainData() {
    switch (widget.reportType) {
      case ReportEnum.Day:
      case ReportEnum.Daily:
        return DailyChart.chart(
            widget.chartData, widget.dayList, gradientColors);
      case ReportEnum.Monthly:
        return MonthlyChart.chart(
            widget.chartData, widget.dayList, gradientColors);
      case ReportEnum.Annual:
        return AnnualChart.chart(
            widget.chartData, widget.dayList, gradientColors);
      default:
        return LineChartData();
    }
  }
}
