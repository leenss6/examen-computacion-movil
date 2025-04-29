import 'package:flutter/material.dart';
import '../helpers/validators.dart';
import '../services/user_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserService _userService = UserService(); // Servicio local de usuarios

  void _login() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      String? result = _userService.login(email, password);

      if (result == null) {
        // Login exitoso -> Navegar a Home
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Error en login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
    }
  }

  void _navigateToRegister() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Campo de Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                validator: Validators.validateEmail,
              ),
              SizedBox(height: 16),

              // Campo de Password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Contraseña'),
                validator: Validators.validatePassword,
              ),
              SizedBox(height: 24),

              // Botón Login
              ElevatedButton(
                onPressed: _login,
                child: Text('Ingresar'),
              ),
              SizedBox(height: 16),

              // Botón para ir a Registro
              TextButton(
                onPressed: _navigateToRegister,
                child: Text('¿No tienes cuenta? Regístrate'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
