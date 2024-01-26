import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiUrl));

  @override
  Future<User> checkAuthStatus(String token) async {
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio
          .post('/auth/login', data: {'email': email, 'password': password});

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            message: e.response?.data['message'] ?? 'Credenciales incorrectas');
      }

      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(message: 'Error de conexión');
      }

      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(
      {required String email,
      required String password,
      required String fullName}) async {
    try {
      final response = await dio.post('/auth/register',
          data: {'email': email, 'password': password, 'fullName': fullName});

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } catch (e) {
      throw UnimplementedError();
    }
  }
}
