import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class MenuOrderListView extends StatelessWidget {
  final MenuData? menuData;
  final Function(MenuData?) onTapCard;
  final Widget Function(MenuData?) addMenuButton;

  const MenuOrderListView(
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
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    menuData?.name ?? '',
                    style: TextStyle(
                        color: ColorPalette.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: RichText(
                      text: TextSpan(
                        text: menuData?.description ?? '',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
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
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.width * 0.25,
                      fit: BoxFit.cover,
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
                  SizedBox(
                    height: 10,
                  ),
                  addMenuButton(menuData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
