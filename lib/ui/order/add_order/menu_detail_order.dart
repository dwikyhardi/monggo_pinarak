import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class MenuDetailOrder extends StatelessWidget {
  final MenuData? menuData;
  final bool isAddedToCart;
  final Widget Function(MenuData?, {bool isFromDetail}) addMenuButton;

  const MenuDetailOrder(
      {required this.menuData, required this.addMenuButton,required this.isAddedToCart , Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              child: CachedNetworkImage(
                imageUrl: menuData?.imageUrl ?? '',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                placeholder: (b, s) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Center(child: CupertinoActivityIndicator()),
                  );
                },
                errorWidget: (b, s, _) {
                  return Center(
                    child: Image.asset(
                      'assets/icons/ic_logo.png',
                      width: MediaQuery.of(context).size.width / 4,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              menuData?.name ?? '',
                              style: TextStyle(
                                  color: ColorPalette.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            if(!isAddedToCart) addMenuButton(menuData, isFromDetail: true),
                          ],
                        ),
                      ),
                      Text(
                        'IDR ${MoneyFormatter.format(
                          double.tryParse(menuData?.price.toString() ?? '0'),
                        )}',
                        style: TextStyle(
                          color: ColorPalette.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: RichText(
                          text: TextSpan(
                            text: menuData?.description ?? '',
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
