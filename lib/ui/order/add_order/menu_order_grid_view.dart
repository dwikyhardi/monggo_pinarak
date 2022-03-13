import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class MenuOrderGridView extends StatelessWidget {
  final MenuData? menuData;
  final Function(MenuData?) onTapCard;
  final Widget Function(MenuData?) addMenuButton;

  const MenuOrderGridView(
      {required this.menuData,
      required this.onTapCard,
      required this.addMenuButton,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 2.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          onTapCard(menuData);
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: CachedNetworkImage(
                imageUrl: menuData?.imageUrl ?? '',
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    menuData?.name ?? '',
                    style: TextStyle(
                      color: ColorPalette.primaryColor,
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
                ],
              ),
            ),
            Center(child: addMenuButton(menuData)),
          ],
        ),
      ),
    );
  }
}
