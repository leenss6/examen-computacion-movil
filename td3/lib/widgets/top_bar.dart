import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  TopBar({required this.searchController, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: TextField(
        controller: searchController,
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Buscar productos...',
          border: InputBorder.none,
          hintStyle: TextStyle(color: const Color.fromARGB(179, 3, 3, 3)),
          icon: Icon(Icons.search, color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
        cursorColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No hay notificaciones nuevas')),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
