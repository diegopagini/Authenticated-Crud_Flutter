## Register

![image](https://github.com/diegopagini/Teslo_Flutter/assets/62857778/719c2b8e-8467-483e-8c89-455957d8586d)


### loginFormProvider

```dart
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
```

### login_screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: GeometricalBackground(
              child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Icon Banner
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      if (!context.canPop()) return;
                      context.pop();
                    },
                    icon: const Icon(Icons.arrow_back_rounded,
                        size: 40, color: Colors.white)),
                const Spacer(flex: 1),
                Text('Crear cuenta',
                    style:
                        textStyles.titleMedium?.copyWith(color: Colors.white)),
                const Spacer(flex: 2),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              height: size.height - 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(100)),
              ),
              child: const _RegisterForm(),
            )
          ],
        ),
      ))),
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerFormState = ref.watch(registerFormProvider);
    final textStyles = Theme.of(context).textTheme;
    final registerFormNotifier = ref.watch(registerFormProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text('Nueva cuenta', style: textStyles.titleMedium),
            const SizedBox(height: 30),
            CustomTextFormField(
              label: 'Nombre completo',
              keyboardType: TextInputType.emailAddress,
              errorMessage: registerFormState.isFormPosted
                  ? registerFormState.fullName.errorMessage
                  : null,
              onChanged: registerFormNotifier.onFullNameChange,
            ),
            const SizedBox(height: 30),
            CustomTextFormField(
              label: 'Correo',
              keyboardType: TextInputType.emailAddress,
              errorMessage: registerFormState.isFormPosted
                  ? registerFormState.email.errorMessage
                  : null,
              onChanged: registerFormNotifier.onEmailChange,
            ),
            const SizedBox(height: 30),
            CustomTextFormField(
              label: 'Contraseña',
              obscureText: true,
              errorMessage: registerFormState.isFormPosted
                  ? registerFormState.password.errorMessage
                  : null,
              onChanged: registerFormNotifier.onPasswordChange,
            ),
            const SizedBox(height: 30),
            CustomTextFormField(
              label: 'Repita la contraseña',
              obscureText: true,
              errorMessage: registerFormState.isFormPosted
                  ? registerFormState.repeatedPassword.errorMessage
                  : null,
              onChanged: registerFormNotifier.onRepeatedPasswordChange,
            ),
            const SizedBox(height: 30),
            SizedBox(
                width: double.infinity,
                height: 60,
                child: CustomFilledButton(
                  text: 'Crear',
                  buttonColor: Colors.black,
                  onPressed: () {
                    registerFormNotifier.onFormSubmit();
                  },
                )),
            Row(
              children: [
                const Text('¿Ya tienes cuenta?'),
                TextButton(
                    onPressed: () {
                      if (context.canPop()) {
                        return context.pop();
                      }
                      context.go('/login');
                    },
                    child: const Text('Ingresa aquí'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```
