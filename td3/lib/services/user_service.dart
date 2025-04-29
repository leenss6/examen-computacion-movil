import '../models/user.dart';

class UserService {
  // Lista local para guardar los usuarios registrados
  List<User> _registeredUsers = [];

  // Método para registrar un nuevo usuario
  String? register(String email, String password) {
    // Validar si el email ya está registrado
    final userExists = _registeredUsers.any((user) => user.email == email);
    if (userExists) {
      return 'El email ya está registrado';
    }

    // Registrar nuevo usuario
    _registeredUsers.add(User(email: email, password: password));
    return null; // Registro exitoso (sin errores)
  }

  // Método para hacer login
  String? login(String email, String password) {
    final user = _registeredUsers.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () => User(email: '', password: ''),
    );

    if (user.email.isEmpty) {
      return 'Usuario o contraseña incorrectos';
    }
    return null; // Login exitoso (sin errores)
  }
}
