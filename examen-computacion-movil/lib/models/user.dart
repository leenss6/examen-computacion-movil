class User {
  final String email;
  final String password;
  final List<String> products;

  User({required this.email, required this.password, this.products = const []});
}
