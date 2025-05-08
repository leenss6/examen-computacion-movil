import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'stock_service.dart'; // ✅ Asegúrate de importar

class ProductService {
  final String _baseUrl = "http://143.198.118.203:8100";
  final String _user = "test";
  final String _pass = "test2023";

  Future<List<Product>> fetchProducts() async {
    try {
      // Codificar user:pass en base64
      String basicAuth = 'Basic ' + base64Encode(utf8.encode('$_user:$_pass'));

      final response = await http.get(
        Uri.parse('$_baseUrl/ejemplos/product_list_rest/'),
        headers: {
          'Authorization': basicAuth,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final List<Product> products = (data['Listado'] as List)
            .map((json) => Product.fromJson(json))
            .toList();

        // ✅ Inicializar stock local para cada producto
        StockService().initializeStock(products, defaultStock: 5);

        return products;
      } else {
        throw Exception('Error al cargar productos (Código: ${response.statusCode})');
      }
    } catch (e) {
      print('Error en fetchProducts: $e');
      return [];
    }
  }
}
