import 'package:flutter/material.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int balanceBalance = 0;

  @override
  Widget build(BuildContext context) {
    Widget _balance() {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
              color: ColorPalette.secondaryColorDark,
              borderRadius: BorderRadius.circular(25)),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(
                    2,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                      height: 16,
                      width: 4,
                      decoration: BoxDecoration(
                          color: (balanceBalance == index)
                              ? Colors.white
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.all(10),
                height: 115,
                width: 175,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "IndoPay",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Saldo masih kosong",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Klik buat isi",
                      style: TextStyle(
                        color: ColorPalette.secondaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 5),
              SizedBox(width: 10),
            ],
          ),
        ),
      );
    }

    return Container(
      child: Column(
        children: [
          SizedBox(height: 10),
          _balance(),
        ],
      ),
    );
  }
}
