class EWalletPaymentRequest {
  late String? paymentType;
  late TransactionDetails? transactionDetails;
  late List<ItemDetails?>? itemDetails;
  late CustomerDetails? customerDetails;
  late Gopay? gopay;
  late Shopeepay? shopeepay;
  late QRIS? qris;

  EWalletPaymentRequest(
      {this.paymentType,
      this.transactionDetails,
      this.itemDetails,
      this.customerDetails,
      this.gopay,
      this.shopeepay,
      this.qris});

  EWalletPaymentRequest.fromJson(Map<String, dynamic> json) {
    paymentType = json['payment_type'];
    transactionDetails = json['transaction_details'] != null
        ? new TransactionDetails.fromJson(json['transaction_details'])
        : null;
    if (json['item_details'] != null) {
      itemDetails = <ItemDetails>[];
      json['item_details'].forEach((v) {
        itemDetails?.add(new ItemDetails.fromJson(v));
      });
    }
    customerDetails = json['customer_details'] != null
        ? new CustomerDetails.fromJson(json['customer_details'])
        : null;

    if (json['gopay'] != null) {
      gopay = new Gopay.fromJson(json['gopay']);
    } else if (json['shopeepay'] != null) {
      shopeepay = new Shopeepay.fromJson(json['shopeepay']);
    } else if (json['qris']) {
      qris = new QRIS.fromJson(json['qris']);
    } else {
      gopay = null;
      shopeepay = null;
      qris = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_type'] = this.paymentType;
    if (this.transactionDetails != null) {
      data['transaction_details'] = this.transactionDetails?.toJson();
    }
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails?.map((v) => v?.toJson()).toList();
    }
    if (this.customerDetails != null) {
      data['customer_details'] = this.customerDetails?.toJson();
    }
    if (this.gopay != null) {
      data['gopay'] = this.gopay?.toJson();
    } else if (this.shopeepay != null) {
      data['shopeepay'] = this.shopeepay?.toJson();
    } else if (this.qris != null) {
      data['qris'] = this.qris?.toJson();
    }
    return data;
  }
}

class TransactionDetails {
  late String? orderId;
  late int? grossAmount;

  TransactionDetails({this.orderId, this.grossAmount});

  TransactionDetails.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    grossAmount = json['gross_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['gross_amount'] = this.grossAmount;
    return data;
  }
}

class ItemDetails {
  late String? id;
  late int? price;
  late int? quantity;
  late String? name;

  ItemDetails({this.id, this.price, this.quantity, this.name});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    quantity = json['quantity'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['name'] = this.name;
    return data;
  }
}

class CustomerDetails {
  late String? firstName;
  late String? lastName;
  late String? email;
  late String? phone;

  CustomerDetails({this.firstName, this.lastName, this.email, this.phone});

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}

class Gopay {
  late bool? enableCallback;
  late String? callbackUrl;

  Gopay({this.enableCallback, this.callbackUrl});

  Gopay.fromJson(Map<String, dynamic> json) {
    enableCallback = json['enable_callback'];
    callbackUrl = json['callback_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['enable_callback'] = this.enableCallback;
    data['callback_url'] = this.callbackUrl;
    return data;
  }
}

class Shopeepay {
  late String? callbackUrl;

  Shopeepay({this.callbackUrl});

  Shopeepay.fromJson(Map<String, dynamic> json) {
    callbackUrl = json['callback_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['callback_url'] = this.callbackUrl;
    return data;
  }
}

class QRIS {
  late String? acquirer;

  QRIS({this.acquirer});

  QRIS.fromJson(Map<String, dynamic> json) {
    acquirer = json['acquirer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['acquirer'] = this.acquirer;
    return data;
  }
}

/// Usage Example
///
///{
///     "payment_type": "gopay",
///     "transaction_details": {
///         "order_id": "order03",
///         "gross_amount": 275000
///     },
///     "item_details": [
///         {
///             "id": "id1",
///             "price": 275000,
///             "quantity": 1,
///             "name": "Bluedio H+ Turbine Headphone with Bluetooth 4.1 -"
///         }
///    ],
///    "customer_details": {
///        "first_name": "Budi",
///        "last_name": "Utomo",
///        "email": "budi.utomo@midtrans.com",
///        "phone": "081223323423"
///    },
///    "gopay": {
///        "enable_callback": true,
///        "callback_url": "someapps://callback"
///    }
///}
