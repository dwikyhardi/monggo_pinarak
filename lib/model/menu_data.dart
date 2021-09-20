class MenuData {
  late String? name;
  late String? description;
  late int? price;
  late String? imageUrl;
  late String? menuId;
  late bool? isActive;

  MenuData(
      {this.name,
       this.description,
       this.price,
       this.imageUrl,
      this.menuId,
      this.isActive});

  MenuData.fromJson(Map<String, dynamic> json, {String? menuId}) {
    name = json['name'];
    description = json['description'];
    price = json['price'];
    imageUrl = json['image_url'];
    isActive = json['is_active'];
    this.menuId = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['image_url'] = this.imageUrl;
    data['is_active'] = this.isActive;
    data['id'] = this.menuId;
    return data;
  }
}
