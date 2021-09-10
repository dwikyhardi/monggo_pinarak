import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ColorPalette.primaryColor,
      statusBarBrightness: Brightness.dark
    ));
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild!.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Monggo Pinarak',
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: ColorPalette.getPrimarySwatch(),
          primaryColor: ColorPalette.primaryColor,
          primaryColorDark: ColorPalette.primaryColorDark,
          primaryColorLight: ColorPalette.primaryColorLight,
          accentColor: ColorPalette.secondaryColor,
          brightness: Brightness.light,
        ),
        navigatorKey: navGK,
        home: SplashScreen(),
      ),
    );
  }
}
