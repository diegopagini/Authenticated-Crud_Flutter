class User {
  final List<String> roles;
  final String email;
  final String fullName;
  final String id;
  final String token;

  User(
      {required this.roles,
      required this.email,
      required this.fullName,
      required this.id,
      required this.token});

  bool get isAdmin {
    return roles.contains('admin');
  }
}
