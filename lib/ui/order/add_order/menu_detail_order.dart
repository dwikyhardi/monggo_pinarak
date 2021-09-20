import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class MenuDetailOrder extends StatelessWidget {
  final MenuData? menuData;
  final Widget Function(MenuData?, {bool isFromDetail}) addMenuButton;

  const MenuDetailOrder(
      {required this.menuData, required this.addMenuButton, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            child: CachedNetworkImage(
              imageUrl: menuData?.imageUrl ?? '',
              fit: BoxFit.cover,
              placeholder: (b, s) {
                return CupertinoActivityIndicator();
              },
              errorWidget: (b, s, _) {
                return Image.asset('assets/icons/ic_logo.png');
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
                    Text(
                      menuData?.name ?? '',
                      style: TextStyle(
                          color: ColorPalette.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    RichText(
                      text: TextSpan(
                        text: menuData?.description ?? '',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                    ),
                    SizedBox(
                      height: 5,
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
                      height: 10,
                    ),
                  ],
                ),
                addMenuButton(menuData, isFromDetail: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
