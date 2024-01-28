import 'package:teslo_shop/features/auth/domain/domain.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) => User(
      roles: List<String>.from(json['roles'].map((role) => role)),
      email: json['email'],
      fullName: json['fullName'],
      id: json['id'],
      token: json['token'] ?? '');
}
