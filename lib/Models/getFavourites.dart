class Favourite {
  int? id;
  int? user_id;
  String? product_id;
  double? product_price;
  String? product_name;
  String? product_unit;
  String? product_image;

  Favourite(
      {this.id,
      required this.user_id,
      required this.product_id,
      required this.product_price,
      required this.product_name,
      required this.product_unit,
      required this.product_image});

  Favourite.fromMap(Map<dynamic, dynamic> res) {
    id = res['id'];
    user_id = res['user_id'];
    product_id = res['product_id'];
    product_price = res['product_price'];
    product_name = res['product_name'];
    product_unit = res['product_unit'];
    product_image = res['product_image'];
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'user_id': user_id,
      'product_id': product_id,
      'product_price': product_price,
      'product_name': product_name,
      'product_unit': product_unit,
      'product_image': product_image
    };
  }
}
