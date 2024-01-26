import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class RegisterFormState {
  final bool isFormPosted;
  final bool isPosting;
  final bool isValid;
  final FullName fullName;
  final Email email;
  final Password password;
  final RepeatedPassword repeatedPassword;

  RegisterFormState(
      {this.isFormPosted = false,
      this.isPosting = false,
      this.isValid = false,
      this.fullName = const FullName.pure(),
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.repeatedPassword = const RepeatedPassword.pure('')});

  RegisterFormState copyWith({
    bool? isFormPosted,
    bool? isPosting,
    bool? isValid,
    FullName? fullName,
    Email? email,
    Password? password,
    RepeatedPassword? repeatedPassword,
  }) =>
      RegisterFormState(
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isPosting: isPosting ?? this.isPosting,
          isValid: isValid ?? this.isValid,
          fullName: fullName ?? this.fullName,
          email: email ?? this.email,
          password: password ?? this.password,
          repeatedPassword: repeatedPassword ?? this.repeatedPassword);

  @override
  String toString() {
    return '''
    isFormPosted: $isFormPosted,
    isPosting: $isPosting,
    isValid: $isValid,
    fullName: $fullName,
    email: $email,
    password: $password,
    repeatedPassword: $repeatedPassword,
    ''';
  }
}

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  RegisterFormNotifier() : super(RegisterFormState());

  onFullNameChange(String value) {
    final newFullName = FullName.dirty(value);
    state = state.copyWith(
        fullName: newFullName,
        isValid: Formz.validate([
          newFullName,
          state.password,
          state.repeatedPassword,
          state.email
        ]));
  }

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail,
        isValid: Formz.validate([
          newEmail,
          state.password,
          state.repeatedPassword,
          state.fullName
        ]));
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([
          newPassword,
          state.email,
          state.fullName,
          state.repeatedPassword
        ]));
  }

  onRepeatedPasswordChange(String value) {
    final newPasswordRepeated =
        RepeatedPassword.dirty(value, state.password.value);
    state = state.copyWith(
        repeatedPassword: newPasswordRepeated,
        isValid: Formz.validate([
          newPasswordRepeated,
          state.email,
          state.fullName,
          state.password
        ]));
  }

  onFormSubmit() {
    _touchEveryField();
    if (!state.isValid) return;

    print(state);
  }

  _touchEveryField() {
    final fullName = FullName.dirty(state.fullName.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final repeatedPassword = RepeatedPassword.dirty(
        state.repeatedPassword.value, state.password.value);

    state = state.copyWith(
        isFormPosted: true,
        fullName: fullName,
        email: email,
        password: password,
        repeatedPassword: repeatedPassword,
        isValid: Formz.validate([email, password, fullName, repeatedPassword]));
  }
}

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  return RegisterFormNotifier();
});
