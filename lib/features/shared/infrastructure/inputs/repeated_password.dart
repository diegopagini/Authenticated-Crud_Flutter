import 'package:formz/formz.dart';

enum RepeatedPasswordError { notMatch, empty }

class RepeatedPassword extends FormzInput<String, RepeatedPasswordError> {
  final String? password;

  const RepeatedPassword.pure(this.password) : super.pure('');
  const RepeatedPassword.dirty(super.value, this.password) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == RepeatedPasswordError.empty) {
      return 'El campo es requerido';
    }
    if (displayError == RepeatedPasswordError.notMatch) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  @override
  RepeatedPasswordError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) {
      return RepeatedPasswordError.empty;
    }

    if (value != password.toString()) {
      return RepeatedPasswordError.notMatch;
    }

    return null;
  }
}
