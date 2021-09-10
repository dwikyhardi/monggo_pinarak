import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class CustomDialog {
  static Future<void> showDialogWithoutTittle(String message,
      {bool barrierDismissible = true}) {
    return showCupertinoDialog(
        context: navGK.currentState!.context,
        builder: (BuildContext buildContext) {
          return CupertinoAlertDialog(
            title: null,
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                child: Text('Close'),
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(buildContext);
                },
              ),
            ],
          );
        });
  }

  static showLoading() {
    return showDialog(
        context: navGK.currentState!.context,
        barrierDismissible: true,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            content: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoActivityIndicator(),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Please Wait...',
                  ),
                ],
              ),
            ),
          );
        });
  }
}
