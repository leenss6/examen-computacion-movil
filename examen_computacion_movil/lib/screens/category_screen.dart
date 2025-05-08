import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CategoryService _service = CategoryService();
  late Future<List<CategoryModel>> _categories;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    setState(() {
      _categories = _service.fetchCategories();
    });
  }

  void _showCategoryForm({CategoryModel? category}) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final stateController = TextEditingController(text: category?.state ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(category == null ? 'Agregar Categoría' : 'Editar Categoría'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nombre')),
              TextField(controller: stateController, decoration: InputDecoration(labelText: 'Estado')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final nuevaCategoria = CategoryModel(
                id: category?.id ?? 0,
                name: nameController.text,
                state: stateController.text,
              );

              if (category == null) {
                await _service.createCategory(nuevaCategoria);
              } else {
                await _service.editCategory(nuevaCategoria);
              }

              _loadCategories();
              Navigator.pop(context);
            },
            child: Text(category == null ? 'Agregar' : 'Guardar'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(CategoryModel category) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Eliminar Categoría'),
        content: Text('¿Estás seguro de eliminar "${category.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              await _service.deleteCategory(category.id);
              _loadCategories();
              Navigator.pop(context);
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categorías')),
      body: FutureBuilder<List<CategoryModel>>(
        future: _categories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar categorías'));
          }
          final data = snapshot.data!;
          if (data.isEmpty) {
            return Center(child: Text('No hay categorías'));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final category = data[index];
              return ListTile(
                title: Text(category.name),
                subtitle: Text('Estado: ${category.state}'),
                onTap: () => _showCategoryForm(category: category),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(category),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
