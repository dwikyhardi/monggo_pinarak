class EWalletPaymentResponse {
  late String? statusCode;
  late String? statusMessage;
  late String? transactionId;
  late String? orderId;
  late String? grossAmount;
  late String? paymentType;
  late String? transactionTime;
  late String? transactionStatus;
  late List<Actions?>? actions;
  late String? channelResponseCode;
  late String? channelResponseMessage;
  late String? currency;

  EWalletPaymentResponse(
      {this.statusCode,
      this.statusMessage,
      this.transactionId,
      this.orderId,
      this.grossAmount,
      this.paymentType,
      this.transactionTime,
      this.transactionStatus,
      this.actions,
      this.channelResponseCode,
      this.channelResponseMessage,
      this.currency});

  EWalletPaymentResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    transactionId = json['transaction_id'];
    orderId = json['order_id'];
    grossAmount = json['gross_amount'];
    paymentType = json['payment_type'];
    transactionTime = json['transaction_time'];
    transactionStatus = json['transaction_status'];
    if (json['actions'] != null) {
      actions = <Actions>[];
      json['actions'].forEach((v) {
        actions?.add(new Actions.fromJson(v));
      });
    }
    channelResponseCode = json['channel_response_code'];
    channelResponseMessage = json['channel_response_message'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['status_message'] = this.statusMessage;
    data['transaction_id'] = this.transactionId;
    data['order_id'] = this.orderId;
    data['gross_amount'] = this.grossAmount;
    data['payment_type'] = this.paymentType;
    data['transaction_time'] = this.transactionTime;
    data['transaction_status'] = this.transactionStatus;
    if (this.actions != null) {
      data['actions'] = this.actions?.map((v) => v?.toJson()).toList();
    }
    data['channel_response_code'] = this.channelResponseCode;
    data['channel_response_message'] = this.channelResponseMessage;
    data['currency'] = this.currency;
    return data;
  }
}

class Actions {
  late String? name;
  late String? method;
  late String? url;
  List<dynamic>? fields;

  Actions({this.name, this.method, this.url, this.fields});

  Actions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    method = json['method'];
    url = json['url'];
    if (json['fields'] != null) {
      fields = <dynamic>[];
      json['fields'].forEach((v) {
        fields?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['method'] = this.method;
    data['url'] = this.url;
    if (this.fields != null) {
      data['fields'] = this.fields?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
