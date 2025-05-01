class Product {
  final int id;
  final String name;
  final int price;
  final String imageUrl;
  final String description;
  final String category;
  int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.category,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String name = json['product_name'].toString().toLowerCase();
    String category;

    if (name.contains('zapatilla') || name.contains('pantalón') || name.contains('camisa')) {
      category = 'ropa';
    } else if (name.contains('elden ring') || name.contains('juego') || name.contains('ps') || name.contains('nintendo') || name.contains('movie')|| name.contains('skate') || name.contains('videito')) {
      category = 'entretenimiento';
    } else {
      category = 'otros';
    }

    return Product(
      id: json['product_id'],
      name: json['product_name'],
      price: json['product_price'],
      imageUrl: json['product_image'],
      description: json['product_state'] ?? '',
      category: category,
      stock: 5,
    );
  }
}
