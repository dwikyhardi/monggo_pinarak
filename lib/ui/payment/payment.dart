import 'package:flutter/material.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: ColorPalette.primaryColor,
        title: Text('Payment'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 1.3),
          children: PaymentMethod.values.map((e) {
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    print('Payment PaymentMethod ======== ${e.toString()}');
                    Navigator.pop(context, e);
                  },
                  child: Stack(
                    children: [
                      Positioned(
                        right: devWidth * 0.0,
                        top: devWidth * 0.3,
                        child: CustomPaint(
                          painter: CircleShapePainter(
                            radius: 80,
                            color: ColorPalette.secondaryColorDark,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0.0,
                        left: 0.0,
                        bottom: 0.0,
                        top: 0.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _getImagePaymentMethod(e),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _getImagePaymentMethod(PaymentMethod paymentMethod) {
    var assets = 'assets/icons/';
    switch (paymentMethod) {
      case PaymentMethod.Gopay:
        assets = '$assets/ic_gopay.png';
        break;
      case PaymentMethod.ShopeePay:
        assets = '$assets/ic_shopeepay.png';
        break;
      // case PaymentMethod.QRIS:
      //   assets = '$assets/ic_qris.png';
      //   break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          assets,
          fit: BoxFit.contain,
          width: MediaQuery.of(context).size.width * 0.3,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              getStringPaymentMethod[paymentMethod] ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}

enum PaymentMethod {
  Gopay,
  ShopeePay,
  // QRIS,
}

final Map<PaymentMethod, String> getStringPaymentMethod = {
  PaymentMethod.Gopay: 'Gopay',
  PaymentMethod.ShopeePay: 'ShopeePay',
  // PaymentMethod.QRIS: 'QRIS',
};

final Map<String, PaymentMethod> getPaymentMethod = {
  'Gopay': PaymentMethod.Gopay,
  'gopay': PaymentMethod.Gopay,
  'ShopeePay': PaymentMethod.ShopeePay,
  'shopeepay': PaymentMethod.ShopeePay,
  // 'QRIS': PaymentMethod.QRIS,
};
