import '../models/product.dart';

class StockService {
  // Singleton
  static final StockService _instance = StockService._internal();
  factory StockService() => _instance;
  StockService._internal();

  // Mapa: product_id → stock
  final Map<int, int> _stockMap = {};

  /// Inicializa el stock por producto (debe llamarse una vez cuando se cargan los productos)
  void initializeStock(List<Product> products, {int defaultStock = 10}) {
    for (var product in products) {
      // Solo inicializa si no estaba antes
      _stockMap.putIfAbsent(product.id, () => defaultStock);
      product.stock = _stockMap[product.id]!;
    }
  }

  /// Obtiene el stock actual de un producto
  int getStock(Product product) {
    return _stockMap[product.id] ?? 0;
  }

  /// Reduce el stock al comprar una cantidad
  bool reduceStock(Product product, int quantity) {
    final currentStock = _stockMap[product.id] ?? 0;

    if (currentStock >= quantity) {
      _stockMap[product.id] = currentStock - quantity;
      product.stock = _stockMap[product.id]!;
      return true;
    }

    return false; // No hay suficiente stock
  }

  /// Restaura el stock (para pruebas o reinicio)
  void resetStock(Product product, int quantity) {
    _stockMap[product.id] = quantity;
    product.stock = quantity;
  }

  /// Reinicia todos los stocks (opcional)
  void clearAll() {
    _stockMap.clear();
  }
}
