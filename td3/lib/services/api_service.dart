import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

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

        final List<dynamic> productList = data['Listado'];
        return productList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar productos (Código: ${response.statusCode})');
      }
    } catch (e) {
      print('Error en fetchProducts: $e');
      return [];
    }
  }
}
