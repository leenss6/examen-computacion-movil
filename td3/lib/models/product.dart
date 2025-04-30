class Product {
  final int id;
  final String name;
  final int price;
  final String imageUrl;
  final String description; // usaremos `product_state` como descripción
  int stock; // será local

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.stock,
  });

  // Método para crear desde JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['product_id'],
      name: json['product_name'],
      price: json['product_price'],
      imageUrl: json['product_image'],
      description: json['product_state'] ?? '',
      stock: 10, // stock inventado localmente
    );
  }
}
