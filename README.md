<!-- @format -->

# Flutter - TesloShop

## BE

[Teslo Backend - Nest RestServer](https://hub.docker.com/repository/docker/klerith/flutter-backend-teslo-shop/general)


## Products

![image](https://github.com/diegopagini/Teslo_Flutter/assets/62857778/42b667ea-1a06-41a9-b2be-58c6a89434f5)


## Login

![image](https://github.com/diegopagini/Teslo_Flutter/assets/62857778/bf575d58-43e6-4519-9ab7-9fef8b4b6287)

### loginFormProvider

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
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
  LoginFormNotifier() : super(LoginFormState());

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

  onFormSubmit() {
    _touchEveryField();
    if (!state.isValid) return;

    print(state);
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
  return LoginFormNotifier();
});
```

### login_screen

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/providers/login_form_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: GeometricalBackground(
              child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            // Icon Banner
            const Icon(
              Icons.production_quantity_limits_rounded,
              color: Colors.white,
              size: 100,
            ),
            const SizedBox(height: 80),

            Container(
              height: size.height - 260, // 80 los dos sizebox y 100 el ícono
              width: double.infinity,
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(100)),
              ),
              child: const _LoginForm(),
            )
          ],
        ),
      ))),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginFormProvider); // State
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text('Login', style: textStyles.titleLarge),
          const SizedBox(height: 90),
          CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(loginFormProvider.notifier).onEmailChange,
            errorMessage:
                loginForm.isFormPosted ? loginForm.email.errorMessage : null,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            onChanged: ref.read(loginFormProvider.notifier).onPasswordChange,
            errorMessage:
                loginForm.isFormPosted ? loginForm.password.errorMessage : null,
          ),
          const SizedBox(height: 30),
          SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                text: 'Ingresar',
                buttonColor: Colors.black,
                onPressed: () {
                  ref.read(loginFormProvider.notifier).onFormSubmit();
                },
              )),
          const Spacer(flex: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿No tienes cuenta?'),
              TextButton(
                  onPressed: () => context.push('/register'),
                  child: const Text('Crea una aquí'))
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
```
