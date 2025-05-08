import 'package:flutter/material.dart';
import '../models/provider.dart';
import '../services/provider_service.dart';

class ProviderScreen extends StatefulWidget {
  const ProviderScreen({super.key});

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {
  final ProviderService _service = ProviderService();
  late Future<List<ProviderModel>> _providers;

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  void _loadProviders() {
    setState(() {
      _providers = _service.fetchProviders();
    });
  }

  void _showProviderForm({ProviderModel? provider}) {
    final nameController = TextEditingController(text: provider?.name ?? '');
    final lastNameController = TextEditingController(text: provider?.lastName ?? '');
    final emailController = TextEditingController(text: provider?.email ?? '');
    final stateController = TextEditingController(text: provider?.state ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(provider == null ? 'Agregar Proveedor' : 'Editar Proveedor'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nombre')),
              TextField(controller: lastNameController, decoration: InputDecoration(labelText: 'Apellido')),
              TextField(controller: emailController, decoration: InputDecoration(labelText: 'Correo')),
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
              final nuevoProveedor = ProviderModel(
                id: provider?.id ?? 0,
                name: nameController.text,
                lastName: lastNameController.text,
                email: emailController.text,
                state: stateController.text,
              );

              if (provider == null) {
                await _service.createProvider(nuevoProveedor);
              } else {
                await _service.editProvider(nuevoProveedor);
              }

              _loadProviders();
              Navigator.pop(context);
            },
            child: Text(provider == null ? 'Agregar' : 'Guardar'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(ProviderModel provider) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Eliminar Proveedor'),
        content: Text('¿Estás seguro de eliminar a ${provider.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              await _service.deleteProvider(provider.id);
              _loadProviders();
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
      appBar: AppBar(title: Text('Proveedores')),
      body: FutureBuilder<List<ProviderModel>>(
        future: _providers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar proveedores'));
          }
          final data = snapshot.data!;
          if (data.isEmpty) {
            return Center(child: Text('No hay proveedores'));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final provider = data[index];
              return ListTile(
                title: Text('${provider.name} ${provider.lastName}'),
                subtitle: Text(provider.email),
                onTap: () => _showProviderForm(provider: provider),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(provider),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProviderForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
