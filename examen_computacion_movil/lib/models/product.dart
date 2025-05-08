class ProductModel {
  final int id;
  final String name;
  final double price;
  final String image;
  final String state;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.state,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['product_id'],
      name: json['product_name'],
      price: (json['product_price'] as num).toDouble(),
      image: json['product_image'],
      state: json['product_state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': id,
      'product_name': name,
      'product_price': price,
      'product_image': image,
      'product_state': state,
    };
  }
}