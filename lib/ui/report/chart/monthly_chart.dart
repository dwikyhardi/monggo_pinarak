import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MonthlyChart{
  static LineChartData chart(List<FlSpot> chartData, List<String> dayList,
      List<Color> gradientColors){
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
            return dayList[value.toInt()];
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
      maxX: dayList.length.toDouble() - 1,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: chartData,
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