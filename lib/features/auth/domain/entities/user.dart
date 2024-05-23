
class User {
  final String id;
  final String email;
  final String fullName;
  final List<String> rol;
  final String token;

  User({required this.id, required this.email, required this.fullName, required this.rol, required this.token});

  bool get isAdmin {
    return rol.contains('admin');
  }
}