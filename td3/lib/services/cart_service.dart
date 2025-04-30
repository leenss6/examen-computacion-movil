import '../models/cart_item.dart';
import '../models/product.dart';

class CartService {
  //Singleton
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      // Ya existe en el carrito, aumenta cantidad
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

    _items.removeWhere((item) {
      if (item.quantity > item.product.stock) {
        messages.add('${item.product.name} sin stock suficiente.');
        return true; // eliminar del carrito
      } else {
        // Reducir stock disponible
        item.product.stock -= item.quantity;
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
