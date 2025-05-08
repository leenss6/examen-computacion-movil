import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';
import 'package:intl/intl.dart';


class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  double _calcularTotal() {
  return _cartService.items.fold(0, (total, item) => total + (item.product.price * item.quantity));
}

  void _removeItem(CartItem item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar producto'),
        content: Text('¿Estás seguro de que quieres eliminar ${item.product.name}?'),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Eliminar'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _cartService.removeFromCart(item.product);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${item.product.name} eliminado del carrito')),
      );
    }
  }

  void _purchase() {
    List<String> results = _cartService.purchase();

    String fullMessage = results.join('\n');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Resultado de la compra'),
        content: Text(fullMessage),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {}); // Refrescar pantalla (carrito vacío si fue exitoso)
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = _cartService.items;

    return Scaffold(
      body: cartItems.isEmpty
          ? Center(child: Text('El carrito está vacío'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: ListTile(
                          leading: Image.network(
                            item.product.imageUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.image_not_supported);
                            },
                          ),
                          title: Text(item.product.name),
                          subtitle: Text('Cantidad: ${item.quantity}\nStock disponible: ${item.product.stock}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeItem(item),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Total a pagar: \$${NumberFormat('#,###', 'es_CL').format(_calcularTotal().round())}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: _purchase,
                    icon: Icon(Icons.payment),
                    label: Text('Comprar Todo'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
