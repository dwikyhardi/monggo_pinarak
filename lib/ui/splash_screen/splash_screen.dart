import 'package:flutter/material.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    setPassKey().then((_) {
      Future.delayed(Duration(seconds: 1),(){
        pushAndRemoveUntil(Dashboard());
        // pushAndRemoveUntil(NewDashboard());
      });
    });
  }

  Future setPassKey() async {
    await Encrypt().setPassKey();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.primaryColor,
      body: Container(
        child: Center(
          child: Image.asset('assets/icons/ic_logo.png', color: Colors.white,width: MediaQuery.of(context).size.width * 0.5,),
        ),
      ),
    );
  }
}
