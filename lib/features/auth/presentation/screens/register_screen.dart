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
