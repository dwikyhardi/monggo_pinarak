import 'package:monggo_pinarak/monggo_pinarak.dart';

class PaymentData {
  late String? paymentMethod;
  late String? paymentStatus;
  late int? totalPayment;
  late List<Actions?>? actions;

  PaymentData(
      {this.paymentMethod,
      this.paymentStatus,
      this.totalPayment,
      this.actions});

  PaymentData.fromJson(Map<String, dynamic> json) {
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    totalPayment = json['total_payment'];
    if (json['actions'] != null) {
      actions = <Actions>[];
      json['actions'].forEach((v) {
        actions?.add(new Actions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_method'] = this.paymentMethod;
    data['payment_status'] = this.paymentStatus;
    data['total_payment'] = this.totalPayment;
    if (this.actions != null) {
      data['actions'] = this.actions?.map((v) => v?.toJson()).toList();
    }
    return data;
  }
}
