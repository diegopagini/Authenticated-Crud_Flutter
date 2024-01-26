import '../entities/user.dart';

abstract class AuthDataSource {
  Future<User> login(String email, String password);
  Future<User> register(
      {required String email,
      required String password,
      required String fullName});

  Future<User> checkAuthStatus(String token);
}
