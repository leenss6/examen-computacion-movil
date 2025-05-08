import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductService _service = ProductService();
  late Future<List<ProductModel>> _products;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      _products = _service.fetchProducts();
    });
  }

  void _showProductForm({ProductModel? product}) {
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController = TextEditingController(text: product?.price.toString() ?? '');
    final imageController = TextEditingController(text: product?.image ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(product == null ? 'Agregar Producto' : 'Editar Producto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nombre')),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Precio'),
            ),
            TextField(controller: imageController, decoration: InputDecoration(labelText: 'URL Imagen')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final nuevoProducto = ProductModel(
                id: product?.id ?? 0,
                name: nameController.text,
                price: double.tryParse(priceController.text) ?? 0.0, // <- CORREGIDO AQUÍ
                image: imageController.text,
                state: 'Activo',
              );

              if (product == null) {
                await _service.createProduct(nuevoProducto);
              } else {
                await _service.editProduct(nuevoProducto);
              }

              _loadProducts();
              Navigator.pop(context);
            },
            child: Text(product == null ? 'Agregar' : 'Guardar'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(ProductModel product) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Eliminar Producto'),
        content: Text('¿Eliminar "${product.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              await _service.deleteProduct(product.id);
              _loadProducts();
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
      appBar: AppBar(title: Text('Productos')),
      body: FutureBuilder<List<ProductModel>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error al cargar productos'));
          final data = snapshot.data!;
          if (data.isEmpty) return Center(child: Text('No hay productos'));

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final product = data[index];
              return ListTile(
                leading: Image.network(
                  product.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported),
                ),
                title: Text(product.name),
                subtitle: Text('\$${product.price.toStringAsFixed(0)}'),
                onTap: () => _showProductForm(product: product),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(product),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}