import 'package:monggo_pinarak/monggo_pinarak.dart';

class MenuDataOrder implements MenuData {
  @override
  String? description;

  @override
  String? imageUrl;

  @override
  String? menuId;

  @override
  String? name;

  @override
  int? price;

  int? qty;

  @override
  bool? isActive;

  MenuDataOrder(
      {this.description,
      this.imageUrl,
      this.menuId,
      this.name,
      this.price,
      this.qty});

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['image_url'] = this.imageUrl;
    data['id'] = this.menuId;
    data['qty'] = this.qty;
    return data;
  }

  MenuDataOrder.fromJson(Map<String, dynamic> json) {
    menuId = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    imageUrl = json['image_url'];
    qty = json['qty'];
  }
}
