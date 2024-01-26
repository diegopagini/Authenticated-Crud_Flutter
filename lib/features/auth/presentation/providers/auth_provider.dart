import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

/// PROVIDER
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();

  return AuthNotifier(authRepository: authRepository);
});

/// NOTIFIER
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;

  AuthNotifier({required this.authRepository}) : super(AuthState());

  void loginUser(String email, String password) async {}

  void registerUser(
      {required String email,
      required String password,
      required String fullName}) async {}

  void checkAuthStatus() async {}
}

enum AuthStatus { checking, authenticated, notAuthenticated }

/// STATE
class AuthState {
  final AuthStatus authStatus;
  final String errorMessage;
  final User? user;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = ''});

  AuthState copyWith(
    AuthStatus? authStatus,
    String? errorMessage,
    User? user,
  ) =>
      AuthState(
          user: user ?? this.user,
          errorMessage: errorMessage ?? this.errorMessage,
          authStatus: authStatus ?? this.authStatus);
}
