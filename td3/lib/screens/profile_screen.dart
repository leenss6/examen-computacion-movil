import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await UserService().getCurrentUser();
    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  Future<void> _logout() async {
    await UserService().logout();
    Navigator.pushReplacementNamed(
      context,
      '/login',
    ); // Ajusta si usas otra ruta
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil de usuario')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Correo: ${_user!.email}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Productos:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ..._user!.products.map((p) => Text('• $p')).toList(),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Cerrar sesión'),
                    ),
                  ],
                ),
              ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUser(); // Vuelve a cargar el usuario al regresar
  }
}
