import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.searchController});

  final TextEditingController searchController;

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  String selectedCategory = 'ropa';

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void fetchProducts() async {
    try {
      final products = await ProductService().fetchProducts();
      setState(() {
        allProducts = products;
        filterByCategory(selectedCategory);
      });
    } catch (e) {
      print('Error al cargar productos: $e');
    }
  }

  void filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      filteredProducts = allProducts
          .where((p) => p.category.toLowerCase() == category.toLowerCase())
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CategoryButton(
                label: 'Ropa',
                isSelected: selectedCategory == 'ropa',
                onPressed: () => filterByCategory('ropa'),
              ),
              CategoryButton(
                label: 'Entretenimiento',
                isSelected: selectedCategory == 'entretenimiento',
                onPressed: () => filterByCategory('entretenimiento'),
              ),
              CategoryButton(
                label: 'Otros',
                isSelected: selectedCategory == 'otros',
                onPressed: () => filterByCategory('otros'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filteredProducts.isEmpty
                ? const Center(child: Text('No hay productos en esta categoría'))
                : ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return ProductCard(product: filteredProducts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const CategoryButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        elevation: isSelected ? 4 : 1,
      ),
      child: Text(label),
    );
  }
}
