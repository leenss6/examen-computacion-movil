import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  const TopBar({required this.searchController, required this.onSearchChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: TextField(
        controller: searchController,
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Buscar productos...',
          border: InputBorder.none,
          hintStyle: TextStyle(color: Color.fromARGB(179, 3, 3, 3)),
          icon: Icon(Icons.search, color: Colors.black),
        ),
        style: TextStyle(color: Colors.black),
        cursorColor: Colors.black,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.black),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No hay notificaciones nuevas')),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}