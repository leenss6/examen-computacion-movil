import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import 'api_constants.dart'; // usa tu ApiConstants actual

class CategoryService {
  Future<List<CategoryModel>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}category_list_rest/'),
      headers: ApiConstants.headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> list = data["Listado Categorias"];
      return list.map((json) => CategoryModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar categorías');
    }
  }

  Future<void> deleteCategory(int id) async {
    await http.post(
      Uri.parse('${ApiConstants.baseUrl}category_del_rest/'),
      headers: ApiConstants.headers,
      body: json.encode({'category_id': id}),
    );
  }

  Future<void> editCategory(CategoryModel category) async {
    await http.post(
      Uri.parse('${ApiConstants.baseUrl}category_edit_rest/'),
      headers: ApiConstants.headers,
      body: json.encode(category.toJson()),
    );
  }

  Future<void> createCategory(CategoryModel category) async {
    await http.post(
      Uri.parse('${ApiConstants.baseUrl}category_add_rest/'),
      headers: ApiConstants.headers,
      body: json.encode({
        'category_name': category.name,
        'category_state': category.state,
      }),
    );
  }
}
