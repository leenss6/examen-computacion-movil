import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/cart_service.dart';


class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Center(
              child: Image.network(
                product.imageUrl,
                width: 250,
                height: 250,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.image_not_supported, size: 100);
                },
              ),
            ),
            SizedBox(height: 24),

            // Nombre del producto
            Text(
              product.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            // Precio
            Text(
              '\$${product.price}',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(height: 12),

            // Descripción
            Text(
              'Descripción: ${product.description}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),

            // Stock disponible
            Text(
              'Stock disponible: ${product.stock}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),

            // Botón de agregar al carrito
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  CartService().addToCart(product); // Agregar al carrito
                 // UserService().addProductToCurrentUser(
                  //  product.name,
                  //); // Agregar al historial de compras
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.name} agregado al carrito'),
                    ),
                  );
                },
                icon: Icon(Icons.add_shopping_cart),
                label: Text('Agregar al Carrito'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
