class MenuData {
  late String? name;
  late String? description;
  late int? price;
  late String? imageUrl;
  late String? menuId;

  MenuData(
      {this.name,
       this.description,
       this.price,
       this.imageUrl,
      this.menuId});

  MenuData.fromJson(Map<String, dynamic> json, {String? menuId}) {
    name = json['name'];
    description = json['description'];
    price = json['price'];
    imageUrl = json['image_url'];
    if(menuId != null) this.menuId = menuId;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
