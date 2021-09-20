import 'package:flutter/material.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class PrimaryColorButton extends StatelessWidget {
  const PrimaryColorButton(
      {required this.onPressed,
      required this.textTitle,
      required this.size,
      Key? key})
      : super(key: key);
  final Function() onPressed;
  final String textTitle;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(textTitle,textAlign: TextAlign.center,),
      style: ElevatedButton.styleFrom(
          primary: ColorPalette.primaryColor,
          onPrimary: Colors.white,
          // fixedSize: size,
          minimumSize: size,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          )),
    );
  }
}
