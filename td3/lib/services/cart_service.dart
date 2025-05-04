import '../models/cart_item.dart';
import '../models/product.dart';
import 'stock_service.dart';

class CartService {
  // Singleton
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
  }

  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
  }

  void clearCart() {
    _items.clear();
  }

  // Validar stock y realizar compra simulada
  List<String> purchase() {
    List<String> messages = [];
    final stockService = StockService();

    _items.removeWhere((item) {
      final product = item.product;
      final availableStock = stockService.getStock(product);

      if (item.quantity > availableStock) {
        messages.add('${product.name} sin stock suficiente.');
        return true; // eliminar del carrito
      } else {
        // Reducir stock mediante StockService
        stockService.reduceStock(product, item.quantity);
        return false;
      }
    });

    if (messages.isEmpty) {
      messages.add('¡Compra realizada con éxito! Correo enviado al cliente.');
      clearCart();
    }

    return messages;
  }
}
