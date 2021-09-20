import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monggo_pinarak/monggo_pinarak.dart';

class AddOrderConfirmation extends StatelessWidget {
  AddOrderConfirmation(
      {required this.selectedMenuDataList,
      required this.addOrder,
      required this.totalQty,
      required this.totalPayment,
      required this.tableNumberController,
      required this.nameController,
      required this.phoneNumberController,
      required this.emailController,
      required this.userRole,
      Key? key})
      : super(key: key);

  final List<MenuDataOrder?> selectedMenuDataList;
  final Function(
    String,
    double,
    int,
    String,
    String,
    String,
  ) addOrder;
  final TextEditingController tableNumberController;
  final TextEditingController nameController;
  final TextEditingController phoneNumberController;
  final TextEditingController emailController;
  final int totalQty;
  final double totalPayment;
  final UserEnum userRole;

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text(
        'Order Confirmation',
        style: TextStyle(
          color: CupertinoColors.activeBlue,
        ),
      ),
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          switch (userRole) {
            case UserEnum.Admin:
            case UserEnum.Waitress:
            case UserEnum.Cashier:
              if (tableNumberController.text.isNotEmpty &&
                  nameController.text.isNotEmpty &&
                  phoneNumberController.text.isNotEmpty &&
                  emailController.text.isNotEmpty) {
                Navigator.pop(context);
                addOrder(
                    tableNumberController.text,
                    totalPayment,
                    totalQty,
                    nameController.text,
                    phoneNumberController.text,
                    emailController.text);
              } else {
                CustomDialog.showDialogWithoutTittle(
                    'Please complete all form');
              }
              break;
            case UserEnum.Owner:
            case UserEnum.User:
              if (tableNumberController.text.isNotEmpty &&
                  phoneNumberController.text.isNotEmpty) {
                Navigator.pop(context);
                addOrder(
                    tableNumberController.text,
                    totalPayment,
                    totalQty,
                    nameController.text,
                    phoneNumberController.text,
                    emailController.text);
              } else {
                CustomDialog.showDialogWithoutTittle(
                    'Please complete all form');
              }
              break;
          }
        },
        child: Text(
          'Submit',
          style: TextStyle(
            color: CupertinoColors.activeBlue,
          ),
        ),
      ),
      actions: selectedMenuDataList.map((e) {
        return CupertinoActionSheetAction(
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: '${e?.name}',
                  style: TextStyle(
                    color: CupertinoColors.inactiveGray.darkColor,
                  ),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
              RichText(
                text: TextSpan(
                  text: '${e?.qty}x',
                  style: TextStyle(
                    color: CupertinoColors.inactiveGray.darkColor,
                  ),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ],
          ),
        );
      }).toList(),
      message: Container(
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom * 0.5),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Your Order',
              style: TextStyle(
                color: CupertinoColors.inactiveGray,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              text: TextSpan(
                  text: 'Total Quantity : ',
                  style: TextStyle(color: CupertinoColors.black, fontSize: 12),
                  children: [
                    TextSpan(
                      text: '$totalQty',
                      style: TextStyle(
                          color: CupertinoColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' item',
                      style: TextStyle(
                        color: CupertinoColors.black,
                        fontSize: 12,
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              height: 5,
            ),
            RichText(
              text: TextSpan(
                  text: 'Total Payment : IDR ',
                  style: TextStyle(color: CupertinoColors.black, fontSize: 12),
                  children: [
                    TextSpan(
                      text: '${MoneyFormatter.format(totalPayment)}',
                      style: TextStyle(
                          color: CupertinoColors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ]),
            ),
            SizedBox(
              height: 10,
            ),
            CupertinoTextField(
              controller: tableNumberController,
              keyboardType: TextInputType.phone,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: CupertinoColors.inactiveGray.darkColor,
                    width: 1,
                  )),
              placeholder: 'Table Number',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
              maxLength: 3,
            ),
            SizedBox(
              height: 10,
            ),
            CupertinoTextField(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: CupertinoColors.inactiveGray.darkColor,
                    width: 1,
                  )),
              placeholder: 'Phone Number',
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
                FilteringTextInputFormatter.deny(
                  RegExp(
                      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            if (userRole == UserEnum.Admin ||
                userRole == UserEnum.Waitress ||
                userRole == UserEnum.Cashier)
              adminField(),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget adminField() {
    return Column(
      children: [
        CupertinoTextField(
          controller: nameController,
          keyboardType: TextInputType.name,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: CupertinoColors.inactiveGray.darkColor,
                width: 1,
              )),
          placeholder: 'Name',
          inputFormatters: [
            FilteringTextInputFormatter.singleLineFormatter,
            LengthLimitingTextInputFormatter(25),
            FilteringTextInputFormatter.deny(
              RegExp(
                  r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        CupertinoTextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: CupertinoColors.inactiveGray.darkColor,
                width: 1,
              )),
          placeholder: 'Email',
          inputFormatters: [
            LengthLimitingTextInputFormatter(255),
            FilteringTextInputFormatter.deny(
              RegExp(
                  r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
            ),
          ],
        ),
      ],
    );
  }
}
