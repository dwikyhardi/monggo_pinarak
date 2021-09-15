import 'dart:convert';

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
        return dailyData();
      case ReportEnum.Monthly:
        return monthlyData();
      case ReportEnum.Annual:
        return annualData();
      default:
        return LineChartData();
    }
  }

  LineChartData dailyData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
              color: CupertinoColors.inactiveGray,
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            return widget.dayList[value.toInt()];
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: CupertinoColors.inactiveGray,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              // case 1:
              //   return '1';
              // case 2:
              //   return '2';
              // case 3:
              //   return '3';
              // case 4:
              //   return '4';
              case 5:
                return '5';
              case 10:
                return '10';
              case 15:
                return '15';
              case 20:
                return '20';
              case 25:
                return '25';
              // case 30:
              //   return '30';
              // case 35:
              //   return '35';
              // case 40:
              //   return '40';
              // case 45:
              //   return '45';
              case 50:
                return '50';
              // case 55:
              //   return '55';
              // case 60:
              //   return '60';
              // case 65:
              //   return '65';
              // case 70:
              //   return '70';
              case 75:
                return '75';
              // case 80:
              //   return '80';
              // case 85:
              //   return '85';
              // case 90:
              //   return '90';
              // case 95:
              //   return '95';
              case 100:
                return '100';
              case 150:
                return '150';
              // case 200:
              //   return '200';
              // case 300:
              //   return '100';
              // case 400:
              //   return '400';
            }
            return '';
          },
          reservedSize: 32,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: widget.dayList.length.toDouble() - 1,
      minY: 0,
      maxY: 25,
      lineBarsData: [
        LineChartBarData(
          spots: widget.chartData,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
        // LineChartBarData(
        //   spots: [
        //     FlSpot(0, 5),
        //     FlSpot(1, 10),
        //     FlSpot(2, 15),
        //     FlSpot(3, 12),
        //     FlSpot(4, 10),
        //     FlSpot(5, 6),
        //     FlSpot(6, 18),
        //   ],
        //   isCurved: true,
        //   colors: [
        //     Colors.green,
        //     Colors.lightGreen,
        //   ],
        //   barWidth: 5,
        //   isStrokeCapRound: true,
        //   dotData: FlDotData(
        //     show: true,
        //   ),
        //   belowBarData: BarAreaData(
        //     show: true,
        //     colors:
        //         gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        //   ),
        // ),
      ],
    );
  }

  LineChartData monthlyData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
              color: CupertinoColors.inactiveGray,
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            return widget.dayList[value.toInt()];
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: CupertinoColors.inactiveGray,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              // case 1:
              //   return '1';
              // case 2:
              //   return '2';
              // case 3:
              //   return '3';
              // case 4:
              //   return '4';
              // case 5:
              //   return '5';
              case 10:
                return '10';
              // case 15:
              //   return '15';
              case 20:
                return '20';
              // case 25:
              //   return '25';
              case 30:
                return '30';
              // case 35:
              //   return '35';
              case 40:
                return '40';
              // case 45:
              //   return '45';
              case 50:
                return '50';
              // case 55:
              //   return '55';
              // case 60:
              //   return '60';
              // case 65:
              //   return '65';
              // case 70:
              //   return '70';
              case 75:
                return '75';
              // case 80:
              //   return '80';
              // case 85:
              //   return '85';
              // case 90:
              //   return '90';
              // case 95:
              //   return '95';
              case 100:
                return '100';
              case 150:
                return '150';
              // case 200:
              //   return '200';
              // case 300:
              //   return '100';
              // case 400:
              //   return '400';
            }
            return '';
          },
          reservedSize: 32,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: widget.dayList.length.toDouble() - 1,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: widget.chartData,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData annualData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
              color: CupertinoColors.inactiveGray,
              fontWeight: FontWeight.bold,
              fontSize: 16),
          getTitles: (value) {
            // print('value annual ===== $value');
            return widget.dayList[value.toInt()];
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: CupertinoColors.inactiveGray,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              // case 1:
              //   return '1';
              // case 2:
              //   return '2';
              // case 3:
              //   return '3';
              // case 4:
              //   return '4';
              // case 5:
              //   return '5';
              // case 10:
              //   return '10';
              // case 15:
              //   return '15';
              // case 20:
              //   return '20';
              // case 25:
              //   return '25';
              // case 30:
              //   return '30';
              // case 35:
              //   return '35';
              // case 40:
              //   return '40';
              // case 45:
              //   return '45';
              case 50:
                return '50';
              // case 55:
              //   return '55';
              // case 60:
              //   return '60';
              // case 65:
              //   return '65';
              // case 70:
              //   return '70';
              // case 75:
              //   return '75';
              // case 80:
              //   return '80';
              // case 85:
              //   return '85';
              // case 90:
              //   return '90';
              // case 95:
              //   return '95';
              case 100:
                return '100';
              case 150:
                return '150';
              case 200:
                return '200';
              case 300:
                return '300';
              case 400:
                return '400';
              case 500:
                return '500';
            }
            return '';
          },
          reservedSize: 32,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: widget.dayList.length.toDouble() - 1,
      minY: 0,
      maxY: 500,
      lineBarsData: [
        LineChartBarData(
          spots: widget.chartData,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
