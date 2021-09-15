import 'dart:async';

import 'package:date_util/date_util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';
import 'package:monggo_pinarak/ui/ui_library.dart';

class Report extends StatefulWidget {
  final StreamController<DrawerItems?> _drawerChangeStream;
  final UserEnum _userRole;
  final String _userId;

  const Report(this._drawerChangeStream, this._userRole, this._userId,
      {Key? key})
      : super(key: key);

  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final StreamController<Map<String, dynamic>> _reportStream =
      StreamController();
  ReportEnum _reportType = ReportEnum.Daily;

  @override
  void dispose() {
    _reportStream.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getReport();
  }

  void _getReport() {
    ReportInteractor.getReport(widget._userRole, widget._userId,
            reportType: _reportType)
        .then((data) {
      _reportStream.sink.add(data);
    });
  }

  void _getReportOrderAndTransaction({
    required int menuCount,
    required int userCount,
    required List<MenuData> menuList,
    required List<UserData> userList,
  }) {
    ReportInteractor.getReportOrderAndTransaction(
            widget._userRole, widget._userId,
            reportType: _reportType,
            menuCount: menuCount,
            userCount: userCount,
            menuList: menuList,
            userList: userList)
        .then((data) {
      _reportStream.sink.add(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;
    return StreamBuilder<Map<String, dynamic>>(
        stream: _reportStream.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && (snapshot.data?.length ?? 0) > 0) {
              var data = snapshot.data?['dataCount'] as Map<String, dynamic>;
              var dataList = snapshot.data?['dataList'] as Map<String, dynamic>;
              var orderList = dataList['orderList'];
              return Container(
                width: devWidth,
                height: devHeight,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            _buildChart(orderList),
                            GridView(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 1.75),
                              shrinkWrap: true,
                              children: data.entries.map((e) {
                                return _reportWidget(devWidth, e);
                              }).toList(),
                              physics: NeverScrollableScrollPhysics(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 10.0,
                      right: 10.0,
                      child: ElevatedButton(
                        onPressed: () {
                          // 'dataCount': {
                          // 'orderCount': orderCount,
                          // 'menuCount': menuCount,
                          // 'userCount': userCount,
                          // },
                          // 'dataList': {
                          // 'orderList': orderList,
                          // 'menuList': menuList,
                          // 'userList': userList
                          // }
                          _changeFilter(
                              menuCount: data['menuCount'],
                              menuList: dataList['menuList'],
                              userCount: data['userCount'],
                              userList: dataList['userList']);
                        },
                        child: Text('Change Filter'),
                        style: ElevatedButton.styleFrom(
                            primary: ColorPalette.primaryColor,
                            onPrimary: Colors.white,
                            fixedSize: Size(MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.width * 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text('No Data'),
              );
            }
          } else {
            return Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Please Wait...'),
                ],
              ),
            );
          }
        });
  }

  void _changeFilter({
    required int menuCount,
    required int userCount,
    required List<MenuData> menuList,
    required List<UserData> userList,
  }) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext buildContext) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoDialogAction(
              child:
                  Text('${ReportEnum.Daily.toString().split('.').last} Report'),
              onPressed: () {
                if (_reportType != ReportEnum.Daily) {
                  setState(() {
                    _reportType = ReportEnum.Daily;
                  });
                  _getReportOrderAndTransaction(
                      menuCount: menuCount,
                      userCount: userCount,
                      menuList: menuList,
                      userList: userList);
                }
                Navigator.pop(buildContext);
              },
            ),
            CupertinoDialogAction(
              child: Text(
                  '${ReportEnum.Monthly.toString().split('.').last} Report'),
              onPressed: () {
                if (_reportType != ReportEnum.Monthly) {
                  setState(() {
                    _reportType = ReportEnum.Monthly;
                  });
                  _getReportOrderAndTransaction(
                      menuCount: menuCount,
                      userCount: userCount,
                      menuList: menuList,
                      userList: userList);
                }
                Navigator.pop(buildContext);
              },
            ),
            CupertinoDialogAction(
              child: Text(
                  '${ReportEnum.Annual.toString().split('.').last} Report'),
              onPressed: () {
                if (_reportType != ReportEnum.Annual) {
                  setState(() {
                    _reportType = ReportEnum.Annual;
                  });
                  _getReportOrderAndTransaction(
                      menuCount: menuCount,
                      userCount: userCount,
                      menuList: menuList,
                      userList: userList);
                }
                Navigator.pop(buildContext);
              },
            ),
          ],
          cancelButton: CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () {
              var date = DateUtil()
                  .daysInMonth(DateTime.now().month, DateTime.now().year);
              print('date =========== $date}');
              Navigator.pop(context);
            },
          ),
          title: Text('Choose Filter Order'),
        );
      },
    );
  }

  Widget _buildChart(orderList) {
    switch (_reportType) {
      case ReportEnum.Day:
      case ReportEnum.Daily:
        var thisDay = DateTime.now().weekday;
        List<String> _dayList = List.generate(listOfDay.length, (index) {
          if ((thisDay + index) < listOfDay.length) {
            return listOfDay[thisDay + index];
          } else {
            return listOfDay[((listOfDay.length - thisDay) - (index)).abs()];
          }
        });
        return Chart(
            _createChartDataDaily(orderList, _dayList), _reportType, _dayList);
      case ReportEnum.Monthly:
        List<String> _dayList = List.generate(
            DateUtil().daysInMonth(DateTime.now().month, DateTime.now().year) ??
                0, (index) {
          return '${index + 1}';
        });
        // print('Monthly day ===== ${jsonEncode(_dayList)}');
        return Chart(_createChartDataMonthly(orderList, _dayList), _reportType,
            _dayList);
      case ReportEnum.Annual:
        var thisMonth = DateTime.now().month;
        List<String> _dayList = List.generate(listOfMonth.length, (index) {
          if ((thisMonth + index) < listOfMonth.length) {
            return listOfMonth[thisMonth + index];
          } else {
            return listOfMonth[
                ((listOfMonth.length - thisMonth) - index).abs()];
          }
        });
        return Chart(
            _createChartDataAnnual(orderList, _dayList), _reportType, _dayList);
    }
  }

  Widget _reportWidget(double devWidth, MapEntry<String, dynamic> data) {
    var reportTitle = '';
    switch (data.key) {
      case 'orderCount':
        reportTitle = 'Total Order';
        break;
      case 'menuCount':
        reportTitle = 'Total Menu';
        break;
      case 'userCount':
        reportTitle = 'Total User';
        break;
    }
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: devWidth / 2,
          height: devWidth / 4,
          color: ColorPalette.secondaryColor,
          child: Stack(
            children: [
              Positioned(
                right: 0.0,
                child: CustomPaint(
                  painter: CircleShapePainter(
                    radius: 50,
                    color: ColorPalette.secondaryColorLight,
                  ),
                ),
              ),
              Positioned(
                right: devWidth * 0.05,
                top: devWidth * 0.2,
                child: CustomPaint(
                  painter: CircleShapePainter(
                    radius: 60,
                    color: ColorPalette.secondaryColorDark,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reportTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      data.value.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<FlSpot> _createChartDataDaily(
      List<OrderData> orderList, List<String> _dayList) {
    var chartSpot = <FlSpot>[];
    List<double> dayList = List.generate(listOfDay.length, (index) {
      return 0;
    });

    orderList.forEach((orderData) {
      var day =
          DateTime.fromMillisecondsSinceEpoch(orderData.dateTime ?? 0).weekday -
              1;
      // print('orderList Day ======= $day');
      var indexDay =
          _dayList.indexWhere((element) => element == listOfDay[day]);
      if (indexDay != -1) {
        dayList[indexDay]++;
      }
    });

    for (int i = 0; i < _dayList.length; i++) {
      chartSpot.add(FlSpot(i.toDouble(), dayList[i]));
    }

    return chartSpot;
  }

  List<FlSpot> _createChartDataMonthly(
      List<OrderData> orderList, List<String> _dayList) {
    var chartSpot = <FlSpot>[];
    List<double> dayList = List.generate(
        DateUtil().daysInMonth(DateTime.now().month, DateTime.now().year) ?? 0,
        (index) {
      return 0;
    });
    orderList.forEach((orderData) {
      var day =
          DateTime.fromMillisecondsSinceEpoch(orderData.dateTime ?? 0).day;

      // var indexDay =
      // _dayList.indexWhere((element) => element == listOfDay[day]);
      // if (indexDay != -1) {
      dayList[day]++;
      // }
    });

    for (int i = 0; i < _dayList.length; i++) {
      chartSpot.add(FlSpot(i.toDouble(), dayList[i]));
    }

    return chartSpot;
  }

  List<FlSpot> _createChartDataAnnual(
      List<OrderData> orderList, List<String> _dayList) {
    var chartSpot = <FlSpot>[];
    List<double> dayList = List.generate(listOfMonth.length, (index) {
      return 0;
    });

    // print('Year length _dayList ======== ${_dayList.length}');
    // print('Year length dayList ======== ${dayList.length}');

    orderList.forEach((orderData) {
      var day =
          DateTime.fromMillisecondsSinceEpoch(orderData.dateTime ?? 0).month -
              1;
      // print(
      //     'Month Value Annual ========= ${DateTime.fromMillisecondsSinceEpoch(orderData.dateTime ?? 0).month}');
      // print('Month Value Annual day ========= $day');
      var indexDay =
          _dayList.indexWhere((element) => element == listOfMonth[day]);
      if (indexDay != -1) {
        dayList[indexDay]++;
      }
    });

    for (int i = 0; i < _dayList.length; i++) {
      chartSpot.add(FlSpot(i.toDouble(), dayList[i]));
    }

    return chartSpot;
  }
}
