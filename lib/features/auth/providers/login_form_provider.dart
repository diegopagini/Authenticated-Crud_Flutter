import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';

// 1 - Provider State
class LoginFormState {
  final bool isFormPosted;
  final bool isPosting;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState(
      {this.isFormPosted = false,
      this.isPosting = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure()});

  LoginFormState copyWith({
    bool? isFormPosted,
    bool? isPosting,
    bool? isValid,
    Email? email,
    Password? password,
  }) =>
      LoginFormState(
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isPosting: isPosting ?? this.isPosting,
          isValid: isValid ?? this.isValid,
          email: email ?? this.email,
          password: password ?? this.password);

  @override
  String toString() {
    return '''
      LoginFormState:
        isFormPosted: $isFormPosted,
        isPosting: $isPosting,
        isValid: $isValid,
        email: $email,
        password: $password,
        ''';
  }
}

// 2 - Notifier implementation
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Function(String, String) loginUserCallback;

  LoginFormNotifier({required this.loginUserCallback})
      : super(LoginFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail, isValid: Formz.validate([newEmail, state.password]));
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([newPassword, state.email]));
  }

  onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return;

    await loginUserCallback(state.email.value, state.password.value);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        isValid: Formz.validate([email, password]));
  }
}

// 3 - Consume provider
final loginFormProvider =
    StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  // autoDispose to destroy the state every time the user leaves this page
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;

  return LoginFormNotifier(loginUserCallback: loginUserCallback);
});
